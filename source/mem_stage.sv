`timescale 1ns / 1ps
import common::*;

module mem_stage (
    input clk,
    input reset_n,
    input [31:0] alu_data_in,
    input [31:0] memory_data_in,
    input control_type control_in,
    input decoding_fields_type decoding_fields,
    output control_type control_out,
    output logic [31:0] memory_data_out,
    output logic [31:0] alu_data_out,
    output logic memory_exception
);

  logic [9:0] byte_address;
  assign byte_address = alu_data_in[9:0];
  logic interface_exception;

  always_comb begin
    memory_exception = interface_exception;
    if (control_in.mem_read && alu_data_in[31:10]>1 || control_in.mem_write && alu_data_in[31:10]>1) begin
      memory_exception = 1;
    end
  end
  //assign write_data = memory_data_in << (8*byte_address[1:0]); //Shift the write_data to correct bytes
  datamem_interface inst_datamem_interface (
    .clk(clk),
    .byte_address(byte_address),
    .write_data(memory_data_in),
    .control_in(control_in),
    .decoding_fields(decoding_fields),
    .read_data(memory_data_out),
    .memory_exception(interface_exception)
  );

  assign alu_data_out = alu_data_in;
  assign control_out  = control_in;

endmodule
