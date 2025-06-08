`timescale 1ns / 1ps
import common::*;

module data_memory (
    input clk,
    input [9:0] mem_byte_address,
    input mem_write_enable,  
    input mem_read_enable,
    input [3:0] mem_byte_enable,
    input [31:0] mem_write_data, 
    output logic [31:0] mem_read_data
);

    //logic [31:0] ram [256];
    logic [31:0] cur_ram[256], nxt_ram[256];
    logic [7:0] word_address;
    
    
    assign word_address = mem_byte_address[9:2];
    
    
    always @(posedge clk) begin
        cur_ram = nxt_ram;
        // if (mem_write_enable) begin
        //     //The 8 bits of lb and sb are shifted to correct position in mem_stage. same for hw
        //     if (mem_byte_enable[3] == 1) begin
        //         ram[word_address][31:24] <= mem_write_data[31:24];
        //     end
        //     if (mem_byte_enable[2] == 1) begin
        //         ram[word_address][23:16] <= mem_write_data[23:16];
        //     end
        //     if (mem_byte_enable[1] == 1) begin
        //         ram[word_address][15:8] <= mem_write_data[15:8];
        //     end
        //     if (mem_byte_enable[0] == 1) begin
        //         ram[word_address][7:0] <= mem_write_data[7:0];
        //     end
        // end 
    end

    always_comb begin
        mem_read_data = 32'b0;  // default value
        nxt_ram = cur_ram; // default 

            // Sets the output if ram is read
            if (mem_byte_enable[3] == 1) begin
                mem_read_data[31:24] = cur_ram[word_address][31:24];
            end
            if (mem_byte_enable[2] == 1) begin
                mem_read_data[23:16] = cur_ram[word_address][23:16];
            end
            if (mem_byte_enable[1] == 1) begin
                mem_read_data[15:8] = cur_ram[word_address][15:8];
            end
            if (mem_byte_enable[0] == 1) begin
                mem_read_data[7:0] = cur_ram[word_address][7:0];
            end
            
            // Sets the input (write) to ram
            if (mem_write_enable) begin
            //The 8 bits of lb and sb are shifted to correct position in mem_stage. same for hw
            if (mem_byte_enable[3] == 1) begin
                nxt_ram[word_address][31:24] = mem_write_data[31:24];
            end
            if (mem_byte_enable[2] == 1) begin
                nxt_ram[word_address][23:16] = mem_write_data[23:16];
            end
            if (mem_byte_enable[1] == 1) begin
                nxt_ram[word_address][15:8] = mem_write_data[15:8];
            end
            if (mem_byte_enable[0] == 1) begin
                nxt_ram[word_address][7:0] = mem_write_data[7:0];
            end
        end 
    end
    

// ILA MODULE
/*
ila_data_mem inst_ila_data_mem (
  .clk(clk),
  .probe0(cur_ram[0]),
  .probe1(cur_ram[1]),
  .probe2(cur_ram[2]),
  .probe3(cur_ram[3]),
  .probe4(cur_ram[4]),
  .probe5(cur_ram[5]),
  .probe6(cur_ram[6]),
  .probe7(cur_ram[32])
);
*/

endmodule