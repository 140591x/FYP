`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: University of Moratuwa, Sri Lanka.
// Engineer: S.D.S.Madusanka
// 
// Create Date: 05/02/2018 05:06:08 PM
// Design Name: Frame Chack Sequence Generator
// Module Name: CRC32
// Project Name: 40G Ethernet 
// Target Devices: VIRTEX-7 VC709
// Tool Versions: 2015.4
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module CRC32_TX(

      input CLK,
      input RESET,
      input [63:0] DATA_IN,
      input [2:0] v_b,
      input w_en,
      output reg [31:0] FCS
    );
    
    // wires from the output of the LUTs
    wire [31:0] LUT4_OUT_4_2BYTE;
    wire [31:0] LUT3_OUT_4_2BYTE;
    wire [31:0] LUT2_OUT_4_2BYTE;
    wire [31:0] LUT1_OUT_4_2BYTE;
    
    wire [31:0] LUT4_OUT_4_1BYTE;
    wire [31:0] LUT3_OUT_4_1BYTE;
    wire [31:0] LUT2_OUT_4_1BYTE;
    wire [31:0] LUT1_OUT_4_1BYTE;
	
    //wires in the TXOR block
    wire [31:0] TXOR_IN_2BYTE;
    wire [31:0] TXOR_IN_1BYTE;
    
    //input wires for the LUTs
    reg [31:0] DATA_2BYTE_IN;
    reg [31:0] DATA_1BYTE_IN;
    
    reg [31:0] TXOR_OUT;
    
    reg [7:0] FILL_DATA;
    
    //CRC_IN
    reg [7:0] CRC_8_EN;
    wire [31:0] FCS_1,FCS_2,FCS_3;
    reg [31:0] poly;

    assign FCS_1={FCS[23:0],{1{FILL_DATA}}};
    assign FCS_2={FCS[15:0],{2{FILL_DATA}}};
    assign FCS_3={FCS[7:0],{3{FILL_DATA}}};
    
    always@(*)begin 
        case(v_b)
        3'd0:begin {DATA_2BYTE_IN,DATA_1BYTE_IN}={DATA_IN[63:32]^FCS,DATA_IN[31:0]};TXOR_OUT = TXOR_IN_2BYTE^TXOR_IN_1BYTE; end
        3'd1:begin {DATA_2BYTE_IN,DATA_1BYTE_IN}={{7{FILL_DATA}},DATA_IN[63:56]^FCS[31:24]};TXOR_OUT = TXOR_IN_2BYTE^TXOR_IN_1BYTE^FCS_1; end
        3'd2:begin {DATA_2BYTE_IN,DATA_1BYTE_IN}={{6{FILL_DATA}},DATA_IN[63:48]^FCS[31:16]};TXOR_OUT = TXOR_IN_2BYTE^TXOR_IN_1BYTE^FCS_2; end
        3'd3:begin {DATA_2BYTE_IN,DATA_1BYTE_IN}={{5{FILL_DATA}},DATA_IN[63:40]^FCS[31:8]};TXOR_OUT = TXOR_IN_2BYTE^TXOR_IN_1BYTE^FCS_3; end
        3'd4:begin {DATA_2BYTE_IN,DATA_1BYTE_IN}={{4{FILL_DATA}},FCS^DATA_IN[63:32]};TXOR_OUT = TXOR_IN_2BYTE^TXOR_IN_1BYTE; end
        3'd5:begin {DATA_2BYTE_IN,DATA_1BYTE_IN}={{3{FILL_DATA}},FCS^DATA_IN[63:32],DATA_IN[31:24]};TXOR_OUT = TXOR_IN_2BYTE^TXOR_IN_1BYTE; end
        3'd6:begin {DATA_2BYTE_IN,DATA_1BYTE_IN}={{2{FILL_DATA}},FCS^DATA_IN[63:32],DATA_IN[31:16]}; TXOR_OUT = TXOR_IN_2BYTE^TXOR_IN_1BYTE; end 
        3'd7:begin {DATA_2BYTE_IN,DATA_1BYTE_IN}={{1{FILL_DATA}},FCS^DATA_IN[63:32],DATA_IN[31:8]}; TXOR_OUT = TXOR_IN_2BYTE^TXOR_IN_1BYTE; end 
        endcase
    end
    
    //TXOR operation
    assign  TXOR_IN_2BYTE = LUT4_OUT_4_2BYTE^LUT3_OUT_4_2BYTE^LUT2_OUT_4_2BYTE^LUT1_OUT_4_2BYTE;
    assign  TXOR_IN_1BYTE = LUT4_OUT_4_1BYTE^LUT3_OUT_4_1BYTE^LUT2_OUT_4_1BYTE^LUT1_OUT_4_1BYTE;
            
    //memory blocks; LUTs
    lut_08 lut4_4_2byte(
    .DATA_IN(DATA_2BYTE_IN[31:24]),
    .CRC_VALUE(LUT4_OUT_4_2BYTE)
    );
    
    lut_07 lut3_4_2byte(
    .DATA_IN(DATA_2BYTE_IN[23:16]),
    .CRC_VALUE(LUT3_OUT_4_2BYTE)
    );
    
    lut_06 lut2_4_2byte(
    .DATA_IN(DATA_2BYTE_IN[15:8]),
    .CRC_VALUE(LUT2_OUT_4_2BYTE)
    );
    
    lut_05 lut1_4_2byte(
    .DATA_IN(DATA_2BYTE_IN[7:0]),
    .CRC_VALUE(LUT1_OUT_4_2BYTE)
    );

    
    lut_04 lut4_4_1byte(
    .DATA_IN(DATA_1BYTE_IN[31:24]),
    .CRC_VALUE(LUT4_OUT_4_1BYTE)
    );
    
    lut_03 lut3_4_1byte(
    .DATA_IN(DATA_1BYTE_IN[23:16]),
    .CRC_VALUE(LUT3_OUT_4_1BYTE)
    );
    
    lut_02 lut2_4_1byte(
    .DATA_IN(DATA_1BYTE_IN[15:8]),
    .CRC_VALUE(LUT2_OUT_4_1BYTE)
    );
    
    lut_01 lut1_4_1byte(
    .DATA_IN(DATA_1BYTE_IN[7:0]),
    .CRC_VALUE(LUT1_OUT_4_1BYTE)
    );
    
    //sample the CRC
    always@(posedge CLK, posedge RESET)
    begin
        if(RESET)
        begin
            FCS <= 32'b0;
            FILL_DATA <= 8'b0;
        end
        else if(w_en)
        begin
            FCS <= TXOR_OUT;
        end
    end
endmodule
