`timescale 1ns / 1ps

import common::*;


module decode_stage (
    input clk,
    input reset_n,
    input instruction_type instruction,
    input logic write_en,
    input logic [4:0] write_id,
    input logic [31:0] write_data,
    input is_compressed_instruction,
    output logic [4:0] reg_rd_id,
    output logic [4:0] reg_rs1_id,
    output logic [4:0] reg_rs2_id,
    output logic [31:0] read_data1,
    output logic [31:0] read_data2,
    output logic [31:0] immediate_data,
    output control_type control_signals,
    output logic decode_exception,
    output decoding_fields_type decoding_fields,
    //temp
    output instruction_name instruction_dec
);

  logic [31:0] rf_read_data1;
  logic [31:0] rf_read_data2;
  instruction_type decompressed_or_rv32i_instruction;

  //compressed
  logic [15:0] compressed_instruction;
  logic Decompression_exception;
  logic compressed_activate;
  logic [31:0] decompressed_instruction;

  assign compressed_instruction = instruction[15:0];

  control_type controls;
  logic control_exception;
  //temp
  instruction_name instruction_name;

  register_file rf_inst (
      .clk(clk),
      .reset_n(reset_n),
      .write_en(write_en),
      .read1_id(decompressed_or_rv32i_instruction.rs1),
      .read2_id(decompressed_or_rv32i_instruction.rs2),
      .write_id(write_id),
      .write_data(write_data),
      .read1_data(rf_read_data1),
      .read2_data(rf_read_data2)
  );


  control inst_control (
      .clk(clk),
      .reset_n(reset_n),
      .instruction(decompressed_or_rv32i_instruction),
      .control(controls),
      .control_exception(control_exception),
      //temp
      .instruction_n(instruction_name)
  );

  Decompression Decompression_inst (
      .c_inst(compressed_instruction),
      .activate(compressed_activate),
      .dec_inst(decompressed_instruction),
      .c_decoding_exception(Decompression_exception)
  );

  always_comb begin 
    //Decompression
    decompressed_or_rv32i_instruction = instruction;
    compressed_activate = 0;
     if (is_compressed_instruction) begin
      compressed_activate = 1;
      decompressed_or_rv32i_instruction = decompressed_instruction;
    end
  end



  always_comb begin : Forwadring_reg_data
    read_data1 = rf_read_data1;
    read_data2 = rf_read_data2;
    if (write_en && (write_id == reg_rs1_id)) begin
      read_data1 = write_data;
    end
    if (write_en && (write_id == reg_rs2_id)) begin
      read_data2 = write_data;
    end

    if (!reset_n) begin
      decode_exception = '0;
    end else begin
      decode_exception = control_exception;
    end
  end

  assign control_signals = controls;
  assign reg_rd_id = decompressed_or_rv32i_instruction.rd;
  assign reg_rs1_id = decompressed_or_rv32i_instruction.rs1;
  assign reg_rs2_id = decompressed_or_rv32i_instruction.rs2;
  assign immediate_data = immediate_extension(decompressed_or_rv32i_instruction, controls.encoding);
  assign decoding_fields.funct3 = decompressed_or_rv32i_instruction.funct3;
  assign decoding_fields.funct7 = decompressed_or_rv32i_instruction.funct7; 
  //temp
  assign instruction_dec = instruction_name;

endmodule
