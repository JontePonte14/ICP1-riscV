`timescale 1ns / 1ps

//------------------------------------------------
// ********************OBS************************
// Endast tre instruktioner laddas in här. 
// INTE alla 12 som "actualInstruction" innehåller
// ***********************************************
//------------------------------------------------

module top_tb();
    logic clk = 0;
    logic reset_n = 0;
    logic io_rx = 1;
    logic new_instruction_write_enable = 0;
    logic RGB2_Red;
    logic RGB2_Green;
    logic RGB2_Blue;
    logic clear_ram = 0;

    parameter BAUD = 9600;
    //parameter BAUD = 9600;
    localparam FREQUENCY_IN_HZ = 50_000_000;
    localparam period = 20;

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
        9'b00000000_0, // word 1
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

    initial begin
        #40 reset_n = 1;
        // Let the "normal instruction run first.
        // If the time is not enough, increase below.
        #5000;
        // Before loading new instruction we need to clear the program memory
        clear_ram = 1;
        #30;
        clear_ram = 0;
        #400;
        new_instruction_write_enable = 1;
        for (int i = 0; i < 9; i++) begin
            io_rx = array[i][0];
            #((((FREQUENCY_IN_HZ)/BAUD)/2)*period); // wait_half_start_bit
            for (int j = 0; j < 9; j++) begin
                io_rx = array[i][j];
                #(((FREQUENCY_IN_HZ)/BAUD)*period); // 100 MHz clock & 115200 baud & period 10 ns
            end
        end
        io_rx = 1;
        #2500;
        reset_n = 0;
        #40;
        #20 reset_n = 1;
        #60;
        new_instruction_write_enable = 0;
        #200;
        //#5 reset_n = 0;
        //#20 reset_n = 1;
    end

    top_module top (
        .clk(clk),
        .reset_n(reset_n),
        .io_rx(io_rx),
        .new_instruction_write_enable(new_instruction_write_enable),
        .clear_ram(clear_ram),
        .RGB2_Red(RGB2_Red),
        .RGB2_Green(RGB2_Green),
        .RGB2_Blue(RGB2_Blue)

    );


endmodule
