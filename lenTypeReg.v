`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Anushka
module lenTypeReg(
    input [63:0] PLS_DATA_IND,
    input FRAME_START,
    output reg [15:0] LEN_TYPE
    );
    always @(*) begin
        if(FRAME_START == 1) LEN_TYPE = PLS_DATA_IND[47:32];
        else LEN_TYPE = 0;
    end
endmodule
