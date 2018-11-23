`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: University of Moratuwa
// Engineer: S.D.S.Madusanka
// 
// Create Date: 09/27/2018 10:00:54 AM
// Design Name: rxRSstateMach
// Module Name: rxRSstateMach
// Project Name: 40G Ethernet
// Target Devices: VC709
// Tool Versions: 2016.4
// Description: this belogns to the RS layer
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module rxRSstateMach(
    input CLK,
    input RSTn,
    input [1:0] RX_DATA_ST,
    input [7:0] RXC,
    output ERROR,
    output [7:0] PLS_DATA_IND_VALID
    );
    
    reg [1:0]pre_state=2'b11;
    reg error=1;
    reg [7:0]pls_valid_pipe1=8'hff;
    reg [7:0]pls_valid_pipe2=8'hff;
    
    assign ERROR = error;
    assign PLS_DATA_IND_VALID = pls_valid_pipe2;
    
    always@(posedge CLK)
    begin
        if(~RSTn)
        begin
            pre_state<=2'b11;
            error<=1;
            pls_valid_pipe1<=8'hff;
            pls_valid_pipe2<=8'hff;
        end
        
        else
        begin
            //pipe line the data
            pls_valid_pipe1 <= RXC;
        
            if((RX_DATA_ST == 2'b11)|(pre_state == RX_DATA_ST ))
            begin
                error <= 1;
            end
            else 
            begin
                error <= 0;
            end
            
            if(RX_DATA_ST == 2'b01)
            begin
                pls_valid_pipe2[0] <= ~pls_valid_pipe1[0];
                pls_valid_pipe2[7:1] <= pls_valid_pipe1[7:1];
            end
            else
            begin
                pls_valid_pipe2 <= pls_valid_pipe1;
            end
            
            if(RX_DATA_ST == 2'b01)
            begin
                pre_state=2'b01;
            end
            else if(RX_DATA_ST == 2'b10)
            begin
                pre_state=2'b10;
            end
        end
        
    end
            
endmodule
