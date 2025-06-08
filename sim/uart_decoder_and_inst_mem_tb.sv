`timescale 1ns / 1ps

module uart_decoder_and_inst_mem_tb();
    logic clk = 0;
    logic reset_n = 0;
    logic [31:0] byte_address;
    logic write_enable;
    logic [31:0] write_data;
    logic [31:0] read_data;
    logic io_data_valid = 0;
    logic [7:0] io_data_packet = '0;

    //Input data
    logic [7:0] array [0:7] = '{
        8'b00000000, // word 1
        8'b01000000, 
        8'b00000000, 
        8'b10010011,
        8'b00000000, // word 2
        8'b10000000,
        8'b00000001,
        8'b00010011};

    always begin
        #12.5 clk = ~clk;
    end

    initial begin
        #25 reset_n = 1;
        #37.5;
        for (int i = 0; i < 8; i++) begin
            io_data_valid = 1;
            io_data_packet = array[i];
            #25;
            io_data_valid = 0;
            #75;
        end
    end


    program_memory DUT1_inst_mem (
        .clk(clk),
        .byte_address(byte_address),
        .write_enable(write_enable),
        .write_data(write_data),
        .read_data(read_data)
    );

    uart_decoder DUT2_uart_decoder (
        .clk(clk),
        .reset_n(reset_n),
        .io_data_valid(io_data_valid),
        .io_data_packet(io_data_packet),
        .instruction_word(write_data),
        .byte_address(byte_address),
        .word_valid(write_enable)
    );

endmodule
