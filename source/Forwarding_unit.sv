`timescale 1ns / 1ps


module Forwarding_unit (
    input logic [4:0] EX_MEM_Rd,
    input logic [4:0] MEM_WB_Rd,
    input logic [4:0] ID_EX_Rs1,
    input logic [4:0] ID_EX_Rs2,
    input logic EX_MEM_Regwrite,
    input logic MEM_WB_Regwrite,
    output logic [1:0] ForwardA,
    output logic [1:0] ForwardB
);
  always_comb begin
    ForwardA = 2'b00;
    ForwardB = 2'b00;

    if (EX_MEM_Regwrite && (EX_MEM_Rd != 5'b0) && (EX_MEM_Rd == ID_EX_Rs1)) begin
      ForwardA = 2'b10;
    end
    if (EX_MEM_Regwrite && (EX_MEM_Rd != 5'b0) && (EX_MEM_Rd == ID_EX_Rs2)) begin
      ForwardB = 2'b10;
    end
    if (MEM_WB_Regwrite && (MEM_WB_Rd != 5'b0) &&
            !(EX_MEM_Regwrite && (EX_MEM_Rd != 5'b0) && (EX_MEM_Rd == ID_EX_Rs1)) &&
            (MEM_WB_Rd == ID_EX_Rs1)) begin
      ForwardA = 2'b01;
    end

    if (MEM_WB_Regwrite && (MEM_WB_Rd != 5'b0) &&
            !(EX_MEM_Regwrite && (EX_MEM_Rd != 5'b0) && (EX_MEM_Rd == ID_EX_Rs2)) &&
            (MEM_WB_Rd == ID_EX_Rs2)) begin
      ForwardB = 2'b01;
    end

  end
endmodule
