`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:02:17 11/05/2014 
// Design Name: 
// Module Name:    PCS 
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
module PCS(
   input wire [71:0] encoder_in,
	input wire TX_CLK,
	input wire reset,
	input wire tx_test_mode,
	output wire [65:0] Lane_0_out,
	output wire [65:0] Lane_1_out,
	output wire [65:0] Lane_2_out,
	output wire [65:0] Lane_3_out,
	output wire CLK_OUT,	
	output wire [71:0] decoder_data_out,
	input wire RX_CLK,
	input wire [65:0] lane0_data,lane1_data,lane2_data,lane3_data,
	input wire lane0_clk,lane1_clk,lane2_clk,lane3_clk,
	input wire rx_test_mode,
	output wire [15:0] test_pattern_error_count,
	output wire PCS_status,
	output wire hi_ber,
	output wire block_lock_lane_0,
	output wire block_lock_lane_1,
	output wire block_lock_lane_2,
	output wire block_lock_lane_3,
	output wire am_lock_lane_0,
	output wire am_lock_lane_1,
	output wire am_lock_lane_2,
	output wire am_lock_lane_3,
   output wire align_status,
	output wire [1:0] lane_mapping_0,
	output wire [1:0] lane_mapping_1,
	output wire [1:0] lane_mapping_2,
	output wire [1:0] lane_mapping_3,
	output wire [15:0] bip_counter_lane_0,
	output wire [15:0] bip_counter_lane_1,
	output wire [15:0] bip_counter_lane_2,
	output wire [15:0] bip_counter_lane_3,
   output wire [21:0] errored_block_count	
);

   Transmitter Transmitter(.encoder_in(encoder_in),.TX_CLK(TX_CLK),.reset(reset),
	            .scram_rst(1'b0),.Lane_0_out(Lane_0_out),.Lane_1_out(Lane_1_out),
					.Lane_2_out(Lane_2_out),.Lane_3_out(Lane_3_out),.CLK_OUT(CLK_OUT),
					.tx_test_mode(tx_test_mode)); 

   Receiver Receiver(.lane0_clk(lane0_clk),.lane1_clk(lane1_clk),.lane2_clk(lane2_clk),
	                  .lane3_clk(lane3_clk),.lane0_data(lane0_data),
							.lane1_data(lane1_data),
							.lane2_data(lane2_data),.lane3_data(lane3_data),
							.descrambler_reset(1'b0),
							.decoder_data_out(decoder_data_out),.RX_CLK(RX_CLK),.reset(reset),
							.rx_test_mode(rx_test_mode),
							.test_pattern_error_count(test_pattern_error_count),
							.PCS_status(PCS_status),
							.hi_ber(hi_ber),
							.block_lock_lane_0(block_lock_lane_0),
				         .block_lock_lane_1(block_lock_lane_1),
				         .block_lock_lane_2(block_lock_lane_2),
				         .block_lock_lane_3(block_lock_lane_3),
				         .am_lock_lane_0(am_lock_lane_0),
				         .am_lock_lane_1(am_lock_lane_1),
				         .am_lock_lane_2(am_lock_lane_2),
				         .am_lock_lane_3(am_lock_lane_3),
							.align_status(align_status),
							.lane_mapping_0(lane_mapping_0),
				         .lane_mapping_1(lane_mapping_1),
				         .lane_mapping_2(lane_mapping_2),
				         .lane_mapping_3(lane_mapping_3),
							.bip_counter_lane_0(bip_counter_lane_0),
				         .bip_counter_lane_1(bip_counter_lane_1),
				         .bip_counter_lane_2(bip_counter_lane_2),
				         .bip_counter_lane_3(bip_counter_lane_3),
							.errored_block_count(errored_block_count)
   );
														
endmodule
