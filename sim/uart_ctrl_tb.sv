`timescale 1ns / 1ps

module uart_ctrl_tb();
    logic clk = 0;
    logic reset_n = 0;
    logic io_rx = 1;
    logic io_data_valid;
    logic [7:0] io_data_packet;
    integer row = -1; // temp
    integer value = 0; // temp

    parameter BAUD = 9600;
    localparam FREQUENCY_IN_HZ = 50_000_000;
    localparam period = 20;

    //logic [7:0] actualArray [0:3] = '{8'b00000000, 8'b01000000, 8'b00000000, 8'b10010011};
    //logic [8:0] array [0:3] = '{
    //    9'b00000000_0,  // 00000000
    //    9'b01000000_0,  // 01000000 reversed = 00000010
    //    9'b00000000_0,  // 00000000
    //    9'b10010011_0   // 10010011 reversed = 11001001
    //};

        //Actual data
    logic [7:0] actualInstructions[0:27] = '{
        8'b00000000_,// word 1
        8'b10100000_,
        8'b00000000_,
        8'b10010011, 
        8'b00000001_, // word 2
        8'b01000000_,
        8'b00000001_,
        8'b00010011, 
        8'b00000000_, // word 3
        8'b00100000_,
        8'b10000001_,
        8'b10110011, 
        8'b01000000_, // word 4
        8'b00010001_,
        8'b10000010_,
        8'b00110011, 
        8'b00000000_, // word 5
        8'b00100010_,
        8'b01000010_,
        8'b10110011_, 
        8'b00001000_, // word 6
        8'b00000000_,
        8'b00000011_,
        8'b00010011_, 
        8'b00000000_, // word 7
        8'b01010011_,
        8'b00100000_,
        8'b00100011_};

        //Input data
    logic [8:0] array [0:27] = {
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
        9'b00100011_0}; 


    always begin
        #10 clk = ~clk;
    end

    initial begin
        #30 reset_n = 1;

        #40;
        
        for (int i = 0; i < 28; i++) begin
            row = i;
            value = array[i];
            io_rx = array[i][0];
            #((((FREQUENCY_IN_HZ)/BAUD)/2)*period); // wait_half_start_bit
            for (int j = 0; j < 9; j++) begin
                io_rx = array[i][j];
                // Något är fel på delay. Den är för ofta tror jag
                //#(10); 
                #(((FREQUENCY_IN_HZ)/BAUD)*period); // 100 MHz clock & 115200 baud & period 10 ns
            end
        end
        io_rx = 1;
    end

    uart DUT (
        .clk(clk),
        .reset_n(reset_n),
        .io_rx(io_rx),
        .io_data_valid(io_data_valid),
        .io_data_packet(io_data_packet)
    );

endmodule
