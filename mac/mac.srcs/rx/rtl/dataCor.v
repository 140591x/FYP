`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: University of Moratuwa
// Engineer: S.D.S.Madusanka
// 
// Create Date: 09/27/2018 08:16:48 AM
// Design Name: dataCor
// Module Name: dataCor
// Project Name: 40G Ethernet
// Target Devices: VC709
// Tool Versions: 2016.4
// Description: part of the RS layer
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module dataCor(
    input CLK,
    input RSTn,
    input ERROR,
    input [63:0] PLS_DATA,
    output [63:0] PLS_DATA_IND
    );
    
    //data pipe for time adjusment
    reg [63:0]pls_data_pipe=0;
    
    assign PLS_DATA_IND = pls_data_pipe;
    
    always@(posedge CLK, negedge RSTn)
    begin
        if(~RSTn)
        begin
            pls_data_pipe <= 0;
        end
        else
        begin
            //corrupting the data in the lane0 if ERROR indicate
            pls_data_pipe[7:0] <= (ERROR)?~PLS_DATA[7:0]:PLS_DATA[7:0];
            pls_data_pipe[63:8] <= PLS_DATA[63:8];
        end
    
    end
    
endmodule
