`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:08:38 10/28/2014 
// Design Name: 
// Module Name:    fifo1 
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
module fifo_2 #(parameter DSIZE = 72,
parameter ASIZE = 7)
(output rempty,
output wfull,
output [DSIZE-1:0] rdata,
input [DSIZE-1:0] wdata,
input winc, wclk, wrst_n,
input rinc, rclk, rrst_n);
wire [ASIZE-1:0] waddr, raddr;
wire [ASIZE:0] wptr, rptr, wq2_rptr, rq2_wptr;
sync_r2w_2 sync_r2w (.wq2_rptr(wq2_rptr), .rptr(rptr),
.wclk(wclk), .wrst_n(wrst_n));
sync_w2r_2 sync_w2r (.rq2_wptr(rq2_wptr), .wptr(wptr),
.rclk(rclk), .rrst_n(rrst_n));
fifomem_2 #(DSIZE, ASIZE) fifomem
(.rdata(rdata), .wdata(wdata),
.waddr(waddr), .raddr(raddr),
.wclken(winc), .wfull(wfull),
.wclk(wclk));
rptr_empty_2 #(ASIZE) rptr_empty
(
.rempty(rempty),
.raddr(raddr),
.rptr(rptr),
.rq2_wptr(rq2_wptr),
.rinc(rinc), .rclk(rclk),
.rrst_n(rrst_n));
wptr_full_2 #(ASIZE) wptr_full
(.wfull(wfull), .waddr(waddr),
.wptr(wptr), .wq2_rptr(wq2_rptr),
.winc(winc), .wclk(wclk),
.wrst_n(wrst_n));
endmodule