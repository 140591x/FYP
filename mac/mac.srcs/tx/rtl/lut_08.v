`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/03/2018 01:27:28 PM
// Design Name: 
// Module Name: lut_08
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


module lut_08(
    input [7:0] DATA_IN,
    output [31:0] CRC_VALUE
    );
    
    
    reg [31:0] rom[255:0];
    assign CRC_VALUE = rom[DATA_IN];
    
    initial
    begin
        rom[0] <= 32'h00000000;
        rom[1] <= 32'h5ba1dcca;
        rom[2] <= 32'hb743b994;
        rom[3] <= 32'hece2655e;
        rom[4] <= 32'h6a466e9f;
        rom[5] <= 32'h31e7b255;
        rom[6] <= 32'hdd05d70b;
        rom[7] <= 32'h86a40bc1;
        rom[8] <= 32'hd48cdd3e;
        rom[9] <= 32'h8f2d01f4;
        rom[10] <= 32'h63cf64aa;
        rom[11] <= 32'h386eb860;
        rom[12] <= 32'hbecab3a1;
        rom[13] <= 32'he56b6f6b;
        rom[14] <= 32'h09890a35;
        rom[15] <= 32'h5228d6ff;
        rom[16] <= 32'hadd8a7cb;
        rom[17] <= 32'hf6797b01;
        rom[18] <= 32'h1a9b1e5f;
        rom[19] <= 32'h413ac295;
        rom[20] <= 32'hc79ec954;
        rom[21] <= 32'h9c3f159e;
        rom[22] <= 32'h70dd70c0;
        rom[23] <= 32'h2b7cac0a;
        rom[24] <= 32'h79547af5;
        rom[25] <= 32'h22f5a63f;
        rom[26] <= 32'hce17c361;
        rom[27] <= 32'h95b61fab;
        rom[28] <= 32'h1312146a;
        rom[29] <= 32'h48b3c8a0;
        rom[30] <= 32'ha451adfe;
        rom[31] <= 32'hfff07134;
        rom[32] <= 32'h5f705221;
        rom[33] <= 32'h04d18eeb;
        rom[34] <= 32'he833ebb5;
        rom[35] <= 32'hb392377f;
        rom[36] <= 32'h35363cbe;
        rom[37] <= 32'h6e97e074;
        rom[38] <= 32'h8275852a;
        rom[39] <= 32'hd9d459e0;
        rom[40] <= 32'h8bfc8f1f;
        rom[41] <= 32'hd05d53d5;
        rom[42] <= 32'h3cbf368b;
        rom[43] <= 32'h671eea41;
        rom[44] <= 32'he1bae180;
        rom[45] <= 32'hba1b3d4a;
        rom[46] <= 32'h56f95814;
        rom[47] <= 32'h0d5884de;
        rom[48] <= 32'hf2a8f5ea;
        rom[49] <= 32'ha9092920;
        rom[50] <= 32'h45eb4c7e;
        rom[51] <= 32'h1e4a90b4;
        rom[52] <= 32'h98ee9b75;
        rom[53] <= 32'hc34f47bf;
        rom[54] <= 32'h2fad22e1;
        rom[55] <= 32'h740cfe2b;
        rom[56] <= 32'h262428d4;
        rom[57] <= 32'h7d85f41e;
        rom[58] <= 32'h91679140;
        rom[59] <= 32'hcac64d8a;
        rom[60] <= 32'h4c62464b;
        rom[61] <= 32'h17c39a81;
        rom[62] <= 32'hfb21ffdf;
        rom[63] <= 32'ha0802315;
        rom[64] <= 32'hbee0a442;
        rom[65] <= 32'he5417888;
        rom[66] <= 32'h09a31dd6;
        rom[67] <= 32'h5202c11c;
        rom[68] <= 32'hd4a6cadd;
        rom[69] <= 32'h8f071617;
        rom[70] <= 32'h63e57349;
        rom[71] <= 32'h3844af83;
        rom[72] <= 32'h6a6c797c;
        rom[73] <= 32'h31cda5b6;
        rom[74] <= 32'hdd2fc0e8;
        rom[75] <= 32'h868e1c22;
        rom[76] <= 32'h002a17e3;
        rom[77] <= 32'h5b8bcb29;
        rom[78] <= 32'hb769ae77;
        rom[79] <= 32'hecc872bd;
        rom[80] <= 32'h13380389;
        rom[81] <= 32'h4899df43;
        rom[82] <= 32'ha47bba1d;
        rom[83] <= 32'hffda66d7;
        rom[84] <= 32'h797e6d16;
        rom[85] <= 32'h22dfb1dc;
        rom[86] <= 32'hce3dd482;
        rom[87] <= 32'h959c0848;
        rom[88] <= 32'hc7b4deb7;
        rom[89] <= 32'h9c15027d;
        rom[90] <= 32'h70f76723;
        rom[91] <= 32'h2b56bbe9;
        rom[92] <= 32'hadf2b028;
        rom[93] <= 32'hf6536ce2;
        rom[94] <= 32'h1ab109bc;
        rom[95] <= 32'h4110d576;
        rom[96] <= 32'he190f663;
        rom[97] <= 32'hba312aa9;
        rom[98] <= 32'h56d34ff7;
        rom[99] <= 32'h0d72933d;
        rom[100] <= 32'h8bd698fc;
        rom[101] <= 32'hd0774436;
        rom[102] <= 32'h3c952168;
        rom[103] <= 32'h6734fda2;
        rom[104] <= 32'h351c2b5d;
        rom[105] <= 32'h6ebdf797;
        rom[106] <= 32'h825f92c9;
        rom[107] <= 32'hd9fe4e03;
        rom[108] <= 32'h5f5a45c2;
        rom[109] <= 32'h04fb9908;
        rom[110] <= 32'he819fc56;
        rom[111] <= 32'hb3b8209c;
        rom[112] <= 32'h4c4851a8;
        rom[113] <= 32'h17e98d62;
        rom[114] <= 32'hfb0be83c;
        rom[115] <= 32'ha0aa34f6;
        rom[116] <= 32'h260e3f37;
        rom[117] <= 32'h7dafe3fd;
        rom[118] <= 32'h914d86a3;
        rom[119] <= 32'hcaec5a69;
        rom[120] <= 32'h98c48c96;
        rom[121] <= 32'hc365505c;
        rom[122] <= 32'h2f873502;
        rom[123] <= 32'h7426e9c8;
        rom[124] <= 32'hf282e209;
        rom[125] <= 32'ha9233ec3;
        rom[126] <= 32'h45c15b9d;
        rom[127] <= 32'h1e608757;
        rom[128] <= 32'h79005533;
        rom[129] <= 32'h22a189f9;
        rom[130] <= 32'hce43eca7;
        rom[131] <= 32'h95e2306d;
        rom[132] <= 32'h13463bac;
        rom[133] <= 32'h48e7e766;
        rom[134] <= 32'ha4058238;
        rom[135] <= 32'hffa45ef2;
        rom[136] <= 32'had8c880d;
        rom[137] <= 32'hf62d54c7;
        rom[138] <= 32'h1acf3199;
        rom[139] <= 32'h416eed53;
        rom[140] <= 32'hc7cae692;
        rom[141] <= 32'h9c6b3a58;
        rom[142] <= 32'h70895f06;
        rom[143] <= 32'h2b2883cc;
        rom[144] <= 32'hd4d8f2f8;
        rom[145] <= 32'h8f792e32;
        rom[146] <= 32'h639b4b6c;
        rom[147] <= 32'h383a97a6;
        rom[148] <= 32'hbe9e9c67;
        rom[149] <= 32'he53f40ad;
        rom[150] <= 32'h09dd25f3;
        rom[151] <= 32'h527cf939;
        rom[152] <= 32'h00542fc6;
        rom[153] <= 32'h5bf5f30c;
        rom[154] <= 32'hb7179652;
        rom[155] <= 32'hecb64a98;
        rom[156] <= 32'h6a124159;
        rom[157] <= 32'h31b39d93;
        rom[158] <= 32'hdd51f8cd;
        rom[159] <= 32'h86f02407;
        rom[160] <= 32'h26700712;
        rom[161] <= 32'h7dd1dbd8;
        rom[162] <= 32'h9133be86;
        rom[163] <= 32'hca92624c;
        rom[164] <= 32'h4c36698d;
        rom[165] <= 32'h1797b547;
        rom[166] <= 32'hfb75d019;
        rom[167] <= 32'ha0d40cd3;
        rom[168] <= 32'hf2fcda2c;
        rom[169] <= 32'ha95d06e6;
        rom[170] <= 32'h45bf63b8;
        rom[171] <= 32'h1e1ebf72;
        rom[172] <= 32'h98bab4b3;
        rom[173] <= 32'hc31b6879;
        rom[174] <= 32'h2ff90d27;
        rom[175] <= 32'h7458d1ed;
        rom[176] <= 32'h8ba8a0d9;
        rom[177] <= 32'hd0097c13;
        rom[178] <= 32'h3ceb194d;
        rom[179] <= 32'h674ac587;
        rom[180] <= 32'he1eece46;
        rom[181] <= 32'hba4f128c;
        rom[182] <= 32'h56ad77d2;
        rom[183] <= 32'h0d0cab18;
        rom[184] <= 32'h5f247de7;
        rom[185] <= 32'h0485a12d;
        rom[186] <= 32'he867c473;
        rom[187] <= 32'hb3c618b9;
        rom[188] <= 32'h35621378;
        rom[189] <= 32'h6ec3cfb2;
        rom[190] <= 32'h8221aaec;
        rom[191] <= 32'hd9807626;
        rom[192] <= 32'hc7e0f171;
        rom[193] <= 32'h9c412dbb;
        rom[194] <= 32'h70a348e5;
        rom[195] <= 32'h2b02942f;
        rom[196] <= 32'hada69fee;
        rom[197] <= 32'hf6074324;
        rom[198] <= 32'h1ae5267a;
        rom[199] <= 32'h4144fab0;
        rom[200] <= 32'h136c2c4f;
        rom[201] <= 32'h48cdf085;
        rom[202] <= 32'ha42f95db;
        rom[203] <= 32'hff8e4911;
        rom[204] <= 32'h792a42d0;
        rom[205] <= 32'h228b9e1a;
        rom[206] <= 32'hce69fb44;
        rom[207] <= 32'h95c8278e;
        rom[208] <= 32'h6a3856ba;
        rom[209] <= 32'h31998a70;
        rom[210] <= 32'hdd7bef2e;
        rom[211] <= 32'h86da33e4;
        rom[212] <= 32'h007e3825;
        rom[213] <= 32'h5bdfe4ef;
        rom[214] <= 32'hb73d81b1;
        rom[215] <= 32'hec9c5d7b;
        rom[216] <= 32'hbeb48b84;
        rom[217] <= 32'he515574e;
        rom[218] <= 32'h09f73210;
        rom[219] <= 32'h5256eeda;
        rom[220] <= 32'hd4f2e51b;
        rom[221] <= 32'h8f5339d1;
        rom[222] <= 32'h63b15c8f;
        rom[223] <= 32'h38108045;
        rom[224] <= 32'h9890a350;
        rom[225] <= 32'hc3317f9a;
        rom[226] <= 32'h2fd31ac4;
        rom[227] <= 32'h7472c60e;
        rom[228] <= 32'hf2d6cdcf;
        rom[229] <= 32'ha9771105;
        rom[230] <= 32'h4595745b;
        rom[231] <= 32'h1e34a891;
        rom[232] <= 32'h4c1c7e6e;
        rom[233] <= 32'h17bda2a4;
        rom[234] <= 32'hfb5fc7fa;
        rom[235] <= 32'ha0fe1b30;
        rom[236] <= 32'h265a10f1;
        rom[237] <= 32'h7dfbcc3b;
        rom[238] <= 32'h9119a965;
        rom[239] <= 32'hcab875af;
        rom[240] <= 32'h3548049b;
        rom[241] <= 32'h6ee9d851;
        rom[242] <= 32'h820bbd0f;
        rom[243] <= 32'hd9aa61c5;
        rom[244] <= 32'h5f0e6a04;
        rom[245] <= 32'h04afb6ce;
        rom[246] <= 32'he84dd390;
        rom[247] <= 32'hb3ec0f5a;
        rom[248] <= 32'he1c4d9a5;
        rom[249] <= 32'hba65056f;
        rom[250] <= 32'h56876031;
        rom[251] <= 32'h0d26bcfb;
        rom[252] <= 32'h8b82b73a;
        rom[253] <= 32'hd0236bf0;
        rom[254] <= 32'h3cc10eae;
        rom[255] <= 32'h6760d264;
    end
    
endmodule
