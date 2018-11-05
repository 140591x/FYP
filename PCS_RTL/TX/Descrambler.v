`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:27:08 11/04/2014 
// Design Name: 
// Module Name:    Descrambler 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module Descrambler(
  input [263:0] data_in,
  input descram_en,
  input descram_rst,
  output reg [263:0] data_out,
  input rst,
  input clk);

  reg [57:0] lfsr_q,lfsr_c;
  reg [263:0] data_c;

  always @(*) begin
  
    lfsr_c = data_in[65:8];

    data_c[200] = data_in[200] ^ lfsr_q[19] ^ lfsr_q[0];
    data_c[201] = data_in[201] ^ lfsr_q[20] ^ lfsr_q[1];
    data_c[202] = data_in[202] ^ lfsr_q[21] ^ lfsr_q[2];
    data_c[203] = data_in[203] ^ lfsr_q[22] ^ lfsr_q[3];	 
    data_c[204] = data_in[204] ^ lfsr_q[23] ^ lfsr_q[4];
    data_c[205] = data_in[205] ^ lfsr_q[24] ^ lfsr_q[5];
    data_c[206] = data_in[206] ^ lfsr_q[25] ^ lfsr_q[6];
    data_c[207] = data_in[207] ^ lfsr_q[26] ^ lfsr_q[7];	 
    data_c[208] = data_in[208] ^ lfsr_q[27] ^ lfsr_q[8];
    data_c[209] = data_in[209] ^ lfsr_q[28] ^ lfsr_q[9];
    data_c[210] = data_in[210] ^ lfsr_q[29] ^ lfsr_q[10];
    data_c[211] = data_in[211] ^ lfsr_q[30] ^ lfsr_q[11];	 
    data_c[212] = data_in[212] ^ lfsr_q[31] ^ lfsr_q[12];
    data_c[213] = data_in[213] ^ lfsr_q[32] ^ lfsr_q[13];
    data_c[214] = data_in[214] ^ lfsr_q[33] ^ lfsr_q[14];
    data_c[215] = data_in[215] ^ lfsr_q[34] ^ lfsr_q[15];	
    data_c[216] = data_in[216] ^ lfsr_q[35] ^ lfsr_q[16];
    data_c[217] = data_in[217] ^ lfsr_q[36] ^ lfsr_q[17];
    data_c[218] = data_in[218] ^ lfsr_q[37] ^ lfsr_q[18];
    data_c[219] = data_in[219] ^ lfsr_q[38] ^ lfsr_q[19];	 
    data_c[220] = data_in[220] ^ lfsr_q[39] ^ lfsr_q[20];
    data_c[221] = data_in[221] ^ lfsr_q[40] ^ lfsr_q[21];
    data_c[222] = data_in[222] ^ lfsr_q[41] ^ lfsr_q[22];
    data_c[223] = data_in[223] ^ lfsr_q[42] ^ lfsr_q[23];
    data_c[224] = data_in[224] ^ lfsr_q[43] ^ lfsr_q[24];
    data_c[225] = data_in[225] ^ lfsr_q[44] ^ lfsr_q[25];
    data_c[226] = data_in[226] ^ lfsr_q[45] ^ lfsr_q[26];
    data_c[227] = data_in[227] ^ lfsr_q[46] ^ lfsr_q[27];	
    data_c[228] = data_in[228] ^ lfsr_q[47] ^ lfsr_q[28];
    data_c[229] = data_in[229] ^ lfsr_q[48] ^ lfsr_q[29];
    data_c[230] = data_in[230] ^ lfsr_q[49] ^ lfsr_q[30];
    data_c[231] = data_in[231] ^ lfsr_q[50] ^ lfsr_q[31];	 
    data_c[232] = data_in[232] ^ lfsr_q[51] ^ lfsr_q[32];
    data_c[233] = data_in[233] ^ lfsr_q[52] ^ lfsr_q[33];
    data_c[234] = data_in[234] ^ lfsr_q[53] ^ lfsr_q[34];
    data_c[235] = data_in[235] ^ lfsr_q[54] ^ lfsr_q[35];
    data_c[236] = data_in[236] ^ lfsr_q[55] ^ lfsr_q[36];
    data_c[237] = data_in[237] ^ lfsr_q[56] ^ lfsr_q[37];
    data_c[238] = data_in[238] ^ lfsr_q[57] ^ lfsr_q[38];	
	 data_c[239] = data_in[239] ^ data_in[200] ^ lfsr_q[39];
	 data_c[240] = data_in[240] ^ data_in[201] ^ lfsr_q[40]; 
	 data_c[241] = data_in[241] ^ data_in[202] ^ lfsr_q[41];
	 data_c[242] = data_in[242] ^ data_in[203] ^ lfsr_q[42]; 	 
	 data_c[243] = data_in[243] ^ data_in[204] ^ lfsr_q[43];
	 data_c[244] = data_in[244] ^ data_in[205] ^ lfsr_q[44]; 
	 data_c[245] = data_in[245] ^ data_in[206] ^ lfsr_q[45];
	 data_c[246] = data_in[246] ^ data_in[207] ^ lfsr_q[46];
	 data_c[247] = data_in[247] ^ data_in[208] ^ lfsr_q[47];
	 data_c[248] = data_in[248] ^ data_in[209] ^ lfsr_q[48]; 
	 data_c[249] = data_in[249] ^ data_in[210] ^ lfsr_q[49];
	 data_c[250] = data_in[250] ^ data_in[211] ^ lfsr_q[50]; 	 
	 data_c[251] = data_in[251] ^ data_in[212] ^ lfsr_q[51];
	 data_c[252] = data_in[252] ^ data_in[213] ^ lfsr_q[52]; 
	 data_c[253] = data_in[253] ^ data_in[214] ^ lfsr_q[53];
	 data_c[254] = data_in[254] ^ data_in[215] ^ lfsr_q[54];
	 data_c[255] = data_in[255] ^ data_in[216] ^ lfsr_q[55];
	 data_c[256] = data_in[256] ^ data_in[217] ^ lfsr_q[56]; 
	 data_c[257] = data_in[257] ^ data_in[218] ^ lfsr_q[57];
	 data_c[258] = data_in[258] ^ data_in[219] ^ data_in[200];
	 data_c[259] = data_in[259] ^ data_in[220] ^ data_in[201];
	 data_c[260] = data_in[260] ^ data_in[221] ^ data_in[202];
	 data_c[261] = data_in[261] ^ data_in[222] ^ data_in[203];
	 data_c[262] = data_in[262] ^ data_in[223] ^ data_in[204];
	 data_c[263] = data_in[263] ^ data_in[224] ^ data_in[205];	 
 
	 data_c[134] = data_in[134] ^ data_in[225] ^ data_in[206];	
	 data_c[135] = data_in[135] ^ data_in[226] ^ data_in[207];
	 data_c[136] = data_in[136] ^ data_in[227] ^ data_in[208];
	 data_c[137] = data_in[137] ^ data_in[228] ^ data_in[209];
	 data_c[138] = data_in[138] ^ data_in[229] ^ data_in[210];
	 data_c[139] = data_in[139] ^ data_in[230] ^ data_in[211];
	 data_c[140] = data_in[140] ^ data_in[231] ^ data_in[212];
	 data_c[141] = data_in[141] ^ data_in[232] ^ data_in[213];
	 data_c[142] = data_in[142] ^ data_in[233] ^ data_in[214];	
	 data_c[143] = data_in[143] ^ data_in[234] ^ data_in[215];
	 data_c[144] = data_in[144] ^ data_in[235] ^ data_in[216];
	 data_c[145] = data_in[145] ^ data_in[236] ^ data_in[217];
	 data_c[146] = data_in[146] ^ data_in[237] ^ data_in[218];
	 data_c[147] = data_in[147] ^ data_in[238] ^ data_in[219];
	 data_c[148] = data_in[148] ^ data_in[239] ^ data_in[220];
	 data_c[149] = data_in[149] ^ data_in[240] ^ data_in[221];
	 data_c[150] = data_in[150] ^ data_in[241] ^ data_in[222];	
	 data_c[151] = data_in[151] ^ data_in[242] ^ data_in[223];
	 data_c[152] = data_in[152] ^ data_in[243] ^ data_in[224];
	 data_c[153] = data_in[153] ^ data_in[244] ^ data_in[225];
	 data_c[154] = data_in[154] ^ data_in[245] ^ data_in[226];
	 data_c[155] = data_in[155] ^ data_in[246] ^ data_in[227];
	 data_c[156] = data_in[156] ^ data_in[247] ^ data_in[228];
	 data_c[157] = data_in[157] ^ data_in[248] ^ data_in[229];
	 data_c[158] = data_in[158] ^ data_in[249] ^ data_in[230];	
	 data_c[159] = data_in[159] ^ data_in[250] ^ data_in[231];
	 data_c[160] = data_in[160] ^ data_in[251] ^ data_in[232];
	 data_c[161] = data_in[161] ^ data_in[252] ^ data_in[233];
	 data_c[162] = data_in[162] ^ data_in[253] ^ data_in[234];
	 data_c[163] = data_in[163] ^ data_in[254] ^ data_in[235];
	 data_c[164] = data_in[164] ^ data_in[255] ^ data_in[236];
	 data_c[165] = data_in[165] ^ data_in[256] ^ data_in[237];
	 data_c[166] = data_in[166] ^ data_in[257] ^ data_in[238];	
	 data_c[167] = data_in[167] ^ data_in[258] ^ data_in[239];
	 data_c[168] = data_in[168] ^ data_in[259] ^ data_in[240];
	 data_c[169] = data_in[169] ^ data_in[260] ^ data_in[241];
	 data_c[170] = data_in[170] ^ data_in[261] ^ data_in[242];
	 data_c[171] = data_in[171] ^ data_in[262] ^ data_in[243];
	 data_c[172] = data_in[172] ^ data_in[263] ^ data_in[244];
	 data_c[173] = data_in[173] ^ data_in[134] ^ data_in[245];
	 data_c[174] = data_in[174] ^ data_in[135] ^ data_in[246];	
	 data_c[175] = data_in[175] ^ data_in[136] ^ data_in[247];
	 data_c[176] = data_in[176] ^ data_in[137] ^ data_in[248];
	 data_c[177] = data_in[177] ^ data_in[138] ^ data_in[249];
	 data_c[178] = data_in[178] ^ data_in[139] ^ data_in[250];
	 data_c[179] = data_in[179] ^ data_in[140] ^ data_in[251];
	 data_c[180] = data_in[180] ^ data_in[141] ^ data_in[252];
	 data_c[181] = data_in[181] ^ data_in[142] ^ data_in[253];
	 data_c[182] = data_in[182] ^ data_in[143] ^ data_in[254];	
	 data_c[183] = data_in[183] ^ data_in[144] ^ data_in[255];
	 data_c[184] = data_in[184] ^ data_in[145] ^ data_in[256];
	 data_c[185] = data_in[185] ^ data_in[146] ^ data_in[257];
	 data_c[186] = data_in[186] ^ data_in[147] ^ data_in[258];
	 data_c[187] = data_in[187] ^ data_in[148] ^ data_in[259];
	 data_c[188] = data_in[188] ^ data_in[149] ^ data_in[260];
	 data_c[189] = data_in[189] ^ data_in[150] ^ data_in[261];
	 data_c[190] = data_in[190] ^ data_in[151] ^ data_in[262];	
	 data_c[191] = data_in[191] ^ data_in[152] ^ data_in[263];
	 data_c[192] = data_in[192] ^ data_in[153] ^ data_in[134];
	 data_c[193] = data_in[193] ^ data_in[154] ^ data_in[135];
	 data_c[194] = data_in[194] ^ data_in[155] ^ data_in[136];
	 data_c[195] = data_in[195] ^ data_in[156] ^ data_in[137];
	 data_c[196] = data_in[196] ^ data_in[157] ^ data_in[138];
	 data_c[197] = data_in[197] ^ data_in[158] ^ data_in[139];	 

	 data_c[68] = data_in[68] ^ data_in[159] ^ data_in[140];	
	 data_c[69] = data_in[69] ^ data_in[160] ^ data_in[141];
	 data_c[70] = data_in[70] ^ data_in[161] ^ data_in[142];	
	 data_c[71] = data_in[71] ^ data_in[162] ^ data_in[143];
	 data_c[72] = data_in[72] ^ data_in[163] ^ data_in[144];	
	 data_c[73] = data_in[73] ^ data_in[164] ^ data_in[145];
	 data_c[74] = data_in[74] ^ data_in[165] ^ data_in[146];	
	 data_c[75] = data_in[75] ^ data_in[166] ^ data_in[147];	
	 data_c[76] = data_in[76] ^ data_in[167] ^ data_in[148];	
	 data_c[77] = data_in[77] ^ data_in[168] ^ data_in[149];
	 data_c[78] = data_in[78] ^ data_in[169] ^ data_in[150];	
	 data_c[79] = data_in[79] ^ data_in[170] ^ data_in[151];
	 data_c[80] = data_in[80] ^ data_in[171] ^ data_in[152];	
	 data_c[81] = data_in[81] ^ data_in[172] ^ data_in[153];
	 data_c[82] = data_in[82] ^ data_in[173] ^ data_in[154];	
	 data_c[83] = data_in[83] ^ data_in[174] ^ data_in[155];
	 data_c[84] = data_in[84] ^ data_in[175] ^ data_in[156];	
	 data_c[85] = data_in[85] ^ data_in[176] ^ data_in[157];
	 data_c[86] = data_in[86] ^ data_in[177] ^ data_in[158];	
	 data_c[87] = data_in[87] ^ data_in[178] ^ data_in[159];
	 data_c[88] = data_in[88] ^ data_in[179] ^ data_in[160];	
	 data_c[89] = data_in[89] ^ data_in[180] ^ data_in[161];
	 data_c[90] = data_in[90] ^ data_in[181] ^ data_in[162];	
	 data_c[91] = data_in[91] ^ data_in[182] ^ data_in[163];
	 data_c[92] = data_in[92] ^ data_in[183] ^ data_in[164];	
	 data_c[93] = data_in[93] ^ data_in[184] ^ data_in[165];
	 data_c[94] = data_in[94] ^ data_in[185] ^ data_in[166];	
	 data_c[95] = data_in[95] ^ data_in[186] ^ data_in[167];
	 data_c[96] = data_in[96] ^ data_in[187] ^ data_in[168];	
	 data_c[97] = data_in[97] ^ data_in[188] ^ data_in[169];
	 data_c[98] = data_in[98] ^ data_in[189] ^ data_in[170];	
	 data_c[99] = data_in[99] ^ data_in[190] ^ data_in[171];
	 data_c[100] = data_in[100] ^ data_in[191] ^ data_in[172];	
	 data_c[101] = data_in[101] ^ data_in[192] ^ data_in[173];
	 data_c[102] = data_in[102] ^ data_in[193] ^ data_in[174];	
	 data_c[103] = data_in[103] ^ data_in[194] ^ data_in[175];
	 data_c[104] = data_in[104] ^ data_in[195] ^ data_in[176];	
	 data_c[105] = data_in[105] ^ data_in[196] ^ data_in[177];
	 data_c[106] = data_in[106] ^ data_in[197] ^ data_in[178];	
	 data_c[107] = data_in[107] ^ data_in[68] ^ data_in[179];
	 data_c[108] = data_in[108] ^ data_in[69] ^ data_in[180];	
	 data_c[109] = data_in[109] ^ data_in[70] ^ data_in[181];
	 data_c[110] = data_in[110] ^ data_in[71] ^ data_in[182];	
	 data_c[111] = data_in[111] ^ data_in[72] ^ data_in[183];
	 data_c[112] = data_in[112] ^ data_in[73] ^ data_in[184];	
	 data_c[113] = data_in[113] ^ data_in[74] ^ data_in[185];
	 data_c[114] = data_in[114] ^ data_in[75] ^ data_in[186];	
	 data_c[115] = data_in[115] ^ data_in[76] ^ data_in[187];
	 data_c[116] = data_in[116] ^ data_in[77] ^ data_in[188];	
	 data_c[117] = data_in[117] ^ data_in[78] ^ data_in[189];
	 data_c[118] = data_in[118] ^ data_in[79] ^ data_in[190];	
	 data_c[119] = data_in[119] ^ data_in[80] ^ data_in[191];
	 data_c[120] = data_in[120] ^ data_in[81] ^ data_in[192];	
	 data_c[121] = data_in[121] ^ data_in[82] ^ data_in[193];
	 data_c[122] = data_in[122] ^ data_in[83] ^ data_in[194];	
	 data_c[123] = data_in[123] ^ data_in[84] ^ data_in[195];
	 data_c[124] = data_in[124] ^ data_in[85] ^ data_in[196];	
	 data_c[125] = data_in[125] ^ data_in[86] ^ data_in[197];
	 data_c[126] = data_in[126] ^ data_in[87] ^ data_in[68];	
	 data_c[127] = data_in[127] ^ data_in[88] ^ data_in[69];
	 data_c[128] = data_in[128] ^ data_in[89] ^ data_in[70];	
	 data_c[129] = data_in[129] ^ data_in[90] ^ data_in[71];
	 data_c[130] = data_in[130] ^ data_in[91] ^ data_in[72];	
	 data_c[131] = data_in[131] ^ data_in[92] ^ data_in[73];	 

	 data_c[2] = data_in[2] ^ data_in[93] ^ data_in[74];
	 data_c[3] = data_in[3] ^ data_in[94] ^ data_in[75];
	 data_c[4] = data_in[4] ^ data_in[95] ^ data_in[76];
	 data_c[5] = data_in[5] ^ data_in[96] ^ data_in[77];
	 data_c[6] = data_in[6] ^ data_in[97] ^ data_in[78];
	 data_c[7] = data_in[7] ^ data_in[98] ^ data_in[79];
	 data_c[8] = data_in[8] ^ data_in[99] ^ data_in[80];
	 data_c[9] = data_in[9] ^ data_in[100] ^ data_in[81];
	 data_c[10] = data_in[10] ^ data_in[101] ^ data_in[82];
	 data_c[11] = data_in[11] ^ data_in[102] ^ data_in[83];
	 data_c[12] = data_in[12] ^ data_in[103] ^ data_in[84];
	 data_c[13] = data_in[13] ^ data_in[104] ^ data_in[85];
	 data_c[14] = data_in[14] ^ data_in[105] ^ data_in[86];
	 data_c[15] = data_in[15] ^ data_in[106] ^ data_in[87];
	 data_c[16] = data_in[16] ^ data_in[107] ^ data_in[88];
	 data_c[17] = data_in[17] ^ data_in[108] ^ data_in[89];
	 data_c[18] = data_in[18] ^ data_in[109] ^ data_in[90];
	 data_c[19] = data_in[19] ^ data_in[110] ^ data_in[91];
	 data_c[20] = data_in[20] ^ data_in[111] ^ data_in[92];
	 data_c[21] = data_in[21] ^ data_in[112] ^ data_in[93];
	 data_c[22] = data_in[22] ^ data_in[113] ^ data_in[94];
	 data_c[23] = data_in[23] ^ data_in[114] ^ data_in[95];
	 data_c[24] = data_in[24] ^ data_in[115] ^ data_in[96];
	 data_c[25] = data_in[25] ^ data_in[116] ^ data_in[97];
	 data_c[26] = data_in[26] ^ data_in[117] ^ data_in[98];
	 data_c[27] = data_in[27] ^ data_in[118] ^ data_in[99];
	 data_c[28] = data_in[28] ^ data_in[119] ^ data_in[100];
	 data_c[29] = data_in[29] ^ data_in[120] ^ data_in[101];
	 data_c[30] = data_in[30] ^ data_in[121] ^ data_in[102];
	 data_c[31] = data_in[31] ^ data_in[122] ^ data_in[103];
	 data_c[32] = data_in[32] ^ data_in[123] ^ data_in[104];
	 data_c[33] = data_in[33] ^ data_in[124] ^ data_in[105];
	 data_c[34] = data_in[34] ^ data_in[125] ^ data_in[106];
	 data_c[35] = data_in[35] ^ data_in[126] ^ data_in[107];
	 data_c[36] = data_in[36] ^ data_in[127] ^ data_in[108];
	 data_c[37] = data_in[37] ^ data_in[128] ^ data_in[109];
	 data_c[38] = data_in[38] ^ data_in[129] ^ data_in[110];
	 data_c[39] = data_in[39] ^ data_in[130] ^ data_in[111];
	 data_c[40] = data_in[40] ^ data_in[131] ^ data_in[112];
	 data_c[41] = data_in[41] ^ data_in[2] ^ data_in[113];
	 data_c[42] = data_in[42] ^ data_in[3] ^ data_in[114];
	 data_c[43] = data_in[43] ^ data_in[4] ^ data_in[115];
	 data_c[44] = data_in[44] ^ data_in[5] ^ data_in[116];
	 data_c[45] = data_in[45] ^ data_in[6] ^ data_in[117];
	 data_c[46] = data_in[46] ^ data_in[7] ^ data_in[118];
	 data_c[47] = data_in[47] ^ data_in[8] ^ data_in[119];
	 data_c[48] = data_in[48] ^ data_in[9] ^ data_in[120];
	 data_c[49] = data_in[49] ^ data_in[10] ^ data_in[121];
	 data_c[50] = data_in[50] ^ data_in[11] ^ data_in[122];
	 data_c[51] = data_in[51] ^ data_in[12] ^ data_in[123];
	 data_c[52] = data_in[52] ^ data_in[13] ^ data_in[124];
	 data_c[53] = data_in[53] ^ data_in[14] ^ data_in[125];
	 data_c[54] = data_in[54] ^ data_in[15] ^ data_in[126];
	 data_c[55] = data_in[55] ^ data_in[16] ^ data_in[127];
	 data_c[56] = data_in[56] ^ data_in[17] ^ data_in[128];
	 data_c[57] = data_in[57] ^ data_in[18] ^ data_in[129];
	 data_c[58] = data_in[58] ^ data_in[19] ^ data_in[130];
	 data_c[59] = data_in[59] ^ data_in[20] ^ data_in[131];
	 data_c[60] = data_in[60] ^ data_in[21] ^ data_in[2];
	 data_c[61] = data_in[61] ^ data_in[22] ^ data_in[3];
	 data_c[62] = data_in[62] ^ data_in[23] ^ data_in[4];
	 data_c[63] = data_in[63] ^ data_in[24] ^ data_in[5];
	 data_c[64] = data_in[64] ^ data_in[25] ^ data_in[6];
	 data_c[65] = data_in[65] ^ data_in[26] ^ data_in[7];	 


	 data_c[199:198] = data_in[199:198];
	 data_c[133:132] = data_in[133:132];	 
	 data_c[67:66] = data_in[67:66];
	 data_c[1:0] = data_in[1:0];
	 
  end // always

  always @(posedge clk, negedge rst) begin
    if(~rst) begin
      lfsr_q <= {58{1'b0}};
      data_out <= {264{1'b0}};
    end
    else begin
      lfsr_q <= descram_rst ? {58{1'b0}} : descram_en ? lfsr_c : lfsr_q;
      data_out <= descram_en ? data_c : data_out;
    end
  end // always

endmodule
