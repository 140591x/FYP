`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/03/2018 11:41:23 AM
// Design Name: 
// Module Name: lut_01
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


module lut_01(
    input [7:0] DATA_IN,
    output [31:0] CRC_VALUE
    );
    
    reg [31:0] rom[255:0];
    assign CRC_VALUE = rom[DATA_IN];
    
    initial
    begin
        rom[0] <= 32'h00000000;
        rom[1] <= 32'h04c11db7;
        rom[2] <= 32'h09823b6e;
        rom[3] <= 32'h0d4326d9;
        rom[4] <= 32'h130476dc;
        rom[5] <= 32'h17c56b6b;
        rom[6] <= 32'h1a864db2;
        rom[7] <= 32'h1e475005;
        rom[8] <= 32'h2608edb8;
        rom[9] <= 32'h22c9f00f;
        rom[10] <= 32'h2f8ad6d6;
        rom[11] <= 32'h2b4bcb61;
        rom[12] <= 32'h350c9b64;
        rom[13] <= 32'h31cd86d3;
        rom[14] <= 32'h3c8ea00a;
        rom[15] <= 32'h384fbdbd;
        rom[16] <= 32'h4c11db70;
        rom[17] <= 32'h48d0c6c7;
        rom[18] <= 32'h4593e01e;
        rom[19] <= 32'h4152fda9;
        rom[20] <= 32'h5f15adac;
        rom[21] <= 32'h5bd4b01b;
        rom[22] <= 32'h569796c2;
        rom[23] <= 32'h52568b75;
        rom[24] <= 32'h6a1936c8;
        rom[25] <= 32'h6ed82b7f;
        rom[26] <= 32'h639b0da6;
        rom[27] <= 32'h675a1011;
        rom[28] <= 32'h791d4014;
        rom[29] <= 32'h7ddc5da3;
        rom[30] <= 32'h709f7b7a;
        rom[31] <= 32'h745e66cd;
        rom[32] <= 32'h9823b6e0;
        rom[33] <= 32'h9ce2ab57;
        rom[34] <= 32'h91a18d8e;
        rom[35] <= 32'h95609039;
        rom[36] <= 32'h8b27c03c;
        rom[37] <= 32'h8fe6dd8b;
        rom[38] <= 32'h82a5fb52;
        rom[39] <= 32'h8664e6e5;
        rom[40] <= 32'hbe2b5b58;
        rom[41] <= 32'hbaea46ef;
        rom[42] <= 32'hb7a96036;
        rom[43] <= 32'hb3687d81;
        rom[44] <= 32'had2f2d84;
        rom[45] <= 32'ha9ee3033;
        rom[46] <= 32'ha4ad16ea;
        rom[47] <= 32'ha06c0b5d;
        rom[48] <= 32'hd4326d90;
        rom[49] <= 32'hd0f37027;
        rom[50] <= 32'hddb056fe;
        rom[51] <= 32'hd9714b49;
        rom[52] <= 32'hc7361b4c;
        rom[53] <= 32'hc3f706fb;
        rom[54] <= 32'hceb42022;
        rom[55] <= 32'hca753d95;
        rom[56] <= 32'hf23a8028;
        rom[57] <= 32'hf6fb9d9f;
        rom[58] <= 32'hfbb8bb46;
        rom[59] <= 32'hff79a6f1;
        rom[60] <= 32'he13ef6f4;
        rom[61] <= 32'he5ffeb43;
        rom[62] <= 32'he8bccd9a;
        rom[63] <= 32'hec7dd02d;
        rom[64] <= 32'h34867077;
        rom[65] <= 32'h30476dc0;
        rom[66] <= 32'h3d044b19;
        rom[67] <= 32'h39c556ae;
        rom[68] <= 32'h278206ab;
        rom[69] <= 32'h23431b1c;
        rom[70] <= 32'h2e003dc5;
        rom[71] <= 32'h2ac12072;
        rom[72] <= 32'h128e9dcf;
        rom[73] <= 32'h164f8078;
        rom[74] <= 32'h1b0ca6a1;
        rom[75] <= 32'h1fcdbb16;
        rom[76] <= 32'h018aeb13;
        rom[77] <= 32'h054bf6a4;
        rom[78] <= 32'h0808d07d;
        rom[79] <= 32'h0cc9cdca;
        rom[80] <= 32'h7897ab07;
        rom[81] <= 32'h7c56b6b0;
        rom[82] <= 32'h71159069;
        rom[83] <= 32'h75d48dde;
        rom[84] <= 32'h6b93dddb;
        rom[85] <= 32'h6f52c06c;
        rom[86] <= 32'h6211e6b5;
        rom[87] <= 32'h66d0fb02;
        rom[88] <= 32'h5e9f46bf;
        rom[89] <= 32'h5a5e5b08;
        rom[90] <= 32'h571d7dd1;
        rom[91] <= 32'h53dc6066;
        rom[92] <= 32'h4d9b3063;
        rom[93] <= 32'h495a2dd4;
        rom[94] <= 32'h44190b0d;
        rom[95] <= 32'h40d816ba;
        rom[96] <= 32'haca5c697;
        rom[97] <= 32'ha864db20;
        rom[98] <= 32'ha527fdf9;
        rom[99] <= 32'ha1e6e04e;
        rom[100] <= 32'hbfa1b04b;
        rom[101] <= 32'hbb60adfc;
        rom[102] <= 32'hb6238b25;
        rom[103] <= 32'hb2e29692;
        rom[104] <= 32'h8aad2b2f;
        rom[105] <= 32'h8e6c3698;
        rom[106] <= 32'h832f1041;
        rom[107] <= 32'h87ee0df6;
        rom[108] <= 32'h99a95df3;
        rom[109] <= 32'h9d684044;
        rom[110] <= 32'h902b669d;
        rom[111] <= 32'h94ea7b2a;
        rom[112] <= 32'he0b41de7;
        rom[113] <= 32'he4750050;
        rom[114] <= 32'he9362689;
        rom[115] <= 32'hedf73b3e;
        rom[116] <= 32'hf3b06b3b;
        rom[117] <= 32'hf771768c;
        rom[118] <= 32'hfa325055;
        rom[119] <= 32'hfef34de2;
        rom[120] <= 32'hc6bcf05f;
        rom[121] <= 32'hc27dede8;
        rom[122] <= 32'hcf3ecb31;
        rom[123] <= 32'hcbffd686;
        rom[124] <= 32'hd5b88683;
        rom[125] <= 32'hd1799b34;
        rom[126] <= 32'hdc3abded;
        rom[127] <= 32'hd8fba05a;
        rom[128] <= 32'h690ce0ee;
        rom[129] <= 32'h6dcdfd59;
        rom[130] <= 32'h608edb80;
        rom[131] <= 32'h644fc637;
        rom[132] <= 32'h7a089632;
        rom[133] <= 32'h7ec98b85;
        rom[134] <= 32'h738aad5c;
        rom[135] <= 32'h774bb0eb;
        rom[136] <= 32'h4f040d56;
        rom[137] <= 32'h4bc510e1;
        rom[138] <= 32'h46863638;
        rom[139] <= 32'h42472b8f;
        rom[140] <= 32'h5c007b8a;
        rom[141] <= 32'h58c1663d;
        rom[142] <= 32'h558240e4;
        rom[143] <= 32'h51435d53;
        rom[144] <= 32'h251d3b9e;
        rom[145] <= 32'h21dc2629;
        rom[146] <= 32'h2c9f00f0;
        rom[147] <= 32'h285e1d47;
        rom[148] <= 32'h36194d42;
        rom[149] <= 32'h32d850f5;
        rom[150] <= 32'h3f9b762c;
        rom[151] <= 32'h3b5a6b9b;
        rom[152] <= 32'h0315d626;
        rom[153] <= 32'h07d4cb91;
        rom[154] <= 32'h0a97ed48;
        rom[155] <= 32'h0e56f0ff;
        rom[156] <= 32'h1011a0fa;
        rom[157] <= 32'h14d0bd4d;
        rom[158] <= 32'h19939b94;
        rom[159] <= 32'h1d528623;
        rom[160] <= 32'hf12f560e;
        rom[161] <= 32'hf5ee4bb9;
        rom[162] <= 32'hf8ad6d60;
        rom[163] <= 32'hfc6c70d7;
        rom[164] <= 32'he22b20d2;
        rom[165] <= 32'he6ea3d65;
        rom[166] <= 32'heba91bbc;
        rom[167] <= 32'hef68060b;
        rom[168] <= 32'hd727bbb6;
        rom[169] <= 32'hd3e6a601;
        rom[170] <= 32'hdea580d8;
        rom[171] <= 32'hda649d6f;
        rom[172] <= 32'hc423cd6a;
        rom[173] <= 32'hc0e2d0dd;
        rom[174] <= 32'hcda1f604;
        rom[175] <= 32'hc960ebb3;
        rom[176] <= 32'hbd3e8d7e;
        rom[177] <= 32'hb9ff90c9;
        rom[178] <= 32'hb4bcb610;
        rom[179] <= 32'hb07daba7;
        rom[180] <= 32'hae3afba2;
        rom[181] <= 32'haafbe615;
        rom[182] <= 32'ha7b8c0cc;
        rom[183] <= 32'ha379dd7b;
        rom[184] <= 32'h9b3660c6;
        rom[185] <= 32'h9ff77d71;
        rom[186] <= 32'h92b45ba8;
        rom[187] <= 32'h9675461f;
        rom[188] <= 32'h8832161a;
        rom[189] <= 32'h8cf30bad;
        rom[190] <= 32'h81b02d74;
        rom[191] <= 32'h857130c3;
        rom[192] <= 32'h5d8a9099;
        rom[193] <= 32'h594b8d2e;
        rom[194] <= 32'h5408abf7;
        rom[195] <= 32'h50c9b640;
        rom[196] <= 32'h4e8ee645;
        rom[197] <= 32'h4a4ffbf2;
        rom[198] <= 32'h470cdd2b;
        rom[199] <= 32'h43cdc09c;
        rom[200] <= 32'h7b827d21;
        rom[201] <= 32'h7f436096;
        rom[202] <= 32'h7200464f;
        rom[203] <= 32'h76c15bf8;
        rom[204] <= 32'h68860bfd;
        rom[205] <= 32'h6c47164a;
        rom[206] <= 32'h61043093;
        rom[207] <= 32'h65c52d24;
        rom[208] <= 32'h119b4be9;
        rom[209] <= 32'h155a565e;
        rom[210] <= 32'h18197087;
        rom[211] <= 32'h1cd86d30;
        rom[212] <= 32'h029f3d35;
        rom[213] <= 32'h065e2082;
        rom[214] <= 32'h0b1d065b;
        rom[215] <= 32'h0fdc1bec;
        rom[216] <= 32'h3793a651;
        rom[217] <= 32'h3352bbe6;
        rom[218] <= 32'h3e119d3f;
        rom[219] <= 32'h3ad08088;
        rom[220] <= 32'h2497d08d;
        rom[221] <= 32'h2056cd3a;
        rom[222] <= 32'h2d15ebe3;
        rom[223] <= 32'h29d4f654;
        rom[224] <= 32'hc5a92679;
        rom[225] <= 32'hc1683bce;
        rom[226] <= 32'hcc2b1d17;
        rom[227] <= 32'hc8ea00a0;
        rom[228] <= 32'hd6ad50a5;
        rom[229] <= 32'hd26c4d12;
        rom[230] <= 32'hdf2f6bcb;
        rom[231] <= 32'hdbee767c;
        rom[232] <= 32'he3a1cbc1;
        rom[233] <= 32'he760d676;
        rom[234] <= 32'hea23f0af;
        rom[235] <= 32'heee2ed18;
        rom[236] <= 32'hf0a5bd1d;
        rom[237] <= 32'hf464a0aa;
        rom[238] <= 32'hf9278673;
        rom[239] <= 32'hfde69bc4;
        rom[240] <= 32'h89b8fd09;
        rom[241] <= 32'h8d79e0be;
        rom[242] <= 32'h803ac667;
        rom[243] <= 32'h84fbdbd0;
        rom[244] <= 32'h9abc8bd5;
        rom[245] <= 32'h9e7d9662;
        rom[246] <= 32'h933eb0bb;
        rom[247] <= 32'h97ffad0c;
        rom[248] <= 32'hafb010b1;
        rom[249] <= 32'hab710d06;
        rom[250] <= 32'ha6322bdf;
        rom[251] <= 32'ha2f33668;
        rom[252] <= 32'hbcb4666d;
        rom[253] <= 32'hb8757bda;
        rom[254] <= 32'hb5365d03;
        rom[255] <= 32'hb1f740b4;
    end
    
endmodule
