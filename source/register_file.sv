`timescale 1ns / 1ps


module register_file (
    input clk,
    input reset_n,
    input write_en,
    input [4:0] read1_id,
    input [4:0] read2_id,
    input [4:0] write_id,
    input [31:0] write_data,
    output logic [31:0] read1_data,
    output logic [31:0] read2_data
);

  localparam REGISTER_FILE_SIZE = 32;

  logic [31:0] registers[0:REGISTER_FILE_SIZE-1] = '{default: 0};


  always_ff @(posedge clk) begin
    if (!reset_n) begin
      registers = '{default: 0};
    end else if (write_en) begin
      if (write_id != '0) begin
        registers[write_id] <= write_data;
      end
    end
  end

  assign read1_data = read1_id == 0 ? 0 : registers[read1_id];
  assign read2_data = read2_id == 0 ? 0 : registers[read2_id];

/*
    // ILA MODUL
// ILA MODULE
ila_registers inst_ila_registers (
  .clk(clk),
  .probe0(registers[0]),
  .probe1(registers[1]),
  .probe2(registers[2]),
  .probe3(registers[3]),
  .probe4(registers[4]),
  .probe5(registers[5]),
  .probe6(registers[6]),
  .probe7(registers[7]),
  .probe8(registers[8]),
  .probe9(registers[9]),
  .probe10(registers[10]),
  .probe11(registers[11]),
  .probe12(registers[12]),
  .probe13(registers[13]),
  .probe14(registers[14]),
  .probe15(registers[15]),
  .probe16(registers[16]),
  .probe17(registers[17]),
  .probe18(registers[18]),
  .probe19(registers[19]),
  .probe20(registers[20]),
  .probe21(registers[21]),
  .probe22(registers[22]),
  .probe23(registers[23]),
  .probe24(registers[24]),
  .probe25(registers[25]),
  .probe26(registers[26]),
  .probe27(registers[27]),
  .probe28(registers[28]),
  .probe29(registers[29]),
  .probe30(registers[30]),
  .probe31(registers[31])
);
*/


endmodule
