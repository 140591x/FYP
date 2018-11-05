`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:12:24 10/28/2014 
// Design Name: 
// Module Name:    sync_w2r 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module sync_w2r_top #(parameter ADDRSIZE = 5)
(output reg [ADDRSIZE:0] rq2_wptr,
input [ADDRSIZE:0] wptr,
input rclk, rrst_n);
reg [ADDRSIZE:0] rq1_wptr;
always @(posedge rclk or negedge rrst_n)
if (!rrst_n) {rq2_wptr,rq1_wptr} <= 0;
else {rq2_wptr,rq1_wptr} <= {rq1_wptr,wptr};
endmodule