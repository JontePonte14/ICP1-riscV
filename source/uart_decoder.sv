`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Jonathan
// Module Name: uart_decoder
//////////////////////////////////////////////////////////////////////////////////


module uart_decoder(
    input logic clk,
    input logic reset_n,
    input logic io_data_valid,
    input logic [7:0] io_data_packet,

    output logic [15:0] instruction_word,
    output logic [31:0] byte_address,
    output logic word_valid
    );

    logic [31:0] cur_byte_address;
    logic [31:0] nxt_byte_address;
    logic [15:0] cur_instruction_word;
    logic [15:0] nxt_instruction_word;
    typedef enum {s_idle, s_byte0, s_word_valid} state_t ;
    state_t cur_state, nxt_state;

    always @(posedge clk) begin
        if (!reset_n) begin
            cur_byte_address <= '0;
            cur_instruction_word <= '0;
            cur_state <= s_idle;

        end else begin
            cur_byte_address <= nxt_byte_address;
            cur_instruction_word <= nxt_instruction_word;
            cur_state <= nxt_state;

        end
    end

    assign instruction_word = cur_instruction_word;
    assign byte_address = cur_byte_address;

    always_comb begin
        word_valid <= 0;
        nxt_state <= cur_state;
        nxt_byte_address <= cur_byte_address;
        nxt_instruction_word <= cur_instruction_word;

        case (cur_state)
            s_idle:
            begin
                if (io_data_valid == 1) begin
                    nxt_instruction_word[7:0] <= io_data_packet;
                    nxt_state <= s_byte0;
                end
            end

            s_byte0:
            begin
                if (io_data_valid == 1) begin
                    nxt_instruction_word[15:8] <= io_data_packet;
                    nxt_state <= s_word_valid;
                end
            end

            s_word_valid:
            begin
                word_valid <= 1;
                // Valid for only one clock period.
                // During this time is the byte_address and
                // instruction_word valid
                nxt_byte_address <= cur_byte_address + 2;
                nxt_state <= s_idle;                
            end

            default: nxt_state = s_idle;
        endcase

    end
endmodule
