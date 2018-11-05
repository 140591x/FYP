`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/27/2018 12:11:27 PM
// Design Name: 
// Module Name: rxRS
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


module rxRS(
    input CLK,
    input RSTn,
    input [63:0] RXD,
    input [7:0] RXC,
    output [63:0] PLS_DATA_IND,
    output [7:0] PLS_DATA_IND_VALID
    );
    
    wire ERROR;
    wire [1:0]RX_DATA_ST;
    wire [63:0]PLS_DATA;
    
    
    dataCor dataCor_inst(
        .CLK(CLK),
        .RSTn(RSTn),
        .ERROR(ERROR),
        .PLS_DATA(PLS_DATA),
        .PLS_DATA_IND(PLS_DATA_IND)
    );
    
    rxRSstateMach rxRSstateMach_inst(
        .CLK(CLK),
        .RSTn(RSTn),
        .RX_DATA_ST(RX_DATA_ST),
        .RXC(RXC),
        .ERROR(ERROR),
        .PLS_DATA_IND_VALID(PLS_DATA_IND_VALID)
    );
    
    contCharDec contCharDec_inst(
        .RXD(RXD),
        .RXC(RXC),
        .PLS_DATA(PLS_DATA),
        .RX_DATA_ST(RX_DATA_ST)
    );
    
endmodule
