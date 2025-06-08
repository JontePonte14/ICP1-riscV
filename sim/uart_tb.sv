`timescale 1ns / 1ps

module uart_tb();
    logic clk = 0;
    logic reset_n = 0;
    logic io_rx = 1;
    logic io_data_valid;
    logic [7:0] io_data_packet;

    logic [15:0] instruction_word;
    logic [31:0] byte_address;
    logic word_valid;

    int row = -1;
    int colum = -1;
    logic [7:0] value;

    parameter BAUD = 9600;
    localparam FREQUENCY_IN_HZ = 50_000_000;
    localparam period = 20;

    //     //Actual data
    // logic [7:0] actualArray [0:7] = '{
    //     8'b00000000, // word 1
    //     8'b01000000, 
    //     8'b00000000, 
    //     8'b10010011,
    //     8'b00000000, // word 2
    //     8'b10000000,
    //     8'b00000001,
    //     8'b00010011};

        //Actual data
    logic [31:0] actualInstructions[0:11] = '{
    32'b00000000_10100000_00000000_10010011, // word 1
    32'b00000001_01000000_00000001_00010011, // word 2
    32'b00000000_00100000_10000001_10110011, // word 3
    32'b01000000_00010001_10000010_00110011, // word 4
    32'b00000000_00100010_01000010_10110011, // word 5
    32'b00001000_00000000_00000011_00010011, // word 6
    32'b00000000_01010011_00100000_00100011, // word 7
    32'b00000000_00000011_00100011_10000011, // word 8
    32'b00000000_00010011_11100100_00110011, // word 9
    32'b00000000_00100100_00000100_10110011, // word 10
    32'b00000000_00110100_11110101_00110011, // word 11
    32'b01000000_00010101_00000101_10110011}; // word 12

        //Input data
    logic [8:0] array [0:47] = {
        9'b0_00000000_, // word 1
        9'b10100000_0,
        9'b00000000_0,
        9'b10010011_0,
        9'b00000001_0, // word 2
        9'b01000000_0,
        9'b00000001_0,
        9'b00010011_0,
        9'b00000000_0, // word 3
        9'b00100000_0,
        9'b10000001_0,
        9'b10110011_0,
        9'b01000000_0, // word 4
        9'b00010001_0,
        9'b10000010_0,
        9'b00110011_0,
        9'b00000000_0, // word 5
        9'b00100010_0,
        9'b01000010_0,
        9'b10110011_0,
        9'b00001000_0, // word 6
        9'b00000000_0,
        9'b00000011_0,
        9'b00010011_0,
        9'b00000000_0, // word 7
        9'b01010011_0,
        9'b00100000_0,
        9'b00100011_0, 
        9'b00000000_0, // word 8
        9'b00000011_0,
        9'b00100011_0,
        9'b10000011_0,
        9'b00000000_0, // word 9
        9'b00010011_0,
        9'b11100100_0,
        9'b00110011_0,
        9'b00000000_0, // word 10
        9'b00100100_0,
        9'b00000100_0,
        9'b10110011_0,
        9'b00000000_0, // word 11
        9'b00110100_0,
        9'b11110101_0,
        9'b00110011_0,
        9'b01000000_0, // word 12
        9'b00010101_0,
        9'b00000101_0,
        9'b10110011_0}; // word 12


    always begin
        #10 clk = ~clk;
    end

    logic [9:0] uart_bitstream [0:47]; // 12 words × 4 bytes = 48 UART transmissions

    initial begin
        int idx = 0;
        logic [31:0] instr;
        logic [7:0] data_byte;
        logic [8:0] frame; // 9 bits: start (bit 0) + 8-bit data

        for (int i = 0; i < 12; i++) begin
            instr = actualInstructions[i];

            // Split into 4 bytes (little-endian)
            for (int j = 0; j < 4; j++) begin
                data_byte = instr >> (8 * j);         // Get byte j (LSB first)
                frame = {data_byte, 1'b0};            // 8 bits + start bit at LSB
                uart_bitstream[idx++] = frame;
            end
        end
    end



    initial begin
        #30 reset_n = 1;
        #40;

        for (int i = 0; i < 48; i++) begin
            row = i;
            value = uart_bitstream[i][8:1]; // Data for debugging

            // Set start bit (bit 0 = 0)
            io_rx = 0;
            #((((FREQUENCY_IN_HZ)/BAUD)/2)*period); // Wait half-bit to sync to middle of start bit

            // Send full 9 bits (start + data[7:0], LSB first)
            for (int j = 0; j < 9; j++) begin
            colum = j;
            io_rx = uart_bitstream[i][j]; // Transmit bit j
            #(((FREQUENCY_IN_HZ)/BAUD)*period); // One bit period
            end
        end

        io_rx = 1; // Line idle
    end



    uart DUT1_uart(
        .clk(clk),
        .reset_n(reset_n),
        .io_rx(io_rx),
        .io_data_valid(io_data_valid),
        .io_data_packet(io_data_packet)
    );

    uart_decoder DUT2_uart_decoder(
        .clk(clk),
        .reset_n(reset_n),
        .io_data_valid(io_data_valid),
        .io_data_packet(io_data_packet),
        .instruction_word(instruction_word),
        .byte_address(byte_address),
        .word_valid(word_valid)
    );
/*
    program_memory DUT1_inst_mem (
        .clk(clk),
        .byte_address(byte_address),
        .write_enable(write_enable),
        .write_data(write_data),
        .read_data(read_data),
        .new_instruction_write_enable(new_instruction_write_enable)
    );

*/


endmodule
