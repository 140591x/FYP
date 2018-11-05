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
// Tool Versions: 2016.4
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module CRC32(
    input CLK,
    input RESETN,
    input [63:0] DATA_IN,
    input [31:0] CRC_INIT,
    input CRC_IN,
    input [7:0] CRC_8_EN,
    output reg [31:0]FCS
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
    wire [31:0] DATA_2BYTE_IN;
    wire [31:0] DATA_1BYTE_IN;
    
    wire [31:0] TXOR_OUT;
    
    reg [63:0] INTER_DATA;
    reg [31:0] FB_4_LAST_BYTE;
    reg DATA_LESS_32;
    
    
    initial
    begin
        INTER_DATA <= 64'b0;
        FCS <= 32'b0;
        DATA_LESS_32 <= 0;
    end
    
    //assign LUT input wires from the input data
    /*The last data set should have no less than 32 bit (the size of CRC)*/
    assign DATA_2BYTE_IN = (CRC_IN)?(CRC_INIT^DATA_IN[63:32]):(INTER_DATA[63:32]);
    assign DATA_1BYTE_IN = INTER_DATA[31:0];
    
    //TXOR operation
    assign  TXOR_IN_2BYTE = LUT4_OUT_4_2BYTE^LUT3_OUT_4_2BYTE^LUT2_OUT_4_2BYTE^LUT1_OUT_4_2BYTE;
    assign  TXOR_IN_1BYTE = LUT4_OUT_4_1BYTE^LUT3_OUT_4_1BYTE^LUT2_OUT_4_1BYTE^LUT1_OUT_4_1BYTE;
        
    assign TXOR_OUT = TXOR_IN_2BYTE^TXOR_IN_1BYTE^FB_4_LAST_BYTE;
    
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
    
    always@(*)
    begin
        case(CRC_8_EN)
            8'b0000_0000:
                begin
                    if(~CRC_IN)
                    begin
                        INTER_DATA[63:32] <= FCS^DATA_IN[63:32];
                        INTER_DATA[31:0] <= DATA_IN[31:0];
                        FB_4_LAST_BYTE <= 0;
                        DATA_LESS_32 <= 0;
                    end
                    else
                    begin
                        INTER_DATA <= DATA_IN;
                        DATA_LESS_32 <= 0;
                        FB_4_LAST_BYTE <= 0;
                    end
                end
            
            8'b1000_0000:
                    begin
                        INTER_DATA[55:24] <= FCS^DATA_IN[63:32];
                        INTER_DATA[63:56] <= 0;
                        INTER_DATA[23:0] <= DATA_IN[31:8];
                        FB_4_LAST_BYTE <= 0;
                        DATA_LESS_32 <= 0;
                    end
            
            8'b1100_0000:
                    begin
                        INTER_DATA[47:16] <= FCS^DATA_IN[63:32];
                        INTER_DATA[63:48] <= 0;
                        INTER_DATA[15:0] <= DATA_IN[31:16];
                        FB_4_LAST_BYTE <= 0;
                        DATA_LESS_32 <= 0;
                    end
                    
            8'b1110_0000:
                    begin
                        INTER_DATA[39:8] <= FCS^DATA_IN[63:32];
                        INTER_DATA[63:40] <= 0;
                        INTER_DATA[7:0] <= DATA_IN[31:24];
                        FB_4_LAST_BYTE <= 0;
                        DATA_LESS_32 <= 0;
                    end
                    
            8'b1111_0000:
                    begin
                        INTER_DATA[31:0] <= FCS^DATA_IN[63:32];
                        INTER_DATA[63:32] <= 0;
                        FB_4_LAST_BYTE <= 0;
                        DATA_LESS_32 <= 0;
                    end
            8'b1111_1000:
                    begin
//                        INTER_DATA[31:0] <= FCS;
                        INTER_DATA[23:0] <= FCS[31:8]^DATA_IN[63:40];
                        INTER_DATA[63:24] <= 0;
                        FB_4_LAST_BYTE <= {FCS[7:0],24'h0};
//                        INTER_DATA[31:24] <= FCS[31:24];
                        DATA_LESS_32 <= 1;
                    end
                    
            8'b1111_1100:
                    begin
                        INTER_DATA[15:0] <= FCS[31:16]^DATA_IN[63:48];
                        INTER_DATA[63:16] <= 0;
                        FB_4_LAST_BYTE <= {FCS[15:0],16'h0};
                        DATA_LESS_32 <= 0;
                    end
            8'b1111_1110:
                    begin
                        INTER_DATA[7:0] <= FCS[31:24]^DATA_IN[63:56];
                        INTER_DATA[63:8] <= 0;
                        FB_4_LAST_BYTE <= {FCS[23:0],8'h0};
                        DATA_LESS_32 <= 0;
                    end
                    
            8'b1111_1111:
                    begin
                        INTER_DATA <= 64'b0;
                        DATA_LESS_32 <= 0;
                    end
        endcase
    end
    
    //sample the CRC
    always@(posedge CLK, negedge RESETN)
    begin
        if(~RESETN)
        begin
            FCS = 32'b0;
            INTER_DATA <= 64'b0;
            DATA_LESS_32 <= 0;
        end
        else
        begin
            FCS <= TXOR_OUT;
        end
    end
endmodule
