`timescale 1ns / 1ps

import common::*;


module cpu (
    input clk,
    input reset_n,
    input io_data_valid,
    input [7:0] io_data_packet,
    input new_instruction_write_enable,
    input program_clear_ram,
    output [1:0] exception
);
  localparam GHR_SIZE = 5;

  logic [1:0] exception_cur, exception_nxt;

  //addresser för program_mem
  logic [31:0] program_mem_address;
  logic [31:0] write_program_mem_address;
  logic [31:0] read_program_mem_address;
  logic is_compressed;

  logic program_mem_write_enable;
  logic [15:0] program_mem_write_data;
  logic [31:0] program_mem_read_data;

  logic fetch_branch_prediction_MSB;
  logic fetch_is_compressed_instruction;
  logic [GHR_SIZE-1:0] fetch_ghr;
  logic [GHR_SIZE-1:0] fetch_shared_index;

  logic [4:0] decode_reg_rd_id;
  logic [4:0] decode_reg_rs1_id;
  logic [4:0] decode_reg_rs2_id;
  logic [31:0] decode_data1;
  logic [31:0] decode_data2;
  logic [31:0] decode_immediate_data;
  control_type decode_control;
  decoding_fields_type decode_decoding_fields;

  logic [31:0] execute_alu_data;
  control_type execute_control;
  logic [31:0] execute_memory_data;
  branch_decision_signals_type execute_branch_decision_signals;
  logic [31:0] execute_target_address;

  logic [31:0] memory_memory_data;
  logic [31:0] memory_alu_data;
  logic memory_PCSrc;
  logic memory_is_taken_branch;
  control_type memory_control;

  logic [4:0] wb_reg_rd_id;
  logic [31:0] wb_result;
  logic wb_write_back_en;

  if_id_type if_id_reg;
  id_ex_type id_ex_reg;
  ex_mem_type ex_mem_reg;
  mem_wb_type mem_wb_reg;

  //Fording
  logic [1:0] Forward_unit_ForwardA;
  logic [1:0] Forward_unit_ForwardB;

  // Hazard detection
  logic hazard_PCWrite_n;
  logic hazard_is_data_stall;
  logic hazard_if_id_Write_n;
  logic hazard_is_control_hazard;

  //EXCEPTIONS
  logic ID_exception;
  logic EX_exception;

  //Branch_evaluation_unit
  BEU_output_type BEU_output;

  //temp
  instruction_name id_instruction;
  instruction_name ex_instruction;
  instruction_name mem_instruction;
  instruction_name wb_instruction;

  always_ff @(posedge clk) begin
    if (!reset_n) begin
      if_id_reg <= '0;
      id_ex_reg <= '0;
      ex_mem_reg <= '0;
      mem_wb_reg <= '0;
      exception_cur <= '0;

      //temp
      ex_instruction <= noinst;
      mem_instruction <= noinst;
      wb_instruction <= noinst;

    end else begin
      exception_cur <= exception_nxt;

      //if_id_reg.pc <= program_mem_address;
      //if_id_reg.instruction <= program_mem_read_data;
      // In case of hazard. Keep the same data in IF/ID
      // and control signals to ex needs to be zero
      if_id_reg.pc <= program_mem_address;
      if_id_reg.branch_prediction <= fetch_branch_prediction_MSB; 
      if_id_reg.instruction <= program_mem_read_data;
      if_id_reg.ghr <= fetch_ghr;
      if_id_reg.shared_index <= fetch_shared_index;
      if_id_reg.is_compressed_instruction <= fetch_is_compressed_instruction;
      ex_instruction <= id_instruction;       // Temp


      id_ex_reg.pc <= if_id_reg.pc;
      id_ex_reg.branch_prediction <= if_id_reg.branch_prediction;
      id_ex_reg.reg_rd_id <= decode_reg_rd_id;
      id_ex_reg.reg_rs1_id <= decode_reg_rs1_id;
      id_ex_reg.reg_rs2_id <= decode_reg_rs2_id;
      id_ex_reg.data1 <= decode_data1;
      id_ex_reg.data2 <= decode_data2;
      id_ex_reg.immediate_data <= decode_immediate_data;
      id_ex_reg.control <= decode_control;
      id_ex_reg.decoding_fields <= decode_decoding_fields;
      id_ex_reg.ghr <= if_id_reg.ghr;
      id_ex_reg.shared_index <= if_id_reg.shared_index;
      id_ex_reg.is_compressed_instruction <= if_id_reg.is_compressed_instruction;
      ex_instruction <= id_instruction;  //temp

      ex_mem_reg.pc <= id_ex_reg.pc;
      ex_mem_reg.reg_rd_id <= id_ex_reg.reg_rd_id;
      ex_mem_reg.branch_prediction <= id_ex_reg.branch_prediction;
      ex_mem_reg.control <= execute_control;
      ex_mem_reg.decoding_fields <= id_ex_reg.decoding_fields;
      ex_mem_reg.alu_data <= execute_alu_data;
      ex_mem_reg.memory_data <= execute_memory_data;
      //Branching/jumps
      ex_mem_reg.target_address <= execute_target_address;
      ex_mem_reg.branch_decision_signals <= execute_branch_decision_signals;
      ex_mem_reg.ghr <= id_ex_reg.ghr;
      ex_mem_reg.shared_index <= id_ex_reg.shared_index;
      ex_mem_reg.is_compressed_instruction <= id_ex_reg.is_compressed_instruction;
      mem_instruction <= ex_instruction;  //temp

      mem_wb_reg.reg_rd_id <= ex_mem_reg.reg_rd_id;
      mem_wb_reg.memory_data <= memory_memory_data;
      mem_wb_reg.alu_data <= memory_alu_data;
      mem_wb_reg.control <= memory_control;
      wb_instruction <= mem_instruction;  //temp

      if (hazard_if_id_Write_n) begin //When 0 its write_enable. When 1, keep the same value
        if_id_reg.pc <= if_id_reg.pc;
        if_id_reg.instruction <= if_id_reg.instruction;
        ex_instruction <= nop; // temp
      end

      if (hazard_is_data_stall) begin
        id_ex_reg.control <= '0;
        ex_instruction <= nop; //temp
      end

      if (hazard_is_control_hazard) begin //control hazards take presidence
        id_ex_reg.control <= '0;
        ex_mem_reg.control <= '0;
        if_id_reg <= NOP; //IF.flush
        ex_instruction <= nop; //temp
        mem_instruction <= nop; //temp
      end
    end
  end


  program_memory inst_mem (
      .clk(clk),
      .byte_address(program_mem_address),
      .write_enable(program_mem_write_enable),
      .write_data(program_mem_write_data),
      .new_instruction_write_enable(new_instruction_write_enable),
      .clear_ram(program_clear_ram),
      .is_compressed(is_compressed),
      .read_data(program_mem_read_data)
  );

  uart_decoder inst_uart_decoder (
    .clk(clk),
    .reset_n(reset_n),
    .io_data_valid(io_data_valid),
    .io_data_packet(io_data_packet),
    .instruction_word(program_mem_write_data),
    .byte_address(write_program_mem_address),
    .word_valid(program_mem_write_enable)
  );

  // Decides which address is used
  always_comb begin
      if (new_instruction_write_enable) begin
        program_mem_address <= write_program_mem_address;
      end else begin
      program_mem_address <= read_program_mem_address;
    end
  end

  always_comb begin : set_exception
    if (ID_exception) begin
      exception_nxt = 2'b01;
    end else if (EX_exception) begin
      exception_nxt = 2'b10;
    end else begin
      exception_nxt = 2'b00;
    end
  end


  fetch_stage inst_fetch_stage (
      .clk(clk),
      .reset_n(reset_n),
      .target_address(ex_mem_reg.target_address),
      .mem_pc(ex_mem_reg.pc),
      .restore_ghr(ex_mem_reg.ghr),
      .update_shared_index(ex_mem_reg.shared_index),
      .PCWrite_n(hazard_PCWrite_n),
      .BEU_signals(BEU_output),
      .new_instruction_write_enable(new_instruction_write_enable),
      .instruction(program_mem_read_data),
      .is_compressed_instruction(is_compressed),
      .address(read_program_mem_address),
      .branch_prediction_MSB(fetch_branch_prediction_MSB),
      .ghr(fetch_ghr),
      .shared_index(fetch_shared_index),
      .fetch_is_compressed_instruction(fetch_is_compressed_instruction)
  );


  decode_stage inst_decode_stage (
      .clk(clk),
      .reset_n(reset_n),
      .instruction(if_id_reg.instruction),
      .write_en(wb_write_back_en),
      .write_id(wb_reg_rd_id),
      .write_data(wb_result),
      .is_compressed_instruction(if_id_reg.is_compressed_instruction),
      .reg_rd_id(decode_reg_rd_id),
      .reg_rs1_id(decode_reg_rs1_id),
      .reg_rs2_id(decode_reg_rs2_id),
      .read_data1(decode_data1),
      .read_data2(decode_data2),
      .immediate_data(decode_immediate_data),
      .control_signals(decode_control),
      .decoding_fields(decode_decoding_fields),
      .decode_exception(ID_exception),
      .instruction_dec(id_instruction) //temp
  );


  execute_stage inst_execute_stage (
      .clk(clk),
      .reset_n(reset_n),
      .data1(id_ex_reg.data1),
      .data2(id_ex_reg.data2),
      .immediate_data(id_ex_reg.immediate_data),
      .control_in(id_ex_reg.control),
      .decoding_fields(id_ex_reg.decoding_fields),
      .ForwardA(Forward_unit_ForwardA),  //control signal
      .ForwardB(Forward_unit_ForwardB),  //control signal
      .EX_MEM_forward_data(ex_mem_reg.alu_data),
      .MEM_WB_forward_data(wb_result),
      .pc(id_ex_reg.pc),
      .is_compressed_instruction(id_ex_reg.is_compressed_instruction),
      .control_out(execute_control),
      .alu_data(execute_alu_data),
      .memory_data(execute_memory_data),
      .ex_branch(execute_branch_decision_signals),
      .execute_exception(EX_exception),
      .target_address(execute_target_address)
  );


  mem_stage inst_mem_stage (
      .clk(clk),
      .reset_n(reset_n),
      .alu_data_in(ex_mem_reg.alu_data),
      .memory_data_in(ex_mem_reg.memory_data),
      .control_in(ex_mem_reg.control),
      .decoding_fields(ex_mem_reg.decoding_fields),
      .control_out(memory_control),
      .memory_data_out(memory_memory_data),
      .alu_data_out(memory_alu_data)
  );

  Forwarding_unit inst_Forwading_unit (
      .EX_MEM_Rd(ex_mem_reg.reg_rd_id),
      .MEM_WB_Rd(mem_wb_reg.reg_rd_id),
      .ID_EX_Rs1(id_ex_reg.reg_rs1_id),
      .ID_EX_Rs2(id_ex_reg.reg_rs2_id),
      .EX_MEM_Regwrite(ex_mem_reg.control.reg_write),
      .MEM_WB_Regwrite(mem_wb_reg.control.reg_write),
      .ForwardA(Forward_unit_ForwardA),
      .ForwardB(Forward_unit_ForwardB)
  );

  hazard_detection_unit hazard_det (
      .id_ex_mem_read(id_ex_reg.control.mem_read),
      .id_ex_register_rd(id_ex_reg.reg_rd_id),
      .if_id_register_1(if_id_reg.instruction.rs1),
      .if_id_register_2(if_id_reg.instruction.rs2),
      .BEU_output(BEU_output),
      .PCWrite_n(hazard_PCWrite_n),
      .if_id_Write_n(hazard_if_id_Write_n),
      .is_data_stall(hazard_is_data_stall),
      .is_control_hazard(hazard_is_control_hazard)
  );
  branch_evaluation_unit branch_evaluation (
      .branch_decision_signals(ex_mem_reg.branch_decision_signals),
      .mem_control_signals(ex_mem_reg.control),
      .branch_prediction(id_ex_reg.branch_prediction),
      .ex_address(id_ex_reg.pc),
      .target_address(ex_mem_reg.target_address),
      .is_compressed_instruction(ex_mem_reg.is_compressed_instruction),
      .BEU_output(BEU_output)
  );


  assign wb_reg_rd_id = mem_wb_reg.reg_rd_id;
  assign wb_write_back_en = mem_wb_reg.control.reg_write;
  assign wb_result = mem_wb_reg.control.mem_to_reg ? mem_wb_reg.memory_data : mem_wb_reg.alu_data;
  assign exception = exception_cur;

endmodule
