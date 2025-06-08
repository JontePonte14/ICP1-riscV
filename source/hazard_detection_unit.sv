`timescale 1ns / 1ps
import common::*;

module hazard_detection_unit (
    input id_ex_mem_read,
    input [4:0] id_ex_register_rd,
    input [4:0] if_id_register_1,
    input [4:0] if_id_register_2,
    input BEU_output_type BEU_output,

    output logic PCWrite_n,
    output logic if_id_Write_n,
    output logic is_data_stall,
    output logic is_control_hazard
);

  always_comb begin
    is_data_stall = 0;
    PCWrite_n = 0;
    if_id_Write_n = 0;
    is_control_hazard = 0;
    // Same explanition as book (see page 322)

    is_control_hazard = BEU_output.mem_pc_plus4 || BEU_output.PCSrc;  //If PCSrcs or mem_pc_plus 4 is asserted then it is a control hazard

    if (! is_control_hazard && id_ex_mem_read && (
            (id_ex_register_rd == if_id_register_1) ||
            (id_ex_register_rd == if_id_register_2)))
            begin
      is_data_stall = 1;
      PCWrite_n = 1;
      if_id_Write_n = 1;
    end
  end

endmodule
