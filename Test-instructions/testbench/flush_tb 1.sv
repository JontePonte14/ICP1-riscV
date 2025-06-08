
`timescale 1ns / 1ps


module flush_tb ();

  logic clock = 0;
  logic reset_n = 0;

  logic debug_is_bj;
  logic debug_flush;
  logic debug_exception;
  logic debug_flush_d = 0;
  logic debug_is_bj_d = 0;




  logic [31:0] debug_reg[0:REGISTER_FILE_SIZE-1];
  logic [31:0] ram_debug[DATA_RAM_DEPTH/4];

  int flush_count = 0;
  int branch_count = 0;  //branch & jump instr times


  always begin
    #5 clock = ~clock;
  end


  initial begin
    #35 reset_n = 1;

  end


  cpu inst_cpu (
      // Outputs
      .debug_flush    (debug_flush),
      .debug_is_bj    (debug_is_bj),
      .debug_reg      (debug_reg),
      .debug_exception(debug_exception),
      .ram_debug      (ram_debug),
      // Inputs
      .clk            (clock),
      .reset_n        (reset_n),
      .write_address  ('0),
      .write_data     ('0),
      .write_enable   ('0)
  );

  always @(posedge clock) begin

    debug_flush_d <= debug_flush;
    debug_is_bj_d <= debug_is_bj;


    if (!debug_is_bj_d && debug_is_bj) begin
      branch_count++;
      $display("Time: %0t, BRANCH detected, branch_count = %0d", $time, branch_count);
    end

    // 
    if (!debug_flush_d && debug_flush) begin


      flush_count++;
      $display("Time: %0t, FLUSH detected (not BJ), flush_count = %0d", $time, flush_count);
    end
  end

endmodule
