`timescale 1ns / 1ps


module program_memory (
    input clk,
    input [31:0] byte_address,
    input write_enable,
    input [15:0] write_data,
    input new_instruction_write_enable,
    input clear_ram,
    output logic is_compressed,
    output logic [31:0] read_data
);

  // logic [31:0] cur_ram[256], nxt_ram[256];
  logic [8:0] word_address;
  // logic [255:0] nxt_ram_valid, cur_ram_valid;
  logic [15:0] cur_ram[512], nxt_ram[512];
  logic [0:512] nxt_ram_valid, cur_ram_valid;
  // For initalizing
  logic [31:0] temp_ram[256];

  // Temp
  logic [1:0] debug_cases;


  assign word_address = byte_address[9:1];

  always @(posedge clk) begin
    cur_ram_valid = nxt_ram_valid;
    cur_ram = nxt_ram;
      // Clear ram
    if (clear_ram) begin
      cur_ram_valid = 'b0;
    end
  end  

  always_comb begin
    // Defualt outputs
    read_data = '0;
    is_compressed = 'b0;
    debug_cases = '0;

    nxt_ram_valid = cur_ram_valid;
    nxt_ram = cur_ram;
    //Reading (set the read_data)
    if (!write_enable && cur_ram_valid[word_address] && !new_instruction_write_enable) begin
      if (cur_ram[word_address][1:0] == 2'b11) begin
        read_data[15:0] = cur_ram[word_address];
        read_data[31:16] = cur_ram[word_address + 1]; // Adds the the whole 32 bit instruction
        // Temp
        debug_cases = 2'b01;
      end else begin
        read_data[15:0] = cur_ram[word_address];
        read_data[31:16] = 16'b0000000000000000;
        is_compressed = 'b1;
        // Temp
        debug_cases = 2'b10;
      end
    end
    // Writing
    if (write_enable && new_instruction_write_enable) begin
      nxt_ram_valid[word_address] = 1;
      nxt_ram[word_address] = write_data;
      debug_cases = 2'b11;
    end
  end

  initial begin
    $readmemb("instruction_mem.mem", temp_ram);
    for (int i = 0; i < 256; i++) begin
      cur_ram[2*i] = temp_ram[i][15:0];   // Lower 16 bits
      cur_ram[2*i + 1] = temp_ram[i][31:16];  // Upper 16 bits

      if (temp_ram[i] === 'bx || temp_ram[i] == 32'b0) begin
        cur_ram_valid[2*i] = 0;
        cur_ram_valid[2*i + 1] = 0;
      end else begin
        cur_ram_valid[2*i] = 1;
        cur_ram_valid[2*i + 1] = 1;
      end
    end
  end

/*
ila_program_mem_0 inst_ila_program_mem_0 (
  .clk(clk),
  .probe0(cur_ram[0]),
  .probe1(cur_ram[1]),
  .probe2(cur_ram[2]),
  .probe3(cur_ram[3]),
  .probe4(cur_ram[4]),
  .probe5(cur_ram[5]),
  .probe6(cur_ram[6]),
  .probe7(cur_ram[7]),
  .probe8(cur_ram[8]),
  .probe9(cur_ram[9]),
  .probe10(cur_ram[10]),
  .probe11(cur_ram[11]),
  .probe12(cur_ram[12]),
  .probe13(cur_ram[13]),
  .probe14(cur_ram[14]),
  .probe15(cur_ram[15]),
  .probe16(cur_ram[16]),
  .probe17(cur_ram[17]),
  .probe18(cur_ram[18]),
  .probe19(cur_ram[19]),
  .probe20(cur_ram[20]),
  .probe21(cur_ram[21]),
  .probe22(cur_ram[22]),
  .probe23(cur_ram[23]),
  .probe24(cur_ram[24]),
  .probe25(cur_ram[25]),
  .probe26(cur_ram[26]),
  .probe27(cur_ram[27]),
  .probe28(cur_ram[28]),
  .probe29(cur_ram[29]),
  .probe30(cur_ram[30]),
  .probe31(cur_ram[31]),
  .probe32(cur_ram[32]),
  .probe33(cur_ram[33]),
  .probe34(cur_ram[34]),
  .probe35(cur_ram[35]),
  .probe36(cur_ram[36]),
  .probe37(cur_ram[37]),
  .probe38(cur_ram[38]),
  .probe39(cur_ram[39]),
  .probe40(cur_ram[40]),
  .probe41(cur_ram[41]),
  .probe42(cur_ram[42]),
  .probe43(cur_ram[43]),
  .probe44(cur_ram[44]),
  .probe45(cur_ram[45]),
  .probe46(cur_ram[46]),
  .probe47(cur_ram[47]),
  .probe48(cur_ram[48]),
  .probe49(cur_ram[49]),
  .probe50(cur_ram[50]),
  .probe51(cur_ram[51]),
  .probe52(cur_ram[52]),
  .probe53(cur_ram[53]),
  .probe54(cur_ram[54]),
  .probe55(cur_ram[55]),
  .probe56(cur_ram[56]),
  .probe57(cur_ram[57]),
  .probe58(cur_ram[58]),
  .probe59(cur_ram[59]),
  .probe60(cur_ram[60]),
  .probe61(cur_ram[61]),
  .probe62(cur_ram[62]),
  .probe63(cur_ram[63]),
  .probe64(cur_ram[64]),
  .probe65(cur_ram[65]),
  .probe66(cur_ram[66]),
  .probe67(cur_ram[67]),
  .probe68(cur_ram[68]),
  .probe69(cur_ram[69]),
  .probe70(cur_ram[70]),
  .probe71(cur_ram[71]),
  .probe72(cur_ram[72]),
  .probe73(cur_ram[73]),
  .probe74(cur_ram[74]),
  .probe75(cur_ram[75]),
  .probe76(cur_ram[76]),
  .probe77(cur_ram[77]),
  .probe78(cur_ram[78]),
  .probe79(cur_ram[79]),
  .probe80(cur_ram[80]),
  .probe81(cur_ram[81]),
  .probe82(cur_ram[82]),
  .probe83(cur_ram[83]),
  .probe84(cur_ram[84]),
  .probe85(cur_ram[85]),
  .probe86(cur_ram[86]),
  .probe87(cur_ram[87]),
  .probe88(cur_ram[88]),
  .probe89(cur_ram[89]),
  .probe90(cur_ram[90]),
  .probe91(cur_ram[91]),
  .probe92(cur_ram[92]),
  .probe93(cur_ram[93]),
  .probe94(cur_ram[94]),
  .probe95(cur_ram[95]),
  .probe96(cur_ram[96]),
  .probe97(cur_ram[97]),
  .probe98(cur_ram[98]),
  .probe99(cur_ram[99]),
  .probe100(cur_ram[100]),
  .probe101(cur_ram[101]),
  .probe102(cur_ram[102]),
  .probe103(cur_ram[103]),
  .probe104(cur_ram[104]),
  .probe105(cur_ram[105]),
  .probe106(cur_ram[106]),
  .probe107(cur_ram[107]),
  .probe108(cur_ram[108]),
  .probe109(cur_ram[109]),
  .probe110(cur_ram[110]),
  .probe111(cur_ram[111]),
  .probe112(cur_ram[112]),
  .probe113(cur_ram[113]),
  .probe114(cur_ram[114]),
  .probe115(cur_ram[115]),
  .probe116(cur_ram[116]),
  .probe117(cur_ram[117]),
  .probe118(cur_ram[118]),
  .probe119(cur_ram[119]),
  .probe120(cur_ram[120]),
  .probe121(cur_ram[121]),
  .probe122(cur_ram[122]),
  .probe123(cur_ram[123]),
  .probe124(cur_ram[124]),
  .probe125(cur_ram[125]),
  .probe126(cur_ram[126]),
  .probe127(cur_ram[127])
);
*/


// // ILA MODULE
// ila_program_mem_valid inst_ila_program_mem_valid (
//   .clk(clk),
//   .probe0(cur_ram_valid[0]),
//   .probe1(cur_ram_valid[1]),
//   .probe2(cur_ram_valid[2]),
//   .probe3(cur_ram_valid[3]),
//   .probe4(cur_ram_valid[4]),
//   .probe5(cur_ram_valid[5]),
//   .probe6(cur_ram_valid[6]),
//   .probe7(cur_ram_valid[7]),
//   .probe8(cur_ram_valid[8]),
//   .probe9(cur_ram_valid[9]),
//   .probe10(cur_ram_valid[10]),
//   .probe11(cur_ram_valid[11]),
//   .probe12(cur_ram_valid[12]),
//   .probe13(cur_ram_valid[13]),
//   .probe14(cur_ram_valid[14]),
//   .probe15(cur_ram_valid[15]),
//   .probe16(cur_ram_valid[16]),
//   .probe17(cur_ram_valid[17]),
//   .probe18(cur_ram_valid[18]),
//   .probe19(cur_ram_valid[19]),
//   .probe20(cur_ram_valid[20]),
//   .probe21(cur_ram_valid[21]),
//   .probe22(cur_ram_valid[22]),
//   .probe23(cur_ram_valid[23]),
//   .probe24(cur_ram_valid[24]),
//   .probe25(cur_ram_valid[25]),
//   .probe26(cur_ram_valid[26]),
//   .probe27(cur_ram_valid[27]),
//   .probe28(cur_ram_valid[28]),
//   .probe29(cur_ram_valid[29]),
//   .probe30(cur_ram_valid[30]),
//   .probe31(cur_ram_valid[31])
// );



endmodule