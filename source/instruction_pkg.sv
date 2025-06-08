package instruction_pkg;

  // Define instruction encodings as constants

  //R-Type instructions
  localparam logic [31:0] NOP_INSTRUCTION = {{25{1'b0}},{7'b0010011}};

  localparam logic [16:0] ADD_INSTRUCTION = {7'b0000000, 3'b000, 7'b0110011};
  localparam logic [16:0] SUB_INSTRUCTION = {7'b0100000, 3'b000, 7'b0110011};
  localparam logic [16:0] SLL_INSTRUCTION = {7'b0000000, 3'b001, 7'b0110011};
  localparam logic [16:0] SLT_INSTRUCTION = {7'b0000000, 3'b010, 7'b0110011};
  localparam logic [16:0] SLTU_INSTRUCTION = {7'b0000000, 3'b011, 7'b0110011};
  localparam logic [16:0] XOR_INSTRUCTION = {7'b0000000, 3'b100, 7'b0110011};
  localparam logic [16:0] SRL_INSTRUCTION = {7'b0000000, 3'b101, 7'b0110011};
  localparam logic [16:0] SRA_INSTRUCTION = {7'b0100000, 3'b101, 7'b0110011};
  localparam logic [16:0] OR_INSTRUCTION = {7'b0000000, 3'b110, 7'b0110011};
  localparam logic [16:0] AND_INSTRUCTION = {7'b0000000, 3'b111, 7'b0110011};

  //I-Type instructions
  localparam logic [9:0] LB_INSTRUCTION = {3'b000, 7'b0000011};  // lb
  localparam logic [9:0] LH_INSTRUCTION = {3'b001, 7'b0000011};  // lh
  localparam logic [9:0] LW_INSTRUCTION = {3'b010, 7'b0000011};  // lw
  localparam logic [9:0] LBU_INSTRUCTION = {3'b100, 7'b0000011};  // lbu
  localparam logic [9:0] LHU_INSTRUCTION = {3'b101, 7'b0000011};  // lhu

  localparam logic [9:0] FENCE_INSTRUCTION = {3'b000, 7'b0001111};  // fence
  localparam logic [9:0] FENCEI_INSTRUCTION = {3'b001, 7'b0001111};  // fence.i

  localparam logic [9:0] ADDI_INSTRUCTION = {3'b000, 7'b0010011};  // addi
  localparam logic [16:0] SLLI_INSTRUCTION = {7'b0000000, 3'b001, 7'b0010011};  // slli
  localparam logic [9:0] SLTI_INSTRUCTION = {3'b010, 7'b0010011};  // slti
  localparam logic [9:0] SLTIU_INSTRUCTION = {3'b011, 7'b0010011};  // sltiu
  localparam logic [9:0] XORI_INSTRUCTION = {3'b100, 7'b0010011};  // xori
  localparam logic [16:0] SRLI_INSTRUCTION = {7'b0000000, 3'b101, 7'b0010011};  // srli
  localparam logic [16:0] SRAI_INSTRUCTION = {7'b0100000, 3'b101, 7'b0010011};  // srai
  localparam logic [9:0] ORI_INSTRUCTION = {3'b110, 7'b0010011};  // ori
  localparam logic [9:0] ANDI_INSTRUCTION = {3'b111, 7'b0010011};  // andi

  //U-Type instructions
  localparam logic [6:0] AUIPC_INSTRUCTION = {7'b0010111};  // auipc
  localparam logic [6:0] LUI_INSTRUCTION = {7'b0110111};  // lui

  //J-Type instructions
  localparam logic [6:0] JAL_INSTRUCTION = {7'b1101111};  //jal
  localparam logic [9:0] JALR_INSTRUCTION = {3'b000, 7'b1100111};  // jalr

  //S-Type instructions
  localparam logic [9:0] SB_INSTRUCTION = {3'b000, 7'b0100011};  // sb
  localparam logic [9:0] SH_INSTRUCTION = {3'b001, 7'b0100011};  // sh
  localparam logic [9:0] SW_INSTRUCTION = {3'b010, 7'b0100011};  // sw

  //B-Type instructions
  localparam logic [9:0] BEQ_INSTRUCTION = {3'b000, 7'b1100011};  // beq
  localparam logic [9:0] BNE_INSTRUCTION = {3'b001, 7'b1100011};  // bne
  localparam logic [9:0] BLT_INSTRUCTION = {3'b100, 7'b1100011};  // blt
  localparam logic [9:0] BGE_INSTRUCTION = {3'b101, 7'b1100011};  // bge
  localparam logic [9:0] BLTU_INSTRUCTION = {3'b110, 7'b1100011};  // bltu
  localparam logic [9:0] BGEU_INSTRUCTION = {3'b111, 7'b1100011};  // bgeu

endpackage
