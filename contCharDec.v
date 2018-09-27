`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Anushka
module contCharDec(
    input [63:0] RXD,
    input [7:0] RXC,
    output reg [63:0] PLS_DATA,
    output reg [1:0] RX_DATA_ST
    );
    parameter start_control = 8'hFB;
    parameter terminate_control = 8'hFD;

    always @ (*) begin
    if(RXC == 8'b0000_0001 && RXD[7:0] == start_control) begin   
                 RX_DATA_ST = 2'b01;
                 PLS_DATA = {RXD[63:8],8'b0101_0101};
             end
    else if((RXC == 8'b1111_1111 &&   RXD[7:0] == terminate_control) || (RXC == 8'b1111_1110 &&  RXD[15:8] == terminate_control) ||
            (RXC == 8'b1111_1100 && RXD[23:16] == terminate_control) || (RXC == 8'b1111_1000 && RXD[31:24] == terminate_control) ||
            (RXC == 8'b1111_0000 && RXD[39:32] == terminate_control) || (RXC == 8'b1110_0000 && RXD[47:40] == terminate_control) ||
            (RXC == 8'b1100_0000 && RXD[55:48] == terminate_control) || (RXC == 8'b1000_0000 && RXD[63:56] == terminate_control) )  begin
                RX_DATA_ST = 2'b10;
                PLS_DATA = RXD;
                end
    else if (RXC == 8'b0000_0000) begin
                RX_DATA_ST = 2'b00; 
                PLS_DATA = RXD;
                end
    else     begin
                RX_DATA_ST = 2'b11; 
                PLS_DATA = RXD;
                end         
    end
    
    
endmodule
