`timescale 1ns / 1ps
import common::*;

module datamem_interface(
    input clk,
    input [9:0] byte_address,
    input [31:0] write_data,
    input control_type control_in,
    input decoding_fields_type decoding_fields,
    output logic [31:0] read_data,
    output logic memory_exception
    );
    logic [3:0] byte_enable;
    logic [31:0] shifted_mem_read_data;
    logic [31:0] mem_write_data;
    logic [31:0] mem_read_data;
    logic sign_extention_bit;
    
    data_memory inst_mem (
      .clk(clk),
      .mem_byte_address(byte_address),
      .mem_write_enable(control_in.mem_write),
      .mem_read_enable(control_in.mem_read),
      .mem_byte_enable(byte_enable),
      .mem_write_data(mem_write_data),
      .mem_read_data(mem_read_data)
    );

    always_comb begin : set_byte_enable
    memory_exception = 0;
    byte_enable = 4'b0000;
    //byte_enable selects which bytes are read from or written to. byte_enbale is then shifted acourding to excel sheet
    if (control_in.mem_read || control_in.mem_write) begin
      case (decoding_fields.funct3[1:0])
        2'b00: byte_enable = 4'b0001 << byte_address[1:0]; //lb / sb / lbu

        2'b01: begin //lh / sh / lhu
          byte_enable = 4'b0011 << byte_address[1:0]; 
          if (byte_address[0] == 0) begin //Memory address unaligned
            memory_exception = 1;
          end

        end

        2'b10: begin //lw / sw
          byte_enable = 4'b1111; 
          if (byte_address[1:0] == 2'b00) begin //Memory address unaligned
            memory_exception = 1;
          end
        end

        default: byte_enable = 4'b0000;
    endcase
    end
    

  end

  always_comb begin : write
    mem_write_data = 32'b0;
    if (control_in.mem_write) begin
      mem_write_data = write_data << (8*byte_address[1:0]);
    end
    
  end

  always_comb begin : read
    shifted_mem_read_data = 32'b0;
    read_data = 32'b0;
    if (control_in.mem_read) begin
      shifted_mem_read_data = mem_read_data >> (8*byte_address[1:0]);
      case (decoding_fields.funct3)
        3'b100: read_data = {{24{1'b0}},{shifted_mem_read_data}}; //lbu
        3'b101: read_data = {{16{1'b0}},{shifted_mem_read_data}}; //lhu
        3'b000: read_data = {{24{shifted_mem_read_data[7]}},{shifted_mem_read_data[7:0]}}; //lb
        3'b001: read_data = {{16{shifted_mem_read_data[15]}},{shifted_mem_read_data[15:0]}}; //lh
      
        default: read_data = shifted_mem_read_data
  ;
      endcase
    end
    
  end

endmodule
