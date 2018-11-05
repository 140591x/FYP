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
module fifo_top #(parameter DSIZE = 264,
parameter ASIZE = 5) //32 locations
(output [DSIZE-1:0] rdata,
output wfull,
output rempty,
input [DSIZE-1:0] wdata,
input winc, wclk, wrst_n,
input rinc, rclk, rrst_n);
wire [ASIZE-1:0] waddr, raddr;
wire [ASIZE:0] wptr, rptr, wq2_rptr, rq2_wptr;
sync_r2w_top sync_r2w_top (.wq2_rptr(wq2_rptr), .rptr(rptr),
.wclk(wclk), .wrst_n(wrst_n));
sync_w2r_top sync_w2r_top (.rq2_wptr(rq2_wptr), .wptr(wptr),
.rclk(rclk), .rrst_n(rrst_n));
fifomem_top #(DSIZE, ASIZE) fifomem_top
(.rdata(rdata), .wdata(wdata),
.waddr(waddr), .raddr(raddr),
.wclken(winc), .wfull(wfull),
.wclk(wclk));
rptr_empty_top #(ASIZE) rptr_empty_top
(.rempty(rempty),
.raddr(raddr),
.rptr(rptr),
.rq2_wptr(rq2_wptr),
.rinc(rinc), .rclk(rclk),
.rrst_n(rrst_n));
wptr_full_top #(ASIZE) wptr_full_top
(.wfull(wfull), .waddr(waddr),
.wptr(wptr), .wq2_rptr(wq2_rptr),
.winc(winc), .wclk(wclk),
.wrst_n(wrst_n));
endmodule