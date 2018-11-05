`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/28/2018 03:59:44 PM
// Design Name: 
// Module Name: rxFCSCheck
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


module rxFCSCheck(
    input CLK,
    input RESETn,
    input [7:0] RX_CONTROL,
    input [63:0] DATA_IN,
    input EOF,
    input SOF,
    output FCS_ERROR
    );
    
    reg FCS_INVALID;
    reg [31:0] CRC_INIT;
    reg RESETn_CRC32;
    reg lane_0_prev;
    reg data_valid;
//    reg [1:0] CRC_START;
    wire [63:0] DATA_IN_FLIP;
    wire [31:0]FCS;
    
    assign FCS_ERROR = FCS_INVALID;

    assign DATA_IN_FLIP[63:56] = (RX_CONTROL[0]?8'b0:DATA_IN[7:0]); 
    assign DATA_IN_FLIP[55:48] = (RX_CONTROL[1]?8'b0:DATA_IN[15:8]);
    assign DATA_IN_FLIP[47:40] = (RX_CONTROL[2]?8'b0:DATA_IN[23:16]); 
    assign DATA_IN_FLIP[39:32] = (RX_CONTROL[3]?8'b0:DATA_IN[31:24]); 
    assign DATA_IN_FLIP[31:24] = (RX_CONTROL[4]?8'b0:DATA_IN[39:32]); 
    assign DATA_IN_FLIP[23:16] = (RX_CONTROL[5]?8'b0:DATA_IN[47:40]); 
    assign DATA_IN_FLIP[15:8] = (RX_CONTROL[6]?8'b0:DATA_IN[55:48]); 
    assign DATA_IN_FLIP[7:0] = (RX_CONTROL[7]?8'b0:DATA_IN[63:56]);  
    
    initial 
    begin
        RESETn_CRC32 <= 1'b1;
        CRC_INIT <= 32'b0;
        FCS_INVALID <= 1'b0;
        lane_0_prev <= 1;
        data_valid <= 0;
        
    end
    

    
    CRC32 crc_inst(
        .CLK(CLK),
        .RESETN(RESETn_CRC32),
        .DATA_IN(DATA_IN_FLIP),
        .CRC_INIT(CRC_INIT),
        .CRC_IN(0),
        .CRC_8_EN(RX_CONTROL),
        .FCS(FCS)
    );
    
    always@(posedge CLK, negedge RESETn)
    begin
        if(~RESETn | ~data_valid & ~FCS_INVALID)
        begin
            RESETn_CRC32 <= 1'b0;
        end
        
        else
        begin
            if(EOF & (FCS != 32'b0))
            begin
                FCS_INVALID <= 1'b1;
                RESETn_CRC32 <= 1'b0;
            end
            
            else
            begin
                FCS_INVALID <= 1'b0;
                RESETn_CRC32 <= 1'b1;
            end
        end
        
    end
    
    always@(posedge CLK, negedge RESETn)
    begin
        if(~RESETn)
        begin
            lane_0_prev <= 0;
        end
        else
        begin
            lane_0_prev <= RX_CONTROL[0];
            if(~(lane_0_prev & RX_CONTROL[0]))
            begin
                data_valid <= 1;
            end
            else
            begin
                data_valid <= 0;
            end
        end
    end
    
endmodule
