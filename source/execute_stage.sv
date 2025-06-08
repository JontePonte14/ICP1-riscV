`timescale 1ns / 1ps

import common::*;


module execute_stage (
    input clk,
    input reset_n,
    input [31:0] data1,
    input [31:0] data2,
    input [31:0] immediate_data,
    input control_type control_in,
    input decoding_fields_type decoding_fields,
    input [1:0] ForwardA,
    input [1:0] ForwardB,
    input [31:0] EX_MEM_forward_data,
    input [31:0] MEM_WB_forward_data,
    input [31:0] pc,
    input is_compressed_instruction,
    output control_type control_out,
    output logic [31:0] alu_data,
    output logic [31:0] memory_data,
    output branch_decision_signals_type ex_branch,
    output logic execute_exception,
    output logic [31:0] target_address
);


  logic [31:0] left_operand;
  logic [31:0] right_operand;
  logic ALU_control_exception;
  logic [3:0] AlU_control;
  logic ex_zero_flag;
  logic [31:0] ex_branch_adress;
  logic ex_branch_condition;
  logic [31:0] inst_alu_data_out;
  logic funct7_b6;
  assign funct7_b6 = decoding_fields.funct7[5];

  always_comb begin : operand_selector
    left_operand  = data1;
    right_operand = data2;
    if(ForwardA == 2'b00) begin
      left_operand  = data1;
    end
    else if (ForwardA == 2'b10) begin
      left_operand = EX_MEM_forward_data;
    end
    else if (ForwardA == 2'b01) begin
      left_operand = MEM_WB_forward_data;
    end

    if(ForwardB == 2'b00) begin
      right_operand = data2;
    end
    else if (ForwardB == 2'b10) begin
      right_operand = EX_MEM_forward_data;
    end
    else if (ForwardB == 2'b01) begin
      right_operand = MEM_WB_forward_data;
    end
    memory_data = right_operand;

    if(control_in.alu_src) begin
      right_operand = immediate_data;
    end

    // Special case for auipc
    if (control_in.is_auipc) begin
      left_operand  = pc;
    // Special case for lui instruction
    end else if (control_in.is_lui) begin
      left_operand  = 31'b0;
    end

    // Special case if unconditional jumps (jal & jalr)
    // reg1 is set by default or by forwarding
    // jal
    if (!control_in.is_jalr && control_in.is_unconditional_jump) begin
      right_operand = immediate_data;
      left_operand = pc;
    end else if (control_in.is_jalr && control_in.is_unconditional_jump) begin
      //left_operand = immediate_data;
      right_operand = immediate_data;
      //rs1 is set above as, default data1
    end

  end

  always_comb begin : branch_and_jump_adder
    //adding mux to minimize switching
    target_address = pc;
    alu_data = inst_alu_data_out;
    // if(control_in.is_branch) begin
    if(control_in.is_branch && !control_in.is_unconditional_jump) begin
      target_address = pc + immediate_data;
    end
    //else if (control_in.is_unconditional_jump) begin 
    else if (control_in.is_branch && control_in.is_unconditional_jump) begin 
      target_address = inst_alu_data_out;
      
      if (is_compressed_instruction) begin
        alu_data = pc + 2;
      end
      else begin
        alu_data = pc + 4;
      end
      
    end
    else begin
      target_address = pc;
    end
  end



  alu inst_alu (
      .control(AlU_control),
      .left_operand(left_operand),
      .right_operand(right_operand),
      .zero_flag(ex_zero_flag),
      .result(inst_alu_data_out)
  );
  ALU_control inst_ALU_control (
      .ALUOp(control_in.alu_op),
      .funct7_b6(funct7_b6),
      .funct3(decoding_fields.funct3),
      .ALU_control(AlU_control),
      .ALU_control_exception(ALU_control_exception),
      .branch_condition(ex_branch_condition)
  );

  assign execute_exception = ALU_control_exception;
  assign control_out = control_in;

  assign ex_branch.zero_flag = ex_zero_flag;
  assign ex_branch.branch_condition = ex_branch_condition;

endmodule