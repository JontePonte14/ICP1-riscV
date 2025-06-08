`timescale 1ns / 1ps
import common::*;

module fetch_stage #(
    GHR_SIZE = 5
) (
    input clk,
    input reset_n,
    input [31:0] target_address,
    input [31:0] mem_pc,
    input logic [GHR_SIZE-1:0] restore_ghr,
    input logic [GHR_SIZE-1:0] update_shared_index,
    input PCWrite_n,
    input BEU_output_type BEU_signals,
    input new_instruction_write_enable, // För att hålla addressen till noll med nya instruktioner
    input [31:0] instruction,
    input is_compressed_instruction,
    output logic [31:0] address,
    output logic branch_prediction_MSB,
    output logic [GHR_SIZE-1:0] ghr,
    output logic [GHR_SIZE-1:0] shared_index,
    output logic fetch_is_compressed_instruction
);
  localparam BHT_SIZE = 32;  // 32 = 2^5 
  localparam BTB_SIZE = 32;

  logic branch_prediction_MSB_cur, branch_prediction_MSB_nxt;

  logic [31:0] pc_next, pc_reg;

  // 2-bit branch history table (bht) is 64 entries, indexed with pc_reg[5:1], initialised 00 means strongly not taken
  logic [1:0] branch_history_table_cur[BHT_SIZE-1:0];
  logic [1:0] branch_history_table_nxt[BHT_SIZE-1:0];

  // branch target buffer (btb) is 32 entries, indexed with pc_reg[5:1]
  logic [31:0] branch_target_buffer_cur[BTB_SIZE-1:0];
  logic [31:0] branch_target_buffer_nxt[BTB_SIZE-1:0];

  // the valid bit of the BTB, initialized to 0 (not valid)
  logic branch_target_valid_cur[BTB_SIZE];
  logic branch_target_valid_nxt[BTB_SIZE];

  // the branch history register, contains the history of the N latest (conditiona) branches
  logic [GHR_SIZE-1:0] global_history_register_cur;
  logic [GHR_SIZE-1:0] global_history_register_nxt;

  assign fetch_is_compressed_instruction = is_compressed_instruction;

  always_ff @(posedge clk) begin
    if (!reset_n) begin
      pc_reg <= 0;
      branch_prediction_MSB_cur = 0;

      for (int i = 0; i < BHT_SIZE; i++) begin
        branch_history_table_cur[i] = 2'b11;
      end

      for (int i = 0; i < BTB_SIZE; i++) begin
        branch_target_buffer_cur[i] = 32'd0;
        branch_target_valid_cur[i]  = 1'b0;
      end

      for (int i = 0; i < GHR_SIZE; i++) begin
        global_history_register_cur[i] = 1'b0;
      end

    end else begin
      pc_reg <= pc_next;
      branch_history_table_cur <= branch_history_table_nxt;
      branch_target_buffer_cur <= branch_target_buffer_nxt;
      branch_target_valid_cur <= branch_target_valid_nxt;
      branch_prediction_MSB_cur = branch_prediction_MSB_nxt;
      global_history_register_cur <= global_history_register_nxt;
    end
  end

  always_comb begin : update_GHR
    global_history_register_nxt = global_history_register_cur;

/////////////////////////////EVAL/////////////////////////////////
    if (!PCWrite_n) begin  // if not stalling:
      if (BEU_signals.PCSrc)  // predicted not taken, but was taken, or predicted wrong taken address
        // restore ghr and shift in the actual outcome of the branch, if conditional jump. otherwise just restore
        if (!BEU_signals.is_unconditional_jump)
          // shift in 1
          global_history_register_nxt = {
            restore_ghr[GHR_SIZE-2:0], 1'b1
          };
        else global_history_register_nxt = restore_ghr;
      else  if (BEU_signals.control_pc_plus == MEM_PC_PLUS2 || BEU_signals.control_pc_plus == MEM_PC_PLUS4)  // predict taken, was not taken
          // shift in 0 since branch was not taken (this case only happens for conditional jumps)
          global_history_register_nxt = {
            restore_ghr[GHR_SIZE-2:0], 1'b0
          };  
/////////////////////////////END OF EVAL/////////////////////////////////
      else if (!is_compressed_instruction && instruction[6:0] == 7'b1100011 
      || is_compressed_instruction && instruction[1:0] == 2'b01 && (instruction[15:13] == 3'b110 || instruction[15:13] == 3'b111)) begin
        if (branch_history_table_cur[pc_reg[5:1] ^ global_history_register_cur] && branch_target_buffer_cur[pc_reg[5:1]]) // predict taken and valid btb
          // shift in 1
          global_history_register_nxt = {
            global_history_register_cur[GHR_SIZE-2:0], 1'b1
          };
        else
          // shift in 0
          global_history_register_nxt = {
            global_history_register_cur[GHR_SIZE-2:0], 1'b0
          };
      end
    end
  end


  always_comb begin : evaluate_pc
    //Note that if is_control_hazards = 1 (PCSrc || mem_pc_plus4), PCWrite_n = 0. check hazard_detection_unit for details
    if (new_instruction_write_enable) begin
      pc_next = 0;
    end else begin
      if (!PCWrite_n) begin
        if (BEU_signals.PCSrc) pc_next = target_address;
        else begin
          // If gör Ture
          //if (BEU_signals.mem_pc_plus4) pc_next = mem_pc + 4;
          if (BEU_signals.control_pc_plus == MEM_PC_PLUS4) pc_next = mem_pc + 4;

          else if (BEU_signals.control_pc_plus == MEM_PC_PLUS2) pc_next = mem_pc + 2;

          else if (((!is_compressed_instruction && (instruction[6:0] == 7'b1100111 || instruction[6:0] == 7'b1101111) // uncompressed unconditional branch
          || is_compressed_instruction && (instruction[1:0] == 2'b01 && (instruction[15:13] == 3'b001 ||instruction[15:13] == 3'b101)||instruction[1:0] == 2'b10 && instruction[15:13] == 3'b100)) // compressed unconditional branch
          || branch_history_table_cur[pc_reg[5:1]^global_history_register_cur][1]) // conditional branch predict true
          && branch_target_valid_cur[pc_reg[5:1]]) // and valid btb
            // else if (branch_history_table_cur[pc_reg[5:1]][1] && branch_target_valid_cur[pc_reg[5:1]])
            // index with shared index (GHR xor pc_reg)
            pc_next = branch_target_buffer_cur[pc_reg[5:1]];
          // Else case gör Jonte
          else begin
            if (is_compressed_instruction) begin
              pc_next = pc_reg + 2;
            end 
            else begin
              pc_next = pc_reg + 4;
            end
          end
        end
      end else begin
        pc_next = pc_reg;
      end
    end
  end

  always_comb begin : update_bht
    branch_history_table_nxt = branch_history_table_cur;
    if (BEU_signals.is_taken_branch) begin
      // increment unless in state strongly taken 
      if (branch_history_table_cur[update_shared_index] < 3)
        branch_history_table_nxt[update_shared_index] = branch_history_table_cur[update_shared_index] + 1;
    end else begin
      // decrement unless in state strongly not taken
      if (branch_history_table_cur[update_shared_index] > 0)
        branch_history_table_nxt[update_shared_index] = branch_history_table_cur[update_shared_index] - 1;
    end
  end

  always_comb begin : update_btb
    branch_target_valid_nxt  = branch_target_valid_cur;
    branch_target_buffer_nxt = branch_target_buffer_cur;

    if (BEU_signals.is_taken_branch && BEU_signals.PCSrc) begin
      branch_target_valid_nxt[mem_pc[5:1]]  = 1'b1;  // set valid bit to 1
      branch_target_buffer_nxt[mem_pc[5:1]] = target_address;
    end
  end

  assign address = pc_reg;
  assign ghr = global_history_register_cur;
  assign shared_index = pc_reg[5:1] ^ global_history_register_cur;
  assign branch_prediction_MSB_nxt = branch_history_table_cur[pc_reg[5:1] ^ global_history_register_cur][1];
  assign branch_prediction_MSB = branch_prediction_MSB_cur;

  /*
   ila_fetch_signals ints_ila_fetch_signals (
   .clk(clk),
   .probe0(pc_reg),
   .probe1(new_instruction_write_enable)
   );
*/
  /*
   ila_bht ila_history_table (
    .clk(clk),
    .probe0(branch_history_table_cur[0]),
    .probe1(branch_history_table_cur[1]),
    .probe2(branch_history_table_cur[2]),
    .probe3(branch_history_table_cur[3]),
    .probe4(branch_history_table_cur[4]),
    .probe5(branch_history_table_cur[5]),
    .probe6(branch_history_table_cur[6]),
    .probe7(branch_history_table_cur[7]),
    .probe8(branch_history_table_cur[8]),
    .probe9(branch_history_table_cur[9]),
    .probe10(branch_history_table_cur[10]),
    .probe11(branch_history_table_cur[11]),
    .probe12(branch_history_table_cur[12]),
    .probe13(branch_history_table_cur[13]),
    .probe14(branch_history_table_cur[14]),
    .probe15(branch_history_table_cur[15]),
    .probe16(branch_history_table_cur[16]),
    .probe17(branch_history_table_cur[17]),
    .probe18(branch_history_table_cur[18]),
    .probe19(branch_history_table_cur[19]),
    .probe20(branch_history_table_cur[20]),
    .probe21(branch_history_table_cur[21]),
    .probe22(branch_history_table_cur[22]),
    .probe23(branch_history_table_cur[23]),
    .probe24(branch_history_table_cur[24]),
    .probe25(branch_history_table_cur[25]),
    .probe26(branch_history_table_cur[26]),
    .probe27(branch_history_table_cur[27]),
    .probe28(branch_history_table_cur[28]),
    .probe29(branch_history_table_cur[29]),
    .probe30(branch_history_table_cur[30]),
    .probe31(branch_history_table_cur[31]),
    .probe32(branch_history_table_cur[32]),
    .probe33(branch_history_table_cur[33]),
    .probe34(branch_history_table_cur[34]),
    .probe35(branch_history_table_cur[35]),
    .probe36(branch_history_table_cur[36]),
    .probe37(branch_history_table_cur[37]),
    .probe38(branch_history_table_cur[38]),
    .probe39(branch_history_table_cur[39]),
    .probe40(branch_history_table_cur[40]),
    .probe41(branch_history_table_cur[41]),
    .probe42(branch_history_table_cur[42]),
    .probe43(branch_history_table_cur[43]),
    .probe44(branch_history_table_cur[44]),
    .probe45(branch_history_table_cur[45]),
    .probe46(branch_history_table_cur[46]),
    .probe47(branch_history_table_cur[47]),
    .probe48(branch_history_table_cur[48]),
    .probe49(branch_history_table_cur[49]),
    .probe50(branch_history_table_cur[50]),
    .probe51(branch_history_table_cur[51]),
    .probe52(branch_history_table_cur[52]),
    .probe53(branch_history_table_cur[53]),
    .probe54(branch_history_table_cur[54]),
    .probe55(branch_history_table_cur[55]),
    .probe56(branch_history_table_cur[56]),
    .probe57(branch_history_table_cur[57]),
    .probe58(branch_history_table_cur[58]),
    .probe59(branch_history_table_cur[59]),
    .probe60(branch_history_table_cur[60]),
    .probe61(branch_history_table_cur[61]),
    .probe62(branch_history_table_cur[62]),
    .probe63(branch_history_table_cur[63])
);


ila_btb ila_target_buffer (
    .clk(clk),
    .probe0(branch_target_buffer_cur[0]),
    .probe1(branch_target_buffer_cur[1]),
    .probe2(branch_target_buffer_cur[2]),
    .probe3(branch_target_buffer_cur[3]),
    .probe4(branch_target_buffer_cur[4]),
    .probe5(branch_target_buffer_cur[5]),
    .probe6(branch_target_buffer_cur[6]),
    .probe7(branch_target_buffer_cur[7]),
    .probe8(branch_target_buffer_cur[8]),
    .probe9(branch_target_buffer_cur[9]),
    .probe10(branch_target_buffer_cur[10]),
    .probe11(branch_target_buffer_cur[11]),
    .probe12(branch_target_buffer_cur[12]),
    .probe13(branch_target_buffer_cur[13]),
    .probe14(branch_target_buffer_cur[14]),
    .probe15(branch_target_buffer_cur[15]),
    .probe16(branch_target_buffer_cur[16]),
    .probe17(branch_target_buffer_cur[17]),
    .probe18(branch_target_buffer_cur[18]),
    .probe19(branch_target_buffer_cur[19]),
    .probe20(branch_target_buffer_cur[20]),
    .probe21(branch_target_buffer_cur[21]),
    .probe22(branch_target_buffer_cur[22]),
    .probe23(branch_target_buffer_cur[23]),
    .probe24(branch_target_buffer_cur[24]),
    .probe25(branch_target_buffer_cur[25]),
    .probe26(branch_target_buffer_cur[26]),
    .probe27(branch_target_buffer_cur[27]),
    .probe28(branch_target_buffer_cur[28]),
    .probe29(branch_target_buffer_cur[29]),
    .probe30(branch_target_buffer_cur[30]),
    .probe31(branch_target_buffer_cur[31]),
    .probe32(branch_target_buffer_cur[32]),
    .probe33(branch_target_buffer_cur[33]),
    .probe34(branch_target_buffer_cur[34]),
    .probe35(branch_target_buffer_cur[35]),
    .probe36(branch_target_buffer_cur[36]),
    .probe37(branch_target_buffer_cur[37]),
    .probe38(branch_target_buffer_cur[38]),
    .probe39(branch_target_buffer_cur[39]),
    .probe40(branch_target_buffer_cur[40]),
    .probe41(branch_target_buffer_cur[41]),
    .probe42(branch_target_buffer_cur[42]),
    .probe43(branch_target_buffer_cur[43]),
    .probe44(branch_target_buffer_cur[44]),
    .probe45(branch_target_buffer_cur[45]),
    .probe46(branch_target_buffer_cur[46]),
    .probe47(branch_target_buffer_cur[47]),
    .probe48(branch_target_buffer_cur[48]),
    .probe49(branch_target_buffer_cur[49]),
    .probe50(branch_target_buffer_cur[50]),
    .probe51(branch_target_buffer_cur[51]),
    .probe52(branch_target_buffer_cur[52]),
    .probe53(branch_target_buffer_cur[53]),
    .probe54(branch_target_buffer_cur[54]),
    .probe55(branch_target_buffer_cur[55]),
    .probe56(branch_target_buffer_cur[56]),
    .probe57(branch_target_buffer_cur[57]),
    .probe58(branch_target_buffer_cur[58]),
    .probe59(branch_target_buffer_cur[59]),
    .probe60(branch_target_buffer_cur[60]),
    .probe61(branch_target_buffer_cur[61]),
    .probe62(branch_target_buffer_cur[62]),
    .probe63(branch_target_buffer_cur[63])
);
*/

endmodule
