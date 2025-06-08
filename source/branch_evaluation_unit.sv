`timescale 1ns / 1ps
import common::*;

module branch_evaluation_unit(
    input branch_decision_signals_type branch_decision_signals,
    input control_type mem_control_signals,
    input logic branch_prediction,
    input logic [31:0] ex_address,
    input logic [31:0] target_address,
    input is_compressed_instruction,
    output var BEU_output_type BEU_output
    );
    logic is_taken_branch;
    logic is_correct_address;
    logic [2:0] debug_branch_cases; //temp
    always_comb begin
        

        is_correct_address = 0;
        BEU_output = '0;
        is_taken_branch = ((mem_control_signals.is_branch && (branch_decision_signals.zero_flag == branch_decision_signals.branch_condition))
        || mem_control_signals.is_unconditional_jump);

        if (is_taken_branch && (mem_control_signals.is_branch || mem_control_signals.is_unconditional_jump)) begin //save some power
            if (ex_address == target_address) 
                is_correct_address = 1;
        end

        debug_branch_cases = 3'b000;
        if(mem_control_signals.is_branch) begin
            if(branch_prediction == 0 && is_taken_branch == 1) begin  //google sheets table case 2
                BEU_output.PCSrc = 1;
                debug_branch_cases = 3'b010;
            end
            else if(branch_prediction == 1 && is_taken_branch == 1 && is_correct_address == 0) begin //google sheets table case 5
                BEU_output.PCSrc = 1;
                debug_branch_cases = 3'b101;
            end
            else if(branch_prediction == 1 && is_taken_branch == 0) begin //google sheets table case 6
                BEU_output.mem_pc_plus4 = 1; //remove when switching to control_pc_plus
                if (is_compressed_instruction) begin
                    BEU_output.control_pc_plus = MEM_PC_PLUS2;
                end
                else begin
                    BEU_output.control_pc_plus = MEM_PC_PLUS4;
                end
                debug_branch_cases = 3'b110;
            end
        end

        BEU_output.is_taken_branch = is_taken_branch;
        BEU_output.is_branch = mem_control_signals.is_branch;
        BEU_output.is_correct_address = is_correct_address;
        BEU_output.is_unconditional_jump = mem_control_signals.is_unconditional_jump;

    
    end
    

endmodule
