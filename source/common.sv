package common;
  localparam logic [31:0] NOP = 32'h00000013;
  localparam GHR_SIZE = 5;
  
  typedef enum logic [3:0] {
    ALU_AND  = 4'b0000,
    ALU_OR   = 4'b0001,
    ALU_ADD  = 4'b0010,
    ALU_SUB  = 4'b0110,
    ALU_SLL  = 4'b0011,
    ALU_SLT  = 4'b0100,
    ALU_SLTU = 4'b0101,
    ALU_XOR  = 4'b0111,
    ALU_SRL  = 4'b1000,
    ALU_SRA  = 4'b1010
  } alu_control_type;


  typedef enum logic [2:0] {
    R_TYPE,
    I_TYPE,
    S_TYPE,
    B_TYPE,
    U_TYPE,
    J_TYPE
  } encoding_type;

  typedef enum logic [5:0] {
    noinst,
    add,
    sw,
    lw,
    sub,
    beq,
    bne,
    blt,
    bge,
    bltu,
    bgeu,
    nop,
    addi,
    slli,
    slti,
    sltiu,
    xori,
    srli,
    srai,
    ori,
    andi,
    jalr,
    auipc,
    lui,
    jal,
    sb,
    sh,
    lbu,
    lhu,
    sll,
    slt,
    sltu,
    xor_inst,
    srl,
    sra,
    or_inst,
    and_inst
  } instruction_name;


  typedef struct packed {
    encoding_type encoding;
    logic [1:0] alu_op;
    logic alu_src;
    logic mem_read;
    logic mem_write;
    logic reg_write;
    logic mem_to_reg;
    logic is_branch;
    logic is_lui;
    logic is_auipc;
    logic is_unconditional_jump;
    logic is_jalr;
  } control_type;

  typedef struct packed {
    logic [6:0] funct7;
    logic [2:0] funct3;
  } decoding_fields_type;

  typedef struct packed {
    logic zero_flag;
    logic branch_condition;
  } branch_decision_signals_type;

  typedef enum logic [1:0] {
    FETCH_PC_PLUS4 = 2'b00,
    MEM_PC_PLUS2 = 2'b01,
    MEM_PC_PLUS4 = 2'b10
  } control_pc_plus_type;

  typedef struct packed {
    logic is_taken_branch;
    logic is_correct_address;
    logic is_branch;
    logic PCSrc;
    logic mem_pc_plus4;
    control_pc_plus_type control_pc_plus;
    logic is_unconditional_jump;
  } BEU_output_type; //branch_evaluation_unit output


  typedef struct packed {
    logic [6:0] funct7;
    logic [4:0] rs2;
    logic [4:0] rs1;
    logic [2:0] funct3;
    logic [4:0] rd;
    logic [6:0] opcode;
  } instruction_type;


  typedef struct packed {
    logic [31:0] pc;
    logic branch_prediction;
    logic is_compressed_instruction;
    instruction_type instruction;
    logic [GHR_SIZE-1:0] ghr;
    logic [GHR_SIZE-1:0] shared_index;
  } if_id_type;


  typedef struct packed {
    logic [31:0] pc;
    logic branch_prediction;
    logic is_compressed_instruction;
    logic [4:0] reg_rd_id;
    logic [4:0] reg_rs1_id;
    logic [4:0] reg_rs2_id;
    logic [31:0] data1;
    logic [31:0] data2;
    logic [31:0] immediate_data;
    control_type control;
    decoding_fields_type decoding_fields;
    logic [GHR_SIZE-1:0] ghr;
    logic [GHR_SIZE-1:0] shared_index;
  } id_ex_type;


  typedef struct packed {
    logic [31:0] pc;
    logic [4:0] reg_rd_id;
    logic branch_prediction;
    logic is_compressed_instruction;
    control_type control;
    logic [31:0] alu_data;
    logic [31:0] memory_data;
    branch_decision_signals_type branch_decision_signals;
    logic [31:0] target_address;
    decoding_fields_type decoding_fields;
    logic [GHR_SIZE-1:0] ghr;
    logic [GHR_SIZE-1:0] shared_index;
  } ex_mem_type;


  typedef struct packed {
    logic [4:0]  reg_rd_id;
    logic [31:0] memory_data;
    logic [31:0] alu_data;
    control_type control;
  } mem_wb_type;


  function [31:0] immediate_extension(instruction_type instruction, encoding_type inst_encoding);
    case (inst_encoding)
      I_TYPE:
      immediate_extension = {{20{instruction.funct7[6]}}, {instruction.funct7, instruction.rs2}};
      S_TYPE:
      immediate_extension = {{20{instruction.funct7[6]}}, {instruction.funct7, instruction.rd}};
      B_TYPE:
      immediate_extension = {
        {19{instruction.funct7[6]}},
        {instruction.funct7[6], instruction.rd[0], instruction.funct7[5:0], instruction.rd[4:1]},
        {1'b0}
      };
      U_TYPE:
      immediate_extension = {
        {instruction.funct7, instruction.rs2, instruction.rs1, instruction.funct3}, {12'b0}
      };
      J_TYPE:
      immediate_extension = {
        {12{instruction.funct7[6]}},
        {
          instruction.rs1,
          instruction.funct3,
          instruction.rs2[0],
          instruction.funct7[5:0],
          instruction.rs2[4:1]
        },
        {1'b0}
      };

      default:
      immediate_extension = {{20{instruction.funct7[6]}}, {instruction.funct7, instruction.rs2}};
    endcase
  endfunction



endpackage
