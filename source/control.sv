`timescale 1ns / 1ps

import common::*;
import instruction_pkg::*;

module control (
    input clk,
    input reset_n,
    input instruction_type instruction,
    output control_type control,
    output logic control_exception,
    //temp
    output instruction_name instruction_n
);



  always_comb begin
    control = '0;
    control_exception = '0;
    case (instruction.opcode)
      7'b0110011: begin
        control.encoding  = R_TYPE;
        control.reg_write = 1'b1;
        control.alu_op = 2'b10;
      end

      7'b0000011: begin
        control.encoding = I_TYPE;
        control.reg_write = 1'b1;
        control.alu_src = 1'b1;
        control.mem_read = 1'b1;
        control.mem_to_reg = 1'b1;
      end

      7'b0010011: begin
        control.encoding  = I_TYPE;
        control.reg_write = 1'b1;
        control.alu_src   = 1'b1;
        control.alu_op = 2'b11;
      end

      7'b0100011: begin
        control.encoding  = S_TYPE;
        control.alu_src   = 1'b1;
        control.mem_write = 1'b1;
      end

      7'b1100011: begin
        control.encoding  = B_TYPE;
        control.is_branch = 1'b1;
        control.alu_op = 2'b01;
      end

      7'b0010111: begin  //auipc
        control.encoding  = U_TYPE;
        control.alu_src   = 1'b1;
        control.reg_write = 1'b1;
        control.is_auipc  = 1'b1;
      end

      7'b0110111: begin  //lui
        control.encoding = U_TYPE;
        control.alu_src = 1'b1;
        control.reg_write = 1'b1;
        control.is_lui = 1'b1;
      end
      7'b1101111: begin  //jal
        control.encoding = J_TYPE;
        control.reg_write = 1'b1;
        control.is_unconditional_jump = 1;
        control.is_branch = 1;
           // For clarity
        control.is_jalr =  0;

      end
      7'b1100111: begin  //jalr
        control.encoding = I_TYPE;
        control.reg_write = 1'b1;
        control.is_unconditional_jump = 1;
        control.is_branch = 1;
        control.is_jalr =  1;

      end

      default: begin
        control_exception = 1'b1;
      end

    endcase
    if (instruction.rd == 0) begin
      control.reg_write = 0;
    end
    //default cases
    //temp
    instruction_n = noinst;
    

    if ({instruction.funct7, instruction.funct3, instruction.opcode} == ADD_INSTRUCTION) begin
      instruction_n  = add;
    end 
    else if ({instruction.funct7, instruction.funct3, instruction.opcode} == SUB_INSTRUCTION) begin
      instruction_n  = sub;
      // B-type instructions
    end else if ({instruction.funct3, instruction.opcode} == BEQ_INSTRUCTION) begin
      instruction_n = beq;
    end else if ({instruction.funct3, instruction.opcode} == BNE_INSTRUCTION ) begin
      instruction_n = bne;

    end else if ({instruction.funct3, instruction.opcode} == BLT_INSTRUCTION) begin
      instruction_n = blt;

    end else if ({instruction.funct3, instruction.opcode} == BGE_INSTRUCTION) begin
      instruction_n = bge;

    end else if ({instruction.funct3, instruction.opcode} == BLTU_INSTRUCTION) begin
      instruction_n = bltu;

    end else if ({instruction.funct3, instruction.opcode} == BGEU_INSTRUCTION) begin
      instruction_n = bgeu;

    end
    else if ({instruction.funct7, instruction.funct3, instruction.opcode} == SLL_INSTRUCTION) begin
      instruction_n  = sll;
    end
else if ({instruction.funct7, instruction.funct3, instruction.opcode} == SLT_INSTRUCTION) begin
      instruction_n  = slt;
    end
else if ({instruction.funct7, instruction.funct3, instruction.opcode} == SLTU_INSTRUCTION) begin
      instruction_n  = sltu;
    end
else if ({instruction.funct7, instruction.funct3, instruction.opcode} == XOR_INSTRUCTION) begin
      instruction_n  = xor_inst;
    end
else if ({instruction.funct7, instruction.funct3, instruction.opcode} == SRL_INSTRUCTION) begin
      instruction_n  = srl;
    end
else if ({instruction.funct7, instruction.funct3, instruction.opcode} == SRA_INSTRUCTION) begin
      instruction_n  = sra;
    end
else if ({instruction.funct7, instruction.funct3, instruction.opcode} == OR_INSTRUCTION) begin
      instruction_n  = or_inst;
    end
else if ({instruction.funct7, instruction.funct3, instruction.opcode} == AND_INSTRUCTION) begin
      instruction_n  = and_inst;
    end else if ({instruction.funct3, instruction.opcode} == LW_INSTRUCTION) begin
      instruction_n = lw;
    end else if ({instruction.funct3, instruction.opcode} == SW_INSTRUCTION) begin
      instruction_n = sw;
    end else if ({instruction.funct3, instruction.opcode} == ADDI_INSTRUCTION) begin
      instruction_n  = addi;
    end
else if ({instruction.funct7, instruction.funct3, instruction.opcode} == SLLI_INSTRUCTION) begin
      instruction_n  = slli;
    end else if ({instruction.funct3, instruction.opcode} == SLTI_INSTRUCTION) begin
      instruction_n  = slti;
    end else if ({instruction.funct3, instruction.opcode} == SLTIU_INSTRUCTION) begin
      instruction_n  = sltiu;
    end else if ({instruction.funct3, instruction.opcode} == XORI_INSTRUCTION) begin
      instruction_n  = xori;
    end
else if ({instruction.funct7, instruction.funct3, instruction.opcode} == SRLI_INSTRUCTION) begin
      instruction_n  = srli;
    end
else if ({instruction.funct7, instruction.funct3, instruction.opcode} == SRAI_INSTRUCTION) begin
      instruction_n  = srai;
    end else if ({instruction.funct3, instruction.opcode} == ORI_INSTRUCTION) begin
      instruction_n  = ori;
    end else if ({instruction.funct3, instruction.opcode} == ANDI_INSTRUCTION) begin
      instruction_n  = andi;
    end else if ({instruction.funct3, instruction.opcode} == JALR_INSTRUCTION) begin
      instruction_n = jalr;
    end else if ({instruction.opcode} == AUIPC_INSTRUCTION) begin
      instruction_n  = auipc;
    end else if ({instruction.opcode} == LUI_INSTRUCTION) begin
      instruction_n  = lui;
    end else if ({instruction.opcode} == JAL_INSTRUCTION) begin
      instruction_n = jal;
    end else if ({instruction.funct3, instruction.opcode} == SB_INSTRUCTION) begin
      instruction_n = sb;
    end else if ({instruction.funct3, instruction.opcode} == SH_INSTRUCTION) begin
      instruction_n = sh;
    end else if ({instruction.funct3, instruction.opcode} == LBU_INSTRUCTION) begin
      instruction_n = lbu;
    end else if ({instruction.funct3, instruction.opcode} == LHU_INSTRUCTION) begin
      instruction_n = lhu;
    end

    if (instruction == NOP_INSTRUCTION) begin
      instruction_n  = nop;
    end

  end

endmodule
