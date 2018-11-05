`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/03/2018 01:27:28 PM
// Design Name: 
// Module Name: lut_02
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


module lut_02(
    input [7:0] DATA_IN,
    output [31:0] CRC_VALUE
    );
    
    
    reg [31:0] rom[255:0];
    assign CRC_VALUE = rom[DATA_IN];
    
    initial 
    begin
        rom[0] <= 32'h00000000;
        rom[1] <= 32'hd219c1dc;
        rom[2] <= 32'ha0f29e0f;
        rom[3] <= 32'h72eb5fd3;
        rom[4] <= 32'h452421a9;
        rom[5] <= 32'h973de075;
        rom[6] <= 32'he5d6bfa6;
        rom[7] <= 32'h37cf7e7a;
        rom[8] <= 32'h8a484352;
        rom[9] <= 32'h5851828e;
        rom[10] <= 32'h2abadd5d;
        rom[11] <= 32'hf8a31c81;
        rom[12] <= 32'hcf6c62fb;
        rom[13] <= 32'h1d75a327;
        rom[14] <= 32'h6f9efcf4;
        rom[15] <= 32'hbd873d28;
        rom[16] <= 32'h10519b13;
        rom[17] <= 32'hc2485acf;
        rom[18] <= 32'hb0a3051c;
        rom[19] <= 32'h62bac4c0;
        rom[20] <= 32'h5575baba;
        rom[21] <= 32'h876c7b66;
        rom[22] <= 32'hf58724b5;
        rom[23] <= 32'h279ee569;
        rom[24] <= 32'h9a19d841;
        rom[25] <= 32'h4800199d;
        rom[26] <= 32'h3aeb464e;
        rom[27] <= 32'he8f28792;
        rom[28] <= 32'hdf3df9e8;
        rom[29] <= 32'h0d243834;
        rom[30] <= 32'h7fcf67e7;
        rom[31] <= 32'hadd6a63b;
        rom[32] <= 32'h20a33626;
        rom[33] <= 32'hf2baf7fa;
        rom[34] <= 32'h8051a829;
        rom[35] <= 32'h524869f5;
        rom[36] <= 32'h6587178f;
        rom[37] <= 32'hb79ed653;
        rom[38] <= 32'hc5758980;
        rom[39] <= 32'h176c485c;
        rom[40] <= 32'haaeb7574;
        rom[41] <= 32'h78f2b4a8;
        rom[42] <= 32'h0a19eb7b;
        rom[43] <= 32'hd8002aa7;
        rom[44] <= 32'hefcf54dd;
        rom[45] <= 32'h3dd69501;
        rom[46] <= 32'h4f3dcad2;
        rom[47] <= 32'h9d240b0e;
        rom[48] <= 32'h30f2ad35;
        rom[49] <= 32'he2eb6ce9;
        rom[50] <= 32'h9000333a;
        rom[51] <= 32'h4219f2e6;
        rom[52] <= 32'h75d68c9c;
        rom[53] <= 32'ha7cf4d40;
        rom[54] <= 32'hd5241293;
        rom[55] <= 32'h073dd34f;
        rom[56] <= 32'hbabaee67;
        rom[57] <= 32'h68a32fbb;
        rom[58] <= 32'h1a487068;
        rom[59] <= 32'hc851b1b4;
        rom[60] <= 32'hff9ecfce;
        rom[61] <= 32'h2d870e12;
        rom[62] <= 32'h5f6c51c1;
        rom[63] <= 32'h8d75901d;
        rom[64] <= 32'h41466c4c;
        rom[65] <= 32'h935fad90;
        rom[66] <= 32'he1b4f243;
        rom[67] <= 32'h33ad339f;
        rom[68] <= 32'h04624de5;
        rom[69] <= 32'hd67b8c39;
        rom[70] <= 32'ha490d3ea;
        rom[71] <= 32'h76891236;
        rom[72] <= 32'hcb0e2f1e;
        rom[73] <= 32'h1917eec2;
        rom[74] <= 32'h6bfcb111;
        rom[75] <= 32'hb9e570cd;
        rom[76] <= 32'h8e2a0eb7;
        rom[77] <= 32'h5c33cf6b;
        rom[78] <= 32'h2ed890b8;
        rom[79] <= 32'hfcc15164;
        rom[80] <= 32'h5117f75f;
        rom[81] <= 32'h830e3683;
        rom[82] <= 32'hf1e56950;
        rom[83] <= 32'h23fca88c;
        rom[84] <= 32'h1433d6f6;
        rom[85] <= 32'hc62a172a;
        rom[86] <= 32'hb4c148f9;
        rom[87] <= 32'h66d88925;
        rom[88] <= 32'hdb5fb40d;
        rom[89] <= 32'h094675d1;
        rom[90] <= 32'h7bad2a02;
        rom[91] <= 32'ha9b4ebde;
        rom[92] <= 32'h9e7b95a4;
        rom[93] <= 32'h4c625478;
        rom[94] <= 32'h3e890bab;
        rom[95] <= 32'hec90ca77;
        rom[96] <= 32'h61e55a6a;
        rom[97] <= 32'hb3fc9bb6;
        rom[98] <= 32'hc117c465;
        rom[99] <= 32'h130e05b9;
        rom[100] <= 32'h24c17bc3;
        rom[101] <= 32'hf6d8ba1f;
        rom[102] <= 32'h8433e5cc;
        rom[103] <= 32'h562a2410;
        rom[104] <= 32'hebad1938;
        rom[105] <= 32'h39b4d8e4;
        rom[106] <= 32'h4b5f8737;
        rom[107] <= 32'h994646eb;
        rom[108] <= 32'hae893891;
        rom[109] <= 32'h7c90f94d;
        rom[110] <= 32'h0e7ba69e;
        rom[111] <= 32'hdc626742;
        rom[112] <= 32'h71b4c179;
        rom[113] <= 32'ha3ad00a5;
        rom[114] <= 32'hd1465f76;
        rom[115] <= 32'h035f9eaa;
        rom[116] <= 32'h3490e0d0;
        rom[117] <= 32'he689210c;
        rom[118] <= 32'h94627edf;
        rom[119] <= 32'h467bbf03;
        rom[120] <= 32'hfbfc822b;
        rom[121] <= 32'h29e543f7;
        rom[122] <= 32'h5b0e1c24;
        rom[123] <= 32'h8917ddf8;
        rom[124] <= 32'hbed8a382;
        rom[125] <= 32'h6cc1625e;
        rom[126] <= 32'h1e2a3d8d;
        rom[127] <= 32'hcc33fc51;
        rom[128] <= 32'h828cd898;
        rom[129] <= 32'h50951944;
        rom[130] <= 32'h227e4697;
        rom[131] <= 32'hf067874b;
        rom[132] <= 32'hc7a8f931;
        rom[133] <= 32'h15b138ed;
        rom[134] <= 32'h675a673e;
        rom[135] <= 32'hb543a6e2;
        rom[136] <= 32'h08c49bca;
        rom[137] <= 32'hdadd5a16;
        rom[138] <= 32'ha83605c5;
        rom[139] <= 32'h7a2fc419;
        rom[140] <= 32'h4de0ba63;
        rom[141] <= 32'h9ff97bbf;
        rom[142] <= 32'hed12246c;
        rom[143] <= 32'h3f0be5b0;
        rom[144] <= 32'h92dd438b;
        rom[145] <= 32'h40c48257;
        rom[146] <= 32'h322fdd84;
        rom[147] <= 32'he0361c58;
        rom[148] <= 32'hd7f96222;
        rom[149] <= 32'h05e0a3fe;
        rom[150] <= 32'h770bfc2d;
        rom[151] <= 32'ha5123df1;
        rom[152] <= 32'h189500d9;
        rom[153] <= 32'hca8cc105;
        rom[154] <= 32'hb8679ed6;
        rom[155] <= 32'h6a7e5f0a;
        rom[156] <= 32'h5db12170;
        rom[157] <= 32'h8fa8e0ac;
        rom[158] <= 32'hfd43bf7f;
        rom[159] <= 32'h2f5a7ea3;
        rom[160] <= 32'ha22feebe;
        rom[161] <= 32'h70362f62;
        rom[162] <= 32'h02dd70b1;
        rom[163] <= 32'hd0c4b16d;
        rom[164] <= 32'he70bcf17;
        rom[165] <= 32'h35120ecb;
        rom[166] <= 32'h47f95118;
        rom[167] <= 32'h95e090c4;
        rom[168] <= 32'h2867adec;
        rom[169] <= 32'hfa7e6c30;
        rom[170] <= 32'h889533e3;
        rom[171] <= 32'h5a8cf23f;
        rom[172] <= 32'h6d438c45;
        rom[173] <= 32'hbf5a4d99;
        rom[174] <= 32'hcdb1124a;
        rom[175] <= 32'h1fa8d396;
        rom[176] <= 32'hb27e75ad;
        rom[177] <= 32'h6067b471;
        rom[178] <= 32'h128ceba2;
        rom[179] <= 32'hc0952a7e;
        rom[180] <= 32'hf75a5404;
        rom[181] <= 32'h254395d8;
        rom[182] <= 32'h57a8ca0b;
        rom[183] <= 32'h85b10bd7;
        rom[184] <= 32'h383636ff;
        rom[185] <= 32'hea2ff723;
        rom[186] <= 32'h98c4a8f0;
        rom[187] <= 32'h4add692c;
        rom[188] <= 32'h7d121756;
        rom[189] <= 32'haf0bd68a;
        rom[190] <= 32'hdde08959;
        rom[191] <= 32'h0ff94885;
        rom[192] <= 32'hc3cab4d4;
        rom[193] <= 32'h11d37508;
        rom[194] <= 32'h63382adb;
        rom[195] <= 32'hb121eb07;
        rom[196] <= 32'h86ee957d;
        rom[197] <= 32'h54f754a1;
        rom[198] <= 32'h261c0b72;
        rom[199] <= 32'hf405caae;
        rom[200] <= 32'h4982f786;
        rom[201] <= 32'h9b9b365a;
        rom[202] <= 32'he9706989;
        rom[203] <= 32'h3b69a855;
        rom[204] <= 32'h0ca6d62f;
        rom[205] <= 32'hdebf17f3;
        rom[206] <= 32'hac544820;
        rom[207] <= 32'h7e4d89fc;
        rom[208] <= 32'hd39b2fc7;
        rom[209] <= 32'h0182ee1b;
        rom[210] <= 32'h7369b1c8;
        rom[211] <= 32'ha1707014;
        rom[212] <= 32'h96bf0e6e;
        rom[213] <= 32'h44a6cfb2;
        rom[214] <= 32'h364d9061;
        rom[215] <= 32'he45451bd;
        rom[216] <= 32'h59d36c95;
        rom[217] <= 32'h8bcaad49;
        rom[218] <= 32'hf921f29a;
        rom[219] <= 32'h2b383346;
        rom[220] <= 32'h1cf74d3c;
        rom[221] <= 32'hceee8ce0;
        rom[222] <= 32'hbc05d333;
        rom[223] <= 32'h6e1c12ef;
        rom[224] <= 32'he36982f2;
        rom[225] <= 32'h3170432e;
        rom[226] <= 32'h439b1cfd;
        rom[227] <= 32'h9182dd21;
        rom[228] <= 32'ha64da35b;
        rom[229] <= 32'h74546287;
        rom[230] <= 32'h06bf3d54;
        rom[231] <= 32'hd4a6fc88;
        rom[232] <= 32'h6921c1a0;
        rom[233] <= 32'hbb38007c;
        rom[234] <= 32'hc9d35faf;
        rom[235] <= 32'h1bca9e73;
        rom[236] <= 32'h2c05e009;
        rom[237] <= 32'hfe1c21d5;
        rom[238] <= 32'h8cf77e06;
        rom[239] <= 32'h5eeebfda;
        rom[240] <= 32'hf33819e1;
        rom[241] <= 32'h2121d83d;
        rom[242] <= 32'h53ca87ee;
        rom[243] <= 32'h81d34632;
        rom[244] <= 32'hb61c3848;
        rom[245] <= 32'h6405f994;
        rom[246] <= 32'h16eea647;
        rom[247] <= 32'hc4f7679b;
        rom[248] <= 32'h79705ab3;
        rom[249] <= 32'hab699b6f;
        rom[250] <= 32'hd982c4bc;
        rom[251] <= 32'h0b9b0560;
        rom[252] <= 32'h3c547b1a;
        rom[253] <= 32'hee4dbac6;
        rom[254] <= 32'h9ca6e515;
        rom[255] <= 32'h4ebf24c9;

    end
    
endmodule
