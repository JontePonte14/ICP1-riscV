`timescale 1ns / 1ps

typedef struct packed {
        logic [11:7] lower;
        logic [31:25] higher;
    } b_immediate_type;

module Decompression(
    input logic [15:0] c_inst,
    input logic activate,
    output logic [31:0] dec_inst,
    output logic c_decoding_exception
    );
    

    logic [1:0] opcode2_16;
    logic [31:12] j_immediate;
    b_immediate_type b_immediate;

    assign opcode2_16 = c_inst[1:0];


    always_comb begin

    dec_inst = '0;
    c_decoding_exception = 0;
    if (activate) begin
        case (opcode2_16)
            
            2'b00: begin
            dec_inst[14:12] = 3'b010;  //funct3     NEEDS TO BE RECONSIDERED WHEN ADDING MORE, not relevant for us tho
            dec_inst[19:15] = {{2'b01},{c_inst[9:7]}}; //rs1
            case (c_inst[15:13])
                    3'b010: begin //c.lw
                        dec_inst[6:0] = 7'b0000011; //opcode - lw
                        dec_inst[11:7] = {{2'b01},{c_inst[4:2]}};
                        dec_inst[22] = c_inst[6];
                        dec_inst[25:23] = c_inst[12:10];
                        dec_inst[26] = c_inst[5];
                        dec_inst[31:27] = '0;
                        dec_inst[21:20] = '0;
                    end

                    3'b110: begin //c.sw
                        dec_inst[6:0] = 7'b0100011; //opcode - sw
                        dec_inst[24:20] = {{2'b01},{c_inst[4:2]}};     //rs2
                        dec_inst[9] = c_inst[6];
                        dec_inst[11:10] = c_inst[11:10];
                        dec_inst[25] = c_inst[12];
                        dec_inst[26] = c_inst[5];
                        dec_inst[31:27] = '0;
                        dec_inst[8:7] = '0;
                    end

                    default:c_decoding_exception = 1;
            endcase
            end

            2'b01: begin
                case (c_inst[15:13])
                    3'b000: begin //c.addi
                        if (c_inst[12:2] == '0) begin //nop
                            dec_inst = {{25{1'b0}},{7'b0010011}};
                        end
                        else begin
                            if (c_inst[11:7] == '0 || {{c_inst[12]},{c_inst[6:2]}} == '0) begin //rd == 0 || imm == 0
                                c_decoding_exception = 1;
                            end
                            dec_inst[6:0] = 7'b0010011; //opcode - addi
                            dec_inst[11:7] =  c_inst[11:7]; //rd
                            dec_inst[14:12] = 3'b000; //fucnt3
                            dec_inst[19:15] =  c_inst[11:7]; //rs1
                            dec_inst[31:20] = {{7{c_inst[12]}},{c_inst[12]}, {c_inst[6:2]}}; //imm
                        end
                        
                    end
                    3'b001: begin //c.jal
                        dec_inst[6:0] = 7'b1101111; //opcode - jal
                        dec_inst[11:7] =  5'b00001; //rd
                        j_immediate = j_cImmediate_to_RV32I(c_inst[12:2]);
                        dec_inst[31:12] = j_immediate;
                    end

                    3'b010: begin //c.li
                        if (c_inst[11:7] == 0) begin //rd == 0
                            c_decoding_exception = 1;
                        end
                        dec_inst[6:0] = 7'b0010011;
                        dec_inst[11:7] =  c_inst[11:7]; //rd
                        dec_inst[14:12] = 3'b000; //fucnt3
                        dec_inst[19:15] = 5'b00000; //rs1
                        dec_inst[31:20] = {{7{c_inst[12]}},{c_inst[12]}, {c_inst[6:2]}}; //imm

                    end

                    3'b011: begin //c.lui
                        if (c_inst[11:7] == 0 || c_inst[11:7] == 2 || {{c_inst[12]},{c_inst[6:2]}} == '0) begin //rd == 0 || rd == 2 || imm == 0
                            c_decoding_exception = 1;
                        end
                        dec_inst[6:0] = 7'b0110111;
                        dec_inst[11:7] =  c_inst[11:7]; //rd
                        dec_inst[31:12] = {{14{c_inst[12]}},{c_inst[12]}, {c_inst[6:2]}}; //imm
                    end

                    3'b100: begin
                        dec_inst[11:7] =  {{2'b01},{c_inst[9:7]}}; //rd
                        dec_inst[19:15] =  {{2'b01},{c_inst[9:7]}}; //rs1
                        case (c_inst[11:10])
                            2'b00: begin //c.srli
                                dec_inst[6:0] = 7'b0010011;
                                dec_inst[14:12] = 3'b101; //fucnt3
                                dec_inst[31:25] = 7'b0000000; //funct7
                                dec_inst[24:20] = {{c_inst[12]},{c_inst[6:2]}}; //imm
                            end
                            2'b01: begin //c.srai
                                dec_inst[6:0] = 7'b0010011;
                                dec_inst[14:12] = 3'b101; //fucnt3
                                dec_inst[31:25] = 7'b0100000; //funct7
                                dec_inst[24:20] = {{c_inst[12]},{c_inst[6:2]}}; //imm
                            end
                            2'b10: begin //c.andi
                                dec_inst[6:0] = 7'b0010011;
                                dec_inst[14:12] = 3'b111; //fucnt3
                                dec_inst[31:20] = {{7{c_inst[12]}},{c_inst[12]}, {c_inst[6:2]}}; //imm
                            end
                            2'b11: begin 
                                dec_inst[6:0] = 7'b0110011;
                                dec_inst[24:20] =  {{2'b01},{c_inst[4:2]}}; //rs2
                                case (c_inst[12])
                                    0: begin
                                        case (c_inst[6:5])
                                            2'b00: begin //c.sub
                                                dec_inst[14:12] = 3'b000; //fucnt3
                                                dec_inst[31:25] = 7'b0100000; //funct7
                                            end
                                            2'b01: begin //c.xor
                                                dec_inst[14:12] = 3'b100; //fucnt3
                                                dec_inst[31:25] = 7'b0000000; //funct7
                                            end
                                            2'b10: begin //c.or
                                                dec_inst[14:12] = 3'b110; //fucnt3
                                                dec_inst[31:25] = 7'b0000000; //funct7
                                            end
                                            2'b11: begin //c.and
                                                dec_inst[14:12] = 3'b111; //fucnt3
                                                dec_inst[31:25] = 7'b0000000; //funct7
                                            end
                                        endcase
                                    end
                                    default: c_decoding_exception = 1;
                                endcase
                            end
                        endcase
                    end

                    3'b101: begin //c.j
                        dec_inst[6:0] = 7'b1101111; //opcode - jal
                        dec_inst[11:7] = 5'b00000;
                        j_immediate = j_cImmediate_to_RV32I(c_inst[12:2]);
                        dec_inst[31:12] = j_immediate;
                    end

                    3'b110: begin //c.beqz
                        dec_inst[6:0] = 7'b1100011; //b
                        dec_inst[14:12] = 3'b000;
                        b_immediate = b_cImmediate_to_RV32I(c_inst[12:10], c_inst[6:2]);
                        dec_inst[19:15] = {{2'b01},{c_inst[9:7]}};
                        dec_inst[24:20] = '0;
                        dec_inst[31:25] = b_immediate.higher;
                        dec_inst[11:7] = b_immediate.lower;
                    end
                    3'b111: begin //c.bnez
                        dec_inst[6:0] = 7'b1100011; //b
                        dec_inst[14:12] = 3'b001;
                        b_immediate = b_cImmediate_to_RV32I(c_inst[12:10], c_inst[6:2]);
                        dec_inst[19:15] = {{2'b01},{c_inst[9:7]}};
                        dec_inst[24:20] = '0;
                        dec_inst[31:25] = b_immediate.higher;
                        dec_inst[11:7] = b_immediate.lower;
                    end
                endcase
            end

            2'b10: begin
                case (c_inst[15:13])
                    3'b000: begin //c.slli
                        if (c_inst[12] == 0 || c_inst[11:7] == 0 || c_inst[6:2] == 0) begin //uimm[5] = 0 ||rs1/rd=0 ||shamt = 0
                            c_decoding_exception = 1;
                        end
                        dec_inst[6:0] = 7'b0010011;
                        dec_inst[11:7] =  c_inst[11:7]; //rd
                        dec_inst[14:12] = 3'b001; //fucnt3
                        dec_inst[19:15] =  c_inst[11:7]; //rs1
                        dec_inst[24:20] = {{c_inst[12]},{c_inst[6:2]}}; //imm
                        dec_inst[31:25] = 7'b0000000; //imm
                    end

                    3'b100: begin
                        if (c_inst[6:2] == 0) begin //rs2 = 0
                            if (c_inst[11:7] == 0) begin //rs1 = 0
                                c_decoding_exception = 1;
                            end
                            dec_inst[6:0] = 7'b1100111;
                            dec_inst[14:12] = 3'b000; //fucnt3
                            case (c_inst[12])
                                0: begin //c.jr
                                    dec_inst[11:7] = 5'b00000; //rd
                                end

                                1: begin //c.jalr
                                    dec_inst[11:7] = 5'b00001; //rd
                                end
                            endcase
                        end
                        else begin
                            if (c_inst[11:7] == 0 ||c_inst[6:2] == 0) begin //rs1 = 0
                                c_decoding_exception = 1;
                            end
                            dec_inst[6:0] = 7'b0110011;
                            dec_inst[14:12] = 3'b000; //funct3
                            dec_inst[11:7] = c_inst[11:7]; //rd
                            dec_inst[24:20] = c_inst[6:2];
                            dec_inst[31:25] = 7'b0000000;
                            case (c_inst[12])
                                0: begin //c.mv
                                    dec_inst[19:15] = 5'b00000; //rs1
                                end

                                1: begin //c.add
                                    dec_inst[19:15] = c_inst[11:7]; //rs1
                                end
                            endcase
                        end
                    end
                    default: c_decoding_exception = 1;
                endcase
            end
            default: dec_inst = '0;
        endcase
        end
    end
    endmodule

    function [31:12] j_cImmediate_to_RV32I(logic[12:2] c_immidiate);
        j_cImmediate_to_RV32I[23:21] = c_immidiate[5:3];
        j_cImmediate_to_RV32I[24] = c_immidiate[11];
        j_cImmediate_to_RV32I[25] = c_immidiate[2];
        j_cImmediate_to_RV32I[26] = c_immidiate[7];
        j_cImmediate_to_RV32I[27] = c_immidiate[6];
        j_cImmediate_to_RV32I[29:28] = c_immidiate[10:9];
        j_cImmediate_to_RV32I[30] = c_immidiate[8];
        j_cImmediate_to_RV32I[20] = c_immidiate[12];

        j_cImmediate_to_RV32I[31] = c_immidiate[12];
        j_cImmediate_to_RV32I[19:12] = {8{c_immidiate[12]}};
    endfunction

    function b_immediate_type b_cImmediate_to_RV32I(logic[12:10] c_immidiate_higher, logic[6:2] c_immidiate_lower);
        b_cImmediate_to_RV32I.lower[9:8] = c_immidiate_lower[4:3];
        b_cImmediate_to_RV32I.lower[11:10] = c_immidiate_higher[11:10];
        b_cImmediate_to_RV32I.higher[25] = c_immidiate_lower[2];
        b_cImmediate_to_RV32I.higher[27:26] = c_immidiate_lower[6:5];
        b_cImmediate_to_RV32I.higher[28] = c_immidiate_higher[12];

        b_cImmediate_to_RV32I.higher[31:29] = {3{c_immidiate_higher[12]}};
        b_cImmediate_to_RV32I.lower[7] = c_immidiate_higher[12];


    endfunction