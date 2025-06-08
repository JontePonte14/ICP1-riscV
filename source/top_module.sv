`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/25/2025 04:14:39 PM
// Design Name: 
// Module Name: top_module
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module top_module (
    input  clk,
    input  reset_n,
    input  io_rx,
    input  new_instruction_write_enable,
    input  clear_ram,
    output RGB2_Red,
    output RGB2_Green,
    output RGB2_Blue
);

  logic io_data_valid;
  logic [7:0] io_data_packet;
  // tempory set to zero
  logic [1:0] exception_led;

  logic reg_RGB2_Red_cur, reg_RGB2_Red_nxt;
  logic reg_RGB2_Green_cur, reg_RGB2_Green_nxt;
  logic reg_RGB2_Blue_cur, reg_RGB2_Blue_nxt;

  assign RGB2_Red   = reg_RGB2_Red_cur;
  assign RGB2_Green = reg_RGB2_Green_cur;
  assign RGB2_Blue  = reg_RGB2_Blue_cur;

  // reset register sync
  logic sync_reset1, sync_reset2;
  // new program sync
  logic new_instruction_write_enable_sync1, new_instruction_write_enable_sync2;

  always_ff @(posedge clk) begin
    sync_reset1 <= reset_n;
    sync_reset2 <= sync_reset1;
    new_instruction_write_enable_sync1 <= new_instruction_write_enable;
    new_instruction_write_enable_sync2 <= new_instruction_write_enable_sync1;
    
    if (!sync_reset2) begin
      reg_RGB2_Red_cur   <= 0;
      reg_RGB2_Blue_cur  <= 0;
      reg_RGB2_Green_cur <= 0;
    end else begin
      reg_RGB2_Red_cur   <= reg_RGB2_Red_nxt;
      reg_RGB2_Blue_cur  <= reg_RGB2_Blue_nxt;
      reg_RGB2_Green_cur <= reg_RGB2_Green_nxt;
    end
  end

  always_comb begin : led_combinational
    reg_RGB2_Red_nxt   <= reg_RGB2_Red_cur;
    reg_RGB2_Blue_nxt  <= reg_RGB2_Blue_cur;
    reg_RGB2_Green_nxt <= reg_RGB2_Green_cur;
    if (exception_led == 2'b00) begin
      reg_RGB2_Red_nxt   <= '0;
      reg_RGB2_Green_nxt <= '1;
      reg_RGB2_Blue_nxt  <= '0;
    end else if (exception_led == 2'b01) begin
      // red is for ID exception
      reg_RGB2_Red_nxt   <= '1;
      reg_RGB2_Green_nxt <= '0;
      reg_RGB2_Blue_nxt  <= '0;
    end else if (exception_led == 2'b10) begin
      // yellow? EX exception
      reg_RGB2_Red_nxt   <= '1;
      reg_RGB2_Green_nxt <= '1;
      reg_RGB2_Blue_nxt  <= '0;
    end else begin
      // control exception
      reg_RGB2_Red_nxt   <= '0;
      reg_RGB2_Green_nxt <= '0;
      reg_RGB2_Blue_nxt  <= '1;
    end
  end

  cpu cpu_unit (
      .clk(clk),
      .reset_n(sync_reset2),
      .io_data_valid(io_data_valid),
      .io_data_packet(io_data_packet),
      .new_instruction_write_enable(new_instruction_write_enable),
      .program_clear_ram(clear_ram),
      .exception(exception_led)
  );

  uart uart_controller (
      .clk(clk),
      .reset_n(sync_reset2),
      .io_rx(io_rx),
      .io_data_valid(io_data_valid),
      .io_data_packet(io_data_packet)
  );
endmodule
