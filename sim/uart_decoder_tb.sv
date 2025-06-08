`timescale 1ns / 1ps

module uart_decoder_tb();
    //Inputs
    logic clk = 0;
    logic reset_n = 0;
    logic io_data_valid = 0;
    logic [7:0] io_data_packet = '0;

    //Outputs
    logic [31:0] instruction_word;
    logic [31:0] byte_address;
    logic word_valid;

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
        #10 clk = ~clk;
    end

    initial begin
        #20 reset_n = 1;
        #30;

        for (int i = 0; i < 8; i++) begin
            io_data_valid = 1;
            io_data_packet = array[i];
            #20;
            io_data_valid = 0;
            #60;
        end


    end

    uart_decoder DUT (
        .clk(clk),
        .reset_n(reset_n),
        .io_data_valid(io_data_valid),
        .io_data_packet(io_data_packet),
        .instruction_word(instruction_word),
        .byte_address(byte_address),
        .word_valid(word_valid)
    );
endmodule
