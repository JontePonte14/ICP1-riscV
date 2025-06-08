`timescale 1ns / 1ps
import common::*;
module ALU_control (
    input [1:0] ALUOp,
    input funct7_b6,
    input [2:0] funct3,
    output logic [3:0] ALU_control,
    output logic ALU_control_exception,
    output logic branch_condition
);
always_comb begin
    ALU_control_exception = 0;
    ALU_control = ALU_ADD; // Use the enum value directly
    branch_condition = 0;
    if (ALUOp == 2'b00) begin
        ALU_control = ALU_ADD; // Use the enum value directly
    end
    
    else if (ALUOp == 2'b10) begin //R-type
        case ({funct7_b6, funct3})
            4'b1000: ALU_control = ALU_SUB;
            4'b1101: ALU_control = ALU_SRA;
            4'b0000: ALU_control = ALU_ADD;
            4'b0001: ALU_control = ALU_SLL;
            4'b0010: ALU_control = ALU_SLT;
            4'b0011: ALU_control = ALU_SLTU;
            4'b0100: ALU_control = ALU_XOR;
            4'b0101: ALU_control = ALU_SRL;
            4'b0110: ALU_control = ALU_OR;
            4'b0111: ALU_control = ALU_AND;
            default: ALU_control_exception = 1;
        endcase
    end

    else if (ALUOp == 2'b01) begin //B-type
        case (funct3)
            3'b000: begin ALU_control = ALU_SUB;
                branch_condition = 1;
            end
            3'b001: ALU_control = ALU_SUB;
            3'b100: ALU_control = ALU_SLT;
            3'b101: begin ALU_control = ALU_SLT;
                branch_condition = 1;
            end
            3'b110: ALU_control = ALU_SLTU;
            3'b111: begin  ALU_control = ALU_SLTU;
                branch_condition = 1;
            end 
            default: ALU_control_exception = 1;
        endcase
    end
    else if (ALUOp == 2'b11) begin //I type
        if (funct3 == 3'b001 || funct3 == 3'b101) begin
            case ({funct7_b6, funct3})
                4'b0001: ALU_control = ALU_SLL;
                4'b0101: ALU_control = ALU_SRL;
                4'b1101: ALU_control = ALU_SRA;
                default: ALU_control_exception = 1;
            endcase
        end
        else begin
            case (funct3)
                3'b000: ALU_control = ALU_ADD;
                3'b010: ALU_control = ALU_SLT;
                3'b011: ALU_control = ALU_SLTU;
                3'b100: ALU_control = ALU_XOR;
                3'b110: ALU_control = ALU_OR;
                3'b111: ALU_control = ALU_AND;
                default: ALU_control_exception = 1;
            endcase
        end
    end
end
endmodule