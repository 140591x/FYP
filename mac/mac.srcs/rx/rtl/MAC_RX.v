`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: University of Moratuwa
// Engineer: S.D.S.Madusanka
// 
// Create Date: 11/05/2018 11:22:29 AM
// Design Name: MAC_RX
// Module Name: MAC_RX
// Project Name: 40G Ethernet
// Target Devices: VC709
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


module MAC_RX(
    input CLK,
    input RX_CLK,
    input RSTn,
    input [63:0] RXD,
    input [7:0] RXC,
    output [63:0] MA_DATA,
    output MA_FRAME_ERROR,
    output [2:0] MA_DATA_VALID,
    output MA_FRAME_START,
    output MA_FRAME_END,
    output RX_READY,
    input RX_READ
    );
    
    wire [63:0]pls_data_ind;
    wire [7:0]pls_data_ind_valid;
    
    RX(
        .CLK(CLK),
        .RSTn(RSTn),
        .PLS_DATA_IND(pls_data_ind),
        .PLS_DATA_IND_VALID(pls_data_ind_valid),
        .RX_READ(RX_READ),
        .RX_CLK(RX_CLK),
        .MA_DATA(MA_DATA),
        .MA_FRAME_ERROR(MA_FRAME_ERROR),
        .MA_DATA_VALID(MA_DATA_VALID),
        .MA_FRAME_START(MA_FRAME_START),
        .MA_FRAME_END(MA_FRAME_END),
        .RX_READY(RX_READY)
    );
        
    rxRS(
        .CLK(CLK),
        .RSTn(RSTn),
        .RXD(RXD),
        .RXC(RXC),
        .PLS_DATA_IND(pls_data_ind),
        .PLS_DATA_IND_VALID(pls_data_ind_valid)
    );
    
endmodule
