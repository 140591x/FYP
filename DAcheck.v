`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Anushka
// data from rs must be delayed a single clk cycle before reaching DAchecker
// basically when frame_start comes, data available should be the 2nd block

module DAcheck(
    input FRAME_START,
    input [63:0] PLS_DATA_IND,
    output reg DA_VALID
    );
    always @ (*)  begin
            if(FRAME_START == 1 && PLS_DATA_IND[47:0] == 48'h00_00_00_11_11_11 )                  DA_VALID <= 1'b1;  
            else if(FRAME_START == 1 && PLS_DATA_IND[47:23] == 25'b00000001_00000000_01011110_0 ) DA_VALID <= 1'b1;
            else if(FRAME_START == 1 && PLS_DATA_IND[47:32] == 16'h33_33)                         DA_VALID <= 1'b1;
            else                                                                                  DA_VALID <= 1'b0;
        end
    
    
endmodule
