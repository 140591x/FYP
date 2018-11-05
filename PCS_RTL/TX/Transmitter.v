`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    04:50:53 08/28/2014 
// Design Name: 
// Module Name:    Transmitter 
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
module Transmitter(
   input wire [71:0] encoder_in,
	input wire TX_CLK,
	input wire reset,
	input wire scram_rst,
	input wire tx_test_mode,
	output wire [65:0] Lane_0_out,
	output wire [65:0] Lane_1_out,
	output wire [65:0] Lane_2_out,
	output wire [65:0] Lane_3_out,
	output wire CLK_OUT	
);

wire [65:0] encoder_data_out;

encoder Encoder(.encoder_in(encoder_in),.TX_CLK(TX_CLK),.reset(reset),.encoder_data_out(encoder_data_out));

block_distribution_align_insertion Block_distribution_align_insertion(.data_in(encoder_data_out),.TX_CLK(TX_CLK),
                  .reset(reset),.Lane_0_out(Lane_0_out),.Lane_1_out(Lane_1_out),.Lane_2_out(Lane_2_out),
						.Lane_3_out(Lane_3_out),.CLK_OUT(CLK_OUT),.scram_rst(scram_rst),
						.tx_test_mode(tx_test_mode));

endmodule
