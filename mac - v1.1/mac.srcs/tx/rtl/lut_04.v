`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/03/2018 01:27:28 PM
// Design Name: 
// Module Name: lut_04
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


module lut_04(
    input [7:0] DATA_IN,
    output [31:0] CRC_VALUE
    );
    
    
    reg [31:0] rom[255:0];
    assign CRC_VALUE = rom[DATA_IN];
    
    initial
    begin
        rom[0] <= 32'h00000000;
        rom[1] <= 32'hdc6d9ab7;
        rom[2] <= 32'hbc1a28d9;
        rom[3] <= 32'h6077b26e;
        rom[4] <= 32'h7cf54c05;
        rom[5] <= 32'ha098d6b2;
        rom[6] <= 32'hc0ef64dc;
        rom[7] <= 32'h1c82fe6b;
        rom[8] <= 32'hf9ea980a;
        rom[9] <= 32'h258702bd;
        rom[10] <= 32'h45f0b0d3;
        rom[11] <= 32'h999d2a64;
        rom[12] <= 32'h851fd40f;
        rom[13] <= 32'h59724eb8;
        rom[14] <= 32'h3905fcd6;
        rom[15] <= 32'he5686661;
        rom[16] <= 32'hf7142da3;
        rom[17] <= 32'h2b79b714;
        rom[18] <= 32'h4b0e057a;
        rom[19] <= 32'h97639fcd;
        rom[20] <= 32'h8be161a6;
        rom[21] <= 32'h578cfb11;
        rom[22] <= 32'h37fb497f;
        rom[23] <= 32'heb96d3c8;
        rom[24] <= 32'h0efeb5a9;
        rom[25] <= 32'hd2932f1e;
        rom[26] <= 32'hb2e49d70;
        rom[27] <= 32'h6e8907c7;
        rom[28] <= 32'h720bf9ac;
        rom[29] <= 32'hae66631b;
        rom[30] <= 32'hce11d175;
        rom[31] <= 32'h127c4bc2;
        rom[32] <= 32'heae946f1;
        rom[33] <= 32'h3684dc46;
        rom[34] <= 32'h56f36e28;
        rom[35] <= 32'h8a9ef49f;
        rom[36] <= 32'h961c0af4;
        rom[37] <= 32'h4a719043;
        rom[38] <= 32'h2a06222d;
        rom[39] <= 32'hf66bb89a;
        rom[40] <= 32'h1303defb;
        rom[41] <= 32'hcf6e444c;
        rom[42] <= 32'haf19f622;
        rom[43] <= 32'h73746c95;
        rom[44] <= 32'h6ff692fe;
        rom[45] <= 32'hb39b0849;
        rom[46] <= 32'hd3ecba27;
        rom[47] <= 32'h0f812090;
        rom[48] <= 32'h1dfd6b52;
        rom[49] <= 32'hc190f1e5;
        rom[50] <= 32'ha1e7438b;
        rom[51] <= 32'h7d8ad93c;
        rom[52] <= 32'h61082757;
        rom[53] <= 32'hbd65bde0;
        rom[54] <= 32'hdd120f8e;
        rom[55] <= 32'h017f9539;
        rom[56] <= 32'he417f358;
        rom[57] <= 32'h387a69ef;
        rom[58] <= 32'h580ddb81;
        rom[59] <= 32'h84604136;
        rom[60] <= 32'h98e2bf5d;
        rom[61] <= 32'h448f25ea;
        rom[62] <= 32'h24f89784;
        rom[63] <= 32'hf8950d33;
        rom[64] <= 32'hd1139055;
        rom[65] <= 32'h0d7e0ae2;
        rom[66] <= 32'h6d09b88c;
        rom[67] <= 32'hb164223b;
        rom[68] <= 32'hade6dc50;
        rom[69] <= 32'h718b46e7;
        rom[70] <= 32'h11fcf489;
        rom[71] <= 32'hcd916e3e;
        rom[72] <= 32'h28f9085f;
        rom[73] <= 32'hf49492e8;
        rom[74] <= 32'h94e32086;
        rom[75] <= 32'h488eba31;
        rom[76] <= 32'h540c445a;
        rom[77] <= 32'h8861deed;
        rom[78] <= 32'he8166c83;
        rom[79] <= 32'h347bf634;
        rom[80] <= 32'h2607bdf6;
        rom[81] <= 32'hfa6a2741;
        rom[82] <= 32'h9a1d952f;
        rom[83] <= 32'h46700f98;
        rom[84] <= 32'h5af2f1f3;
        rom[85] <= 32'h869f6b44;
        rom[86] <= 32'he6e8d92a;
        rom[87] <= 32'h3a85439d;
        rom[88] <= 32'hdfed25fc;
        rom[89] <= 32'h0380bf4b;
        rom[90] <= 32'h63f70d25;
        rom[91] <= 32'hbf9a9792;
        rom[92] <= 32'ha31869f9;
        rom[93] <= 32'h7f75f34e;
        rom[94] <= 32'h1f024120;
        rom[95] <= 32'hc36fdb97;
        rom[96] <= 32'h3bfad6a4;
        rom[97] <= 32'he7974c13;
        rom[98] <= 32'h87e0fe7d;
        rom[99] <= 32'h5b8d64ca;
        rom[100] <= 32'h470f9aa1;
        rom[101] <= 32'h9b620016;
        rom[102] <= 32'hfb15b278;
        rom[103] <= 32'h277828cf;
        rom[104] <= 32'hc2104eae;
        rom[105] <= 32'h1e7dd419;
        rom[106] <= 32'h7e0a6677;
        rom[107] <= 32'ha267fcc0;
        rom[108] <= 32'hbee502ab;
        rom[109] <= 32'h6288981c;
        rom[110] <= 32'h02ff2a72;
        rom[111] <= 32'hde92b0c5;
        rom[112] <= 32'hcceefb07;
        rom[113] <= 32'h108361b0;
        rom[114] <= 32'h70f4d3de;
        rom[115] <= 32'hac994969;
        rom[116] <= 32'hb01bb702;
        rom[117] <= 32'h6c762db5;
        rom[118] <= 32'h0c019fdb;
        rom[119] <= 32'hd06c056c;
        rom[120] <= 32'h3504630d;
        rom[121] <= 32'he969f9ba;
        rom[122] <= 32'h891e4bd4;
        rom[123] <= 32'h5573d163;
        rom[124] <= 32'h49f12f08;
        rom[125] <= 32'h959cb5bf;
        rom[126] <= 32'hf5eb07d1;
        rom[127] <= 32'h29869d66;
        rom[128] <= 32'ha6e63d1d;
        rom[129] <= 32'h7a8ba7aa;
        rom[130] <= 32'h1afc15c4;
        rom[131] <= 32'hc6918f73;
        rom[132] <= 32'hda137118;
        rom[133] <= 32'h067eebaf;
        rom[134] <= 32'h660959c1;
        rom[135] <= 32'hba64c376;
        rom[136] <= 32'h5f0ca517;
        rom[137] <= 32'h83613fa0;
        rom[138] <= 32'he3168dce;
        rom[139] <= 32'h3f7b1779;
        rom[140] <= 32'h23f9e912;
        rom[141] <= 32'hff9473a5;
        rom[142] <= 32'h9fe3c1cb;
        rom[143] <= 32'h438e5b7c;
        rom[144] <= 32'h51f210be;
        rom[145] <= 32'h8d9f8a09;
        rom[146] <= 32'hede83867;
        rom[147] <= 32'h3185a2d0;
        rom[148] <= 32'h2d075cbb;
        rom[149] <= 32'hf16ac60c;
        rom[150] <= 32'h911d7462;
        rom[151] <= 32'h4d70eed5;
        rom[152] <= 32'ha81888b4;
        rom[153] <= 32'h74751203;
        rom[154] <= 32'h1402a06d;
        rom[155] <= 32'hc86f3ada;
        rom[156] <= 32'hd4edc4b1;
        rom[157] <= 32'h08805e06;
        rom[158] <= 32'h68f7ec68;
        rom[159] <= 32'hb49a76df;
        rom[160] <= 32'h4c0f7bec;
        rom[161] <= 32'h9062e15b;
        rom[162] <= 32'hf0155335;
        rom[163] <= 32'h2c78c982;
        rom[164] <= 32'h30fa37e9;
        rom[165] <= 32'hec97ad5e;
        rom[166] <= 32'h8ce01f30;
        rom[167] <= 32'h508d8587;
        rom[168] <= 32'hb5e5e3e6;
        rom[169] <= 32'h69887951;
        rom[170] <= 32'h09ffcb3f;
        rom[171] <= 32'hd5925188;
        rom[172] <= 32'hc910afe3;
        rom[173] <= 32'h157d3554;
        rom[174] <= 32'h750a873a;
        rom[175] <= 32'ha9671d8d;
        rom[176] <= 32'hbb1b564f;
        rom[177] <= 32'h6776ccf8;
        rom[178] <= 32'h07017e96;
        rom[179] <= 32'hdb6ce421;
        rom[180] <= 32'hc7ee1a4a;
        rom[181] <= 32'h1b8380fd;
        rom[182] <= 32'h7bf43293;
        rom[183] <= 32'ha799a824;
        rom[184] <= 32'h42f1ce45;
        rom[185] <= 32'h9e9c54f2;
        rom[186] <= 32'hfeebe69c;
        rom[187] <= 32'h22867c2b;
        rom[188] <= 32'h3e048240;
        rom[189] <= 32'he26918f7;
        rom[190] <= 32'h821eaa99;
        rom[191] <= 32'h5e73302e;
        rom[192] <= 32'h77f5ad48;
        rom[193] <= 32'hab9837ff;
        rom[194] <= 32'hcbef8591;
        rom[195] <= 32'h17821f26;
        rom[196] <= 32'h0b00e14d;
        rom[197] <= 32'hd76d7bfa;
        rom[198] <= 32'hb71ac994;
        rom[199] <= 32'h6b775323;
        rom[200] <= 32'h8e1f3542;
        rom[201] <= 32'h5272aff5;
        rom[202] <= 32'h32051d9b;
        rom[203] <= 32'hee68872c;
        rom[204] <= 32'hf2ea7947;
        rom[205] <= 32'h2e87e3f0;
        rom[206] <= 32'h4ef0519e;
        rom[207] <= 32'h929dcb29;
        rom[208] <= 32'h80e180eb;
        rom[209] <= 32'h5c8c1a5c;
        rom[210] <= 32'h3cfba832;
        rom[211] <= 32'he0963285;
        rom[212] <= 32'hfc14ccee;
        rom[213] <= 32'h20795659;
        rom[214] <= 32'h400ee437;
        rom[215] <= 32'h9c637e80;
        rom[216] <= 32'h790b18e1;
        rom[217] <= 32'ha5668256;
        rom[218] <= 32'hc5113038;
        rom[219] <= 32'h197caa8f;
        rom[220] <= 32'h05fe54e4;
        rom[221] <= 32'hd993ce53;
        rom[222] <= 32'hb9e47c3d;
        rom[223] <= 32'h6589e68a;
        rom[224] <= 32'h9d1cebb9;
        rom[225] <= 32'h4171710e;
        rom[226] <= 32'h2106c360;
        rom[227] <= 32'hfd6b59d7;
        rom[228] <= 32'he1e9a7bc;
        rom[229] <= 32'h3d843d0b;
        rom[230] <= 32'h5df38f65;
        rom[231] <= 32'h819e15d2;
        rom[232] <= 32'h64f673b3;
        rom[233] <= 32'hb89be904;
        rom[234] <= 32'hd8ec5b6a;
        rom[235] <= 32'h0481c1dd;
        rom[236] <= 32'h18033fb6;
        rom[237] <= 32'hc46ea501;
        rom[238] <= 32'ha419176f;
        rom[239] <= 32'h78748dd8;
        rom[240] <= 32'h6a08c61a;
        rom[241] <= 32'hb6655cad;
        rom[242] <= 32'hd612eec3;
        rom[243] <= 32'h0a7f7474;
        rom[244] <= 32'h16fd8a1f;
        rom[245] <= 32'hca9010a8;
        rom[246] <= 32'haae7a2c6;
        rom[247] <= 32'h768a3871;
        rom[248] <= 32'h93e25e10;
        rom[249] <= 32'h4f8fc4a7;
        rom[250] <= 32'h2ff876c9;
        rom[251] <= 32'hf395ec7e;
        rom[252] <= 32'hef171215;
        rom[253] <= 32'h337a88a2;
        rom[254] <= 32'h530d3acc;
        rom[255] <= 32'h8f60a07b;
    end
    
    
endmodule
