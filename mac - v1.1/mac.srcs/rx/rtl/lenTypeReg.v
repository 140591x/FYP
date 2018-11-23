`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Anushka
module lenTypeReg(
    input CLK,
    input RSTn,
    input [63:0] PLS_DATA_IND,
    input FRAME_START,
    output reg [15:0] LEN_TYPE
    );
    
    
    initial
    begin
        LEN_TYPE <= 0;
    end
    
    always @(posedge CLK, negedge RSTn) begin
        if(~RSTn)
        begin
             LEN_TYPE <= 0;
        end
        
        else
        begin
            if(FRAME_START == 1) LEN_TYPE <= PLS_DATA_IND[47:32];
        end
    end
endmodule
