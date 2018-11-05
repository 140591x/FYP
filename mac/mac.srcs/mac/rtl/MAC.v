`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: University of Moratuwa
// Engineer: S.D.S.Madusanka
// 
// Create Date: 11/05/2018 11:47:38 AM
// Design Name: MAC
// Module Name: MAC
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


module MAC(
    input SYS_CLK,
    input RX_CLK,
    input TX_CLK,
    output PCS_CLK,
    input RSTn, //Active low
    input [63:0] TX_DATA,
    input TX_SOP,
    input TX_EOP,
    input [2:0] V_B,
    input TX_ERROR,
    input TX_VALID,
    output TX_READY,
    output [63:0] PLS_DATA_IND,
    output [7:0] PLS_DATA_IND_VALID,
    
    
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
    
    MAC_TX TX_TOP(
        .t_clk(SYS_CLK),//for transmitter 625MHz
        .clk(TX_CLK), //CPU clock
        .rst(~RSTn),
        .tx_data(TX_DATA),
        .tx_sop(TX_SOP),
        .tx_eop(TX_EOP),
        .v_b(V_B),//#number of valid bytes,always one except eop can have other values
        .tx_ready(TX_READY),
        .tx_error(TX_ERROR),
        .tx_valid(TX_VALID),
        .TX_D(PLS_DATA_IND),
        .TX_C(PLS_DATA_IND_VALID),
        .TX_CLK(PCS_CLK)
    );
    
    MAC_RX(
        .CLK(SYS_CLK),
        .RX_CLK(RX_CLK),
        .RSTn(RSTn),
        .RXD(RXD),
        .RXC(RXC),
        .MA_DATA(MA_DATA),
        .MA_FRAME_ERROR(MA_FRAME_ERROR),
        .MA_DATA_VALID(MA_DATA_VALID),
        .MA_FRAME_START(MA_FRAME_START),
        .MA_FRAME_END(MA_FRAME_END),
        .RX_READY(RX_READY),
        .RX_READ(RX_READ)
    );
   
endmodule
