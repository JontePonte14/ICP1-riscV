`timescale 1ns / 1ps

module uart_with_decodor_and_inst_mem_tb();
    logic clk = 0;
    logic reset_n = 0;
    logic [31:0] byte_address;
    logic write_enable;
    logic [31:0] write_data;
    logic [31:0] read_data;
    logic io_data_valid;
    logic [7:0] io_data_packet;
    logic io_rx = 1;
    logic row = -1;
    logic [8:0] value = '0;
    logic new_instruction_write_enable = 0;
    logic [31:0] read_data;

    parameter BAUD = 115200;
    localparam FREQUENCY_IN_HZ = 80_000_000;
    localparam period = 12.5;

        //Actual data
    logic [7:0] actualArray [0:7] = '{
        8'b00000000, // word 1
        8'b01000000, 
        8'b00000000, 
        8'b10010011,
        8'b00000000, // word 2
        8'b10000000,
        8'b00000001,
        8'b00010011};

        //Input data
    logic [8:0] array [0:7] = '{
        9'b00000000_0, // word 1
        9'b01000000_0, 
        9'b00000000_0, 
        9'b10010011_0,
        9'b00000000_0, // word 2
        9'b10000000_0,
        9'b00000001_0,
        9'b00010011_0};


    always begin
        #6.25 clk = ~clk;
    end

    initial begin
        #25 reset_n = 1;

        #6.25;
        new_instruction_write_enable = 1;
        for (int i = 0; i < 8; i++) begin
            row = i;
            value = array[i];
            for (int j = 0; j < 9; j++) begin
                io_rx = array[i][j];
                #(((FREQUENCY_IN_HZ)/BAUD)/2); // wait_half_start_bit
                #(((FREQUENCY_IN_HZ)/BAUD)*10); // 100 MHz clock & 115200 baud & period 10 ns
            end
        end
        io_rx = 1;
    end

    program_memory DUT1_inst_mem (
        .clk(clk),
        .byte_address(byte_address),
        .write_enable(write_enable),
        .write_data(write_data),
        .read_data(read_data),
        .new_instruction_write_enable(new_instruction_write_enable)
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

    uart DUT3_uart(
        .clk(clk),
        .reset_n(reset_n),
        .io_rx(io_rx),
        .io_data_valid(io_data_valid),
        .io_data_packet(io_data_packet)
    );



endmodule
