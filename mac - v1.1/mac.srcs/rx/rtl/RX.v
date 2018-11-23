`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/11/2018 05:07:31 PM
// Design Name: 
// Module Name: RX
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


module RX(
    input CLK,
    input RSTn,
    input [63:0] PLS_DATA_IND,
    input [7:0] PLS_DATA_IND_VALID,
    input RX_READ,
    input RX_CLK,
    output [63:0] MA_DATA,
    output MA_FRAME_ERROR,
    output [2:0] MA_DATA_VALID,
    output MA_FRAME_START,
    output MA_FRAME_END,
    output RX_READY
    );
    
    wire DA_VALID;
    wire RX_DATA_CONT;
    wire FRAME_START;
    wire FRAME_END;
    wire [15:0]LEN_TYPE;
    wire FCS_ERROR;
    wire [63:0]PLS_DATA;
    wire ERROR;
    wire [2:0]DATA_VALID;
    wire EOF_ASY;
    wire SOF_ASY;
    wire PAD_REMOVE;
    
    rxStateMach rxStateMach_inst(
        .CLK(CLK),
        .RSTn(RSTn),
        .PLS_DATA_IND_VALID(PLS_DATA_IND_VALID),
        .PLS_DATA_IND(PLS_DATA_IND),
        .DA_VALID(DA_VALID),
        .RX_DATA_CONT(RX_DATA_CONT),
        .FRAME_START(FRAME_START),
        .FRAME_END(FRAME_END)
    );
    
    DAcheck DAcheck_inst(
        .FRAME_START(FRAME_START),
        .PLS_DATA_IND(PLS_DATA_IND),
        .DA_VALID(DA_VALID)
    );
    
    lenTypeReg lenTypeReg_inst(
        .CLK(CLK),
        .RSTn(RSTn),
        .PLS_DATA_IND(PLS_DATA_IND),
        .FRAME_START(FRAME_START),
        .LEN_TYPE(LEN_TYPE)
    );
    
    rxFrameState #(
        .MIN_FRAME_SIZE(512),
        .ADDRESS_SIZE(48)) rxFrameState_inst(
        .CLK(CLK),
        .RSTn(RSTn),
        .LEN_TYPE(LEN_TYPE),
        .PLS_DATA_IND(PLS_DATA_IND),
        .PLS_DATA_IND_VALID(PLS_DATA_IND_VALID),
        .FCS_VALID(FCS_ERROR),
        .FRAME_START(FRAME_START),
        .FRAME_END(FRAME_END),
        .PLS_DATA(PLS_DATA),
        .ERROR(ERROR),
        .DATA_VALID(DATA_VALID),
        .SOF(SOF_ASY),
        .EOF(EOF_ASY),
        .PAD_REMOVE(PAD_REMOVE)
    );
    
    rxFCSCheck rxFCSCheck_inst(
        .CLK(CLK),
        .RESETn(RSTn),
        .RX_CONTROL(PLS_DATA_IND_VALID),
        .DATA_IN(PLS_DATA_IND),
        .EOF(FRAME_END),
        .SOF(FRAME_START),
        .FCS_ERROR(FCS_ERROR)
    );
    
    rxSynchr rxSynchr_inst(
        .CLK(CLK),
        .RSTn(RSTn),
        .RX_CLK(RX_CLK),
        .PAD_REMOVE(PAD_REMOVE),
        .RX_DATA_CONT(RX_DATA_CONT),
        .PLS_DATA(PLS_DATA),
        .ERROR(ERROR),
        .VALID(DATA_VALID),
        .SOF(SOF_ASY),
        .EOF(EOF_ASY),
        .RX_READ(RX_READ),
        .MA_DATA(MA_DATA),
        .MA_FRAME_ERROR(MA_FRAME_ERROR),
        .MA_DATA_VALID(MA_DATA_VALID),
        .MA_FRAME_START(MA_FRAME_START),
        .MA_FRAME_END(MA_FRAME_END),
        .RX_READY(RX_READY)
    );
    
endmodule
