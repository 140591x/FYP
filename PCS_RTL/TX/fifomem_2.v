`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:09:23 10/28/2014 
// Design Name: 
// Module Name:    fifomem 
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
module fifomem_2 #(parameter DATASIZE = 72, // Memory data word width
parameter ADDRSIZE = 7) // Number of mem address bits
(output [DATASIZE-1:0] rdata,
input [DATASIZE-1:0] wdata,
input [ADDRSIZE-1:0] waddr, raddr,
input wclken, wfull, wclk);
`ifdef VENDORRAM
// instantiation of a vendor's dual-port RAM
vendor_ram mem (.dout(rdata), .din(wdata),
.waddr(waddr), .raddr(raddr),
.wclken(wclken),
.wclken_n(wfull), .clk(wclk));
`else
// RTL Verilog memory model
localparam DEPTH = 1<<ADDRSIZE;
reg [DATASIZE-1:0] mem [0:DEPTH-1];
assign rdata = mem[raddr];
always @(posedge wclk)
if (wclken && !wfull) mem[waddr] <= wdata;
`endif
endmodule