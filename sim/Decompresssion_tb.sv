`timescale 1ns / 1ps
import common::*;

module Decompression_tb();

  // Inputs
  logic [15:0] c_inst;

  // Outputs
  logic [31:0] dec_inst;


  instruction_type decoded_instr;
  encoding_type et;
  logic signed [31:0] immidiate_value;

  // Instantiate the Unit Under Test (UUT)
  Decompression uut (
    .c_inst(c_inst),
    .dec_inst(dec_inst)
  );

  // Task to display instruction data in readable format
  task print_instruction;
    input [15:0] comp;
    input [31:0] decomp;
    begin
      $display("Compressed: %b | Decompressed: %b", comp, decomp);
    end
  endtask

  task print_immidiate;
    input [31:0] expected_immidiate;
    input [31:0] real_immidiate;
    begin
      $display("Expected immidiate: %b | Got: %b", expected_immidiate, real_immidiate);
    end
  endtask

  initial begin
    $display("Starting Decompression Testbench...");
    
    // Example test: c.j instruction (compressed jump)
    // Format: [15:13]=101 (c.j), [1:0]=01 (opcode)
    // The middle bits [12:2] represent the immediate value

    // Test 1: Sample compressed jump instruction
    c_inst = 16'b1010000000110001; // opcode=01, funct3=101, rest=immediate     //c.j x8 12
    et = J_TYPE;
    immidiate_value = 32'h0000000C;
    #1;
    print_instruction(c_inst, dec_inst);
    decoded_instr = instruction_type'(dec_inst);
    print_immidiate(immediate_extension(decoded_instr,et), immidiate_value);
    c_inst = 16'b1011111100000101; // opcode=01, funct3=101, rest=immediate     //c.j -208
    et = J_TYPE;
    immidiate_value = -208;
    #1;
    print_instruction(c_inst, dec_inst);
    decoded_instr = instruction_type'(dec_inst);
    print_immidiate(immidiate_value, immediate_extension(decoded_instr,et));


    c_inst = 16'b1100010000001101; // c.beqz x8 42
    et = B_TYPE;
    immidiate_value = 42;
    #1;
    print_instruction(c_inst, dec_inst);
    decoded_instr = instruction_type'(dec_inst);
    print_immidiate(immediate_extension(decoded_instr,et), immidiate_value);
    c_inst = 16'b1101000000110001; // c.beqz x8 -188
    et = B_TYPE;
    immidiate_value = -188;
    #1;
    print_instruction(c_inst, dec_inst);
    decoded_instr = instruction_type'(dec_inst);
    print_immidiate(immediate_extension(decoded_instr,et), immidiate_value);

    $display("Testbench complete.");
    $finish;
  end

endmodule