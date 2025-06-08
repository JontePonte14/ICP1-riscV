`timescale 1ns / 1ps


module testbench();

    logic clock = 0;
    logic reset_n = 0;
    logic io_data_valid = 0;
    logic [7:0] io_data_packet = '0;
    logic new_instruction_write_enable = 0;
    
    
    always begin
        #5 clock = ~clock;
    end


    initial begin
        #35 reset_n = 1;
    end
    
    
    cpu cpu_inst(
        .clk(clock),
        .reset_n(reset_n),
        .io_data_valid(io_data_valid),
        .io_data_packet(io_data_packet),
        .new_instruction_write_enable(new_instruction_write_enable)
    );
    
endmodule
