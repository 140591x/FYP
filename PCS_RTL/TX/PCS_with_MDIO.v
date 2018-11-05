`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:33:36 11/18/2014 
// Design Name: 
// Module Name:    PCS_with_MDIO 
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
module PCS_with_MDIO(
   input wire [71:0] encoder_in,
	input wire TX_CLK,
	output wire [65:0] Lane_0_out,
	output wire [65:0] Lane_1_out,
	output wire [65:0] Lane_2_out,
	output wire [65:0] Lane_3_out,
	output wire CLK_OUT,	
	output wire [71:0] decoder_data_out,
	input wire RX_CLK_IN,
	output wire RX_CLK_OUT,
	input wire [65:0] lane0_data,lane1_data,lane2_data,lane3_data,
	input wire lane0_clk,lane1_clk,lane2_clk,lane3_clk,
	
	//MDIO input output
	input wire reset,  //1 - reset , 0 - normal operation
	input wire loopback, //1 - enable loopback , 0 - disable loopback 
	input wire tx_test_mode, //1 = Enable transmit test pattern , 0 = Disable transmit test pattern
	input wire rx_test_mode, //1 = Enable receive test-pattern testing , 0 = Disable receive test-pattern testing
	
	/*in current implementation
	   in rx_test_mode in order to get the correct test_pattern_error_count value following conditions
      should be satisfied
      
		step 1: setting tx_test_mode of the transmitting pcs to 1 and setting rx_test_mode of the receiving 
		        pcs to 1
				  
		step 2: resetting the receiving pcs	

      Not implemented functionality :- setting test_pattern_error_count register 
		value to 0 after reading it's value 	
	*/
	
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
	output wire [21:0] ber_count,	
   output wire [21:0] errored_block_count,
   output wire [15:0] test_pattern_error_count, 	
	output wire [15:0] bip_counter_lane_0,
	output wire [15:0] bip_counter_lane_1,
	output wire [15:0] bip_counter_lane_2,
	output wire [15:0] bip_counter_lane_3,
	output wire [1:0] lane_mapping_0,
	output wire [1:0] lane_mapping_1,
	output wire [1:0] lane_mapping_2,
	output wire [1:0] lane_mapping_3	
	////
);

wire [71:0] decoder_data_out_loopback_disabled;

PCS PCS_core(.reset(~reset),.encoder_in(encoder_in),.TX_CLK(TX_CLK),
             .Lane_0_out(Lane_0_out),.Lane_1_out(Lane_1_out),
				 .Lane_2_out(Lane_2_out),.Lane_3_out(Lane_3_out),
				 .CLK_OUT(CLK_OUT),.decoder_data_out(decoder_data_out_loopback_disabled),
				 .RX_CLK(RX_CLK_IN),.lane0_data(lane0_data),
				 .lane1_data(lane1_data),.lane2_data(lane2_data),
				 .lane3_data(lane3_data),.lane0_clk(lane0_clk),
				 .lane1_clk(lane1_clk),.lane2_clk(lane2_clk),
				 .lane3_clk(lane3_clk),
				 .tx_test_mode(tx_test_mode),
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
				 
//MDIO functionalities				 
				 
//LOOPBACK operation
assign RX_CLK_OUT = loopback ? TX_CLK : RX_CLK_IN;
assign decoder_data_out = loopback ? encoder_in : decoder_data_out_loopback_disabled;
////////	

//////			 
				 		
endmodule
