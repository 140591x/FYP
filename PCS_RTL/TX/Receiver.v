`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:04:30 10/30/2014 
// Design Name: 
// Module Name:    Receiver 
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
module Receiver(
   input wire lane0_clk,lane1_clk,lane2_clk,lane3_clk,
	input wire [65:0] lane0_data,lane1_data,lane2_data,lane3_data, 
	input wire reset,
	input wire descrambler_reset,
	output wire [71:0] decoder_data_out,
	input wire RX_CLK,
	input wire rx_test_mode,
	output reg [15:0] test_pattern_error_count,
	output wire PCS_status,
	output wire hi_ber, //signal from BER module
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

reg [1:0] lane_mapping_0_sig,lane_mapping_1_sig,lane_mapping_2_sig,lane_mapping_3_sig;

reg [15:0] bip_counter_lane_0_reg,bip_counter_lane_1_reg,bip_counter_lane_2_reg,bip_counter_lane_3_reg,
           bip_counter_lane_0_reg_next,bip_counter_lane_1_reg_next,bip_counter_lane_2_reg_next,
			  bip_counter_lane_3_reg_next;

reg [1:0] RX_CLK_lane_mapping_0_sig1,RX_CLK_lane_mapping_1_sig1,RX_CLK_lane_mapping_2_sig1,RX_CLK_lane_mapping_3_sig1,
           RX_CLK_lane_mapping_0_sig2,RX_CLK_lane_mapping_1_sig2,RX_CLK_lane_mapping_2_sig2,RX_CLK_lane_mapping_3_sig2;

reg [15:0] test_pattern_error_count_next;

reg RX_CLK_lane0_am_lock_sig2,RX_CLK_lane0_am_lock_sig1,
    RX_CLK_lane1_am_lock_sig2,RX_CLK_lane1_am_lock_sig1,
	 RX_CLK_lane2_am_lock_sig2,RX_CLK_lane2_am_lock_sig1,
	 RX_CLK_lane3_am_lock_sig2,RX_CLK_lane3_am_lock_sig1;
	 
reg [15:0] RX_CLK_bip_counter_lane_0_reg2,RX_CLK_bip_counter_lane_0_reg1,
    RX_CLK_bip_counter_lane_1_reg2,RX_CLK_bip_counter_lane_1_reg1,
    RX_CLK_bip_counter_lane_2_reg2,RX_CLK_bip_counter_lane_2_reg1,
    RX_CLK_bip_counter_lane_3_reg2,RX_CLK_bip_counter_lane_3_reg1;	 

localparam MARKER = {56'b0,8'h33,2'b01,56'b0,8'h33,2'b01,56'b0,8'h33,2'b01,56'b0,8'h33,2'b01};
localparam IDLE = {56'b0,8'h1E,2'b01,56'b0,8'h1E,2'b01,56'b0,8'h1E,2'b01,56'b0,8'h1E,2'b01};
localparam MARKER_0 = {56'b0,8'h55,2'b01,56'b0,8'h55,2'b01,56'b0,8'h55,2'b01,56'b0,8'h55,2'b01};

wire [65:0] Lane_0_out,Lane_1_out,Lane_2_out,Lane_3_out;

reg [4:0] i;
reg deskew_delay[29:0];

reg RX_CLK_lane0_block_locked_signal2,RX_CLK_lane0_block_locked_signal1,
    RX_CLK_lane1_block_locked_signal2,RX_CLK_lane1_block_locked_signal1,
	 RX_CLK_lane2_block_locked_signal2,RX_CLK_lane2_block_locked_signal1,
	 RX_CLK_lane3_block_locked_signal2,RX_CLK_lane3_block_locked_signal1;

wire  BIP3_Lane_0_bit_0_temp,BIP3_Lane_0_bit_1_temp,BIP3_Lane_0_bit_2_temp,BIP3_Lane_0_bit_3_temp
     ,BIP3_Lane_0_bit_4_temp,BIP3_Lane_0_bit_5_temp,BIP3_Lane_0_bit_6_temp,BIP3_Lane_0_bit_7_temp
	  ,BIP3_Lane_1_bit_0_temp,BIP3_Lane_1_bit_1_temp,BIP3_Lane_1_bit_2_temp,BIP3_Lane_1_bit_3_temp
	  ,BIP3_Lane_1_bit_4_temp,BIP3_Lane_1_bit_5_temp,BIP3_Lane_1_bit_6_temp,BIP3_Lane_1_bit_7_temp
	  ,BIP3_Lane_2_bit_0_temp,BIP3_Lane_2_bit_1_temp,BIP3_Lane_2_bit_2_temp,BIP3_Lane_2_bit_3_temp
	  ,BIP3_Lane_2_bit_4_temp,BIP3_Lane_2_bit_5_temp,BIP3_Lane_2_bit_6_temp,BIP3_Lane_2_bit_7_temp
	  ,BIP3_Lane_3_bit_0_temp,BIP3_Lane_3_bit_1_temp,BIP3_Lane_3_bit_2_temp,BIP3_Lane_3_bit_3_temp
	  ,BIP3_Lane_3_bit_4_temp,BIP3_Lane_3_bit_5_temp,BIP3_Lane_3_bit_6_temp,BIP3_Lane_3_bit_7_temp
	  
     ,BIP3_Lane_0_bit_0_temp_1,BIP3_Lane_0_bit_1_temp_1,BIP3_Lane_0_bit_2_temp_1,BIP3_Lane_0_bit_3_temp_1
     ,BIP3_Lane_0_bit_4_temp_1,BIP3_Lane_0_bit_5_temp_1,BIP3_Lane_0_bit_6_temp_1,BIP3_Lane_0_bit_7_temp_1
	  ,BIP3_Lane_1_bit_0_temp_1,BIP3_Lane_1_bit_1_temp_1,BIP3_Lane_1_bit_2_temp_1,BIP3_Lane_1_bit_3_temp_1
	  ,BIP3_Lane_1_bit_4_temp_1,BIP3_Lane_1_bit_5_temp_1,BIP3_Lane_1_bit_6_temp_1,BIP3_Lane_1_bit_7_temp_1
	  ,BIP3_Lane_2_bit_0_temp_1,BIP3_Lane_2_bit_1_temp_1,BIP3_Lane_2_bit_2_temp_1,BIP3_Lane_2_bit_3_temp_1
	  ,BIP3_Lane_2_bit_4_temp_1,BIP3_Lane_2_bit_5_temp_1,BIP3_Lane_2_bit_6_temp_1,BIP3_Lane_2_bit_7_temp_1
	  ,BIP3_Lane_3_bit_0_temp_1,BIP3_Lane_3_bit_1_temp_1,BIP3_Lane_3_bit_2_temp_1,BIP3_Lane_3_bit_3_temp_1
	  ,BIP3_Lane_3_bit_4_temp_1,BIP3_Lane_3_bit_5_temp_1,BIP3_Lane_3_bit_6_temp_1,BIP3_Lane_3_bit_7_temp_1;
	  
reg [7:0] BIP3_Lane_0,BIP3_Lane_1,BIP3_Lane_2,BIP3_Lane_3,BIP3_Lane_0_next,
          BIP3_Lane_1_next,BIP3_Lane_2_next,BIP3_Lane_3_next;	  

reg lane0_block_locked_signal2,lane0_block_locked_signal1,
    lane1_block_locked_signal2,lane1_block_locked_signal1,
    lane2_block_locked_signal2,lane2_block_locked_signal1,
    lane3_block_locked_signal2,lane3_block_locked_signal1;
	 
reg [263:0] MARKER_0_insertion_buffer_0,MARKER_0_insertion_buffer_1,
           MARKER_0_insertion_buffer_2,MARKER_0_insertion_buffer_2_next;	

reg [263:0] FIFO_data_out_Marker_0_removed; 			  
	 
wire lane0_block_locked_signal,lane1_block_locked_signal,lane2_block_locked_signal,
  lane3_block_locked_signal;
wire [65:0] lane0_block_locked_out,lane1_block_locked_out,lane2_block_locked_out,
  lane3_block_locked_out;	 

wire [65:0] lane0_fifo_out,lane1_fifo_out,lane2_fifo_out,lane3_fifo_out;

reg [263:0] marker_insertion_buffer_0,marker_insertion_buffer_1,marker_insertion_buffer_2,
            marker_insertion_buffer_3,next_marker_insertion_buffer_1,next_marker_insertion_buffer_2;

wire deskew_done;
reg deskew_done_1,deskew_done_2;
				
reg RX_CLK_DIV4 = 0;	
reg [1:0] clk_dev_cnt = 0;	
reg [263:0]	redistribution_reg;											
wire read_empty_sig;
wire [263:0] FIFO_data_out;	
		
reg am_status;
wire is_am;
reg am_detected_0,am_detected_1;
reg descramble_control,descramble_control_next;
reg descrambler_en;

reg winc;

reg [263:0] marker_removal_buffer_0,marker_removal_buffer_1,marker_removal_buffer_2,marker_removal_buffer_3,
            marker_removal_buffer_4,next_marker_removal_buffer_0,next_marker_removal_buffer_1,
				next_marker_removal_buffer_2,next_marker_removal_buffer_3,next_marker_removal_buffer_4;
	
reg marker_removal_state,next_marker_removal_state;
reg [1:0] marker_removal_counter,next_marker_removal_counter; 
	
reg idle_transmitted;

wire [263:0] descrambler_out;
reg [263:0] descrambler_in;

reg [263:0] lane_reordered_0,lane_reordered_1; //lane_reordered_0[263:198] is lane0_reorderedwire [65:0] lane0_fifo_out,lane1_fifo_out,lane2_fifo_out,lane3_fifo_out;  

wire [65:0] lane0_deskewed,lane1_deskewed,lane2_deskewed,lane3_deskewed;
  
wire lane0_am_lock_sig,lane1_am_lock_sig,lane2_am_lock_sig,lane3_am_lock_sig;

wire [7:0] lane0_mapping,lane1_mapping,lane2_mapping,lane3_mapping;

reg [65:0] lane0_data_synced,lane1_data_synced,lane2_data_synced,lane3_data_synced;
	 	
wire [13:0] lane0_am_counter_out,lane1_am_counter_out,
            lane2_am_counter_out,lane3_am_counter_out;	

reg [65:0] lane0_reordered,lane1_reordered,lane2_reordered,lane3_reordered;				

always@(posedge lane0_clk,negedge reset) //lane0_clk is used as the receiver clock
begin
	if(~reset) begin
      lane0_data_synced <= 66'b0;
		lane1_data_synced <= 66'b0;
		lane2_data_synced <= 66'b0;
		lane3_data_synced <= 66'b0;
		{am_detected_1,am_detected_0} <= 0;
		lane_reordered_0 <= 0;
		lane_reordered_1 <= 0;
		descramble_control <= 0;
		marker_insertion_buffer_0 <= 0;
		marker_insertion_buffer_1 <= 0;
		marker_insertion_buffer_2 <= 0;
		MARKER_0_insertion_buffer_0 <= 0;
		MARKER_0_insertion_buffer_1 <= 0;
		MARKER_0_insertion_buffer_2 <= 0; 
      BIP3_Lane_0 <= 0;
	   BIP3_Lane_1 <= 0;
	   BIP3_Lane_2 <= 0;
	   BIP3_Lane_3 <= 0;	
	end else begin	
      lane0_data_synced <= lane0_fifo_out;
		lane1_data_synced <= lane1_fifo_out;
		lane2_data_synced <= lane2_fifo_out;
		lane3_data_synced <= lane3_fifo_out;	
		{am_detected_1,am_detected_0} <= {am_detected_0,is_am};
		lane_reordered_0 <= {lane0_reordered,lane1_reordered,lane2_reordered,lane3_reordered};
		lane_reordered_1 <= lane_reordered_0;
      descramble_control <= descramble_control_next;	
		marker_insertion_buffer_0 <= MARKER_0_insertion_buffer_2;
		marker_insertion_buffer_1 <= next_marker_insertion_buffer_1;
		marker_insertion_buffer_2 <= next_marker_insertion_buffer_2;	
		MARKER_0_insertion_buffer_0 <= descrambler_out;
		MARKER_0_insertion_buffer_1 <= MARKER_0_insertion_buffer_0;
		MARKER_0_insertion_buffer_2 <= MARKER_0_insertion_buffer_2_next;		      
		BIP3_Lane_0 <= BIP3_Lane_0_next;
	   BIP3_Lane_1 <= BIP3_Lane_1_next;
	   BIP3_Lane_2 <= BIP3_Lane_2_next;
	   BIP3_Lane_3 <= BIP3_Lane_3_next;
	end	
end

always@* begin
   if(MARKER_0_insertion_buffer_0 != IDLE && MARKER_0_insertion_buffer_2 != IDLE &&
	   MARKER_0_insertion_buffer_1 == IDLE)
		MARKER_0_insertion_buffer_2_next = MARKER_0;
   else
      MARKER_0_insertion_buffer_2_next = MARKER_0_insertion_buffer_1;	
end

always@* begin
   if(FIFO_data_out == MARKER_0)
	   FIFO_data_out_Marker_0_removed = IDLE;
	else
      FIFO_data_out_Marker_0_removed = FIFO_data_out;	
end

always@(posedge lane0_clk,negedge reset) //lane0_clk is used as the receiver clock
begin
	if(~reset || deskew_done == 0) begin
     for(i=0;i<30;i = i + 1) begin
	     deskew_delay[i] <= 0;
	  end
	end else begin	
     for(i=1;i<30;i = i + 1) begin
	     deskew_delay[i] <= deskew_delay[i-1];
	  end
	  deskew_delay[0] <= deskew_done;
	end
end

//signal synchronization  	
always @(posedge RX_CLK_DIV4,negedge reset)
begin
  if (!reset) begin 
	 {deskew_done_2,deskew_done_1} <= 0;
  end	 
  else begin
	 {deskew_done_2,deskew_done_1} <= {deskew_done_1,deskew_delay[29]};
  end	 
end

always @(posedge lane0_clk or negedge reset)
begin
  if (!reset) begin 
    {lane0_block_locked_signal2,lane0_block_locked_signal1} <= 0;
	 {lane1_block_locked_signal2,lane1_block_locked_signal1} <= 0;
	 {lane2_block_locked_signal2,lane2_block_locked_signal1} <= 0;
	 {lane3_block_locked_signal2,lane3_block_locked_signal1} <= 0;
  end	 
  else begin
    {lane0_block_locked_signal2,lane0_block_locked_signal1} <= {lane0_block_locked_signal1,lane0_block_locked_signal};
	 {lane1_block_locked_signal2,lane1_block_locked_signal1} <= {lane1_block_locked_signal1,lane1_block_locked_signal};
	 {lane2_block_locked_signal2,lane2_block_locked_signal1} <= {lane2_block_locked_signal1,lane2_block_locked_signal};
	 {lane3_block_locked_signal2,lane3_block_locked_signal1} <= {lane3_block_locked_signal1,lane3_block_locked_signal};
  end	 
end
///////////////////

//am_status generation
always@*
begin
   if(lane0_am_lock_sig == 1 && lane1_am_lock_sig == 1 &&
	   lane2_am_lock_sig == 1 && lane3_am_lock_sig == 1)
		am_status = 1;
	else
    	am_status = 0;
end
////////////

//lane reordering
always@*
begin
   case({lane0_mapping,lane1_mapping,lane2_mapping,lane3_mapping}) 
	   32'h90F0C5A2: begin
		   lane0_reordered = lane0_deskewed;
			lane1_reordered = lane1_deskewed;
			lane2_reordered = lane2_deskewed;
			lane3_reordered = lane3_deskewed;
      end

	   32'h90F0A2C5: begin
		   lane0_reordered = lane0_deskewed;
			lane1_reordered = lane1_deskewed;
			lane2_reordered = lane3_deskewed;
			lane3_reordered = lane2_deskewed;
      end

	   32'h90A2C5F0: begin
		   lane0_reordered = lane0_deskewed;
			lane1_reordered = lane3_deskewed;
			lane2_reordered = lane2_deskewed;
			lane3_reordered = lane1_deskewed;
      end

	   32'h90A2F0C5: begin
		   lane0_reordered = lane0_deskewed;
			lane1_reordered = lane2_deskewed;
			lane2_reordered = lane3_deskewed;
			lane3_reordered = lane1_deskewed;
      end

	   32'h90C5F0A2: begin
		   lane0_reordered = lane0_deskewed;
			lane1_reordered = lane2_deskewed;
			lane2_reordered = lane1_deskewed;
			lane3_reordered = lane3_deskewed;
      end

	   32'h90C5A2F0: begin
		   lane0_reordered = lane0_deskewed;
			lane1_reordered = lane3_deskewed;
			lane2_reordered = lane1_deskewed;
			lane3_reordered = lane2_deskewed;
      end

	   32'hF090C5A2: begin
		   lane0_reordered = lane1_deskewed;
			lane1_reordered = lane0_deskewed;
			lane2_reordered = lane2_deskewed;
			lane3_reordered = lane3_deskewed;
      end

	   32'hF090A2C5: begin
		   lane0_reordered = lane1_deskewed;
			lane1_reordered = lane0_deskewed;
			lane2_reordered = lane3_deskewed;
			lane3_reordered = lane2_deskewed;
      end

	   32'hF0C590A2: begin
		   lane0_reordered = lane2_deskewed;
			lane1_reordered = lane0_deskewed;
			lane2_reordered = lane1_deskewed;
			lane3_reordered = lane3_deskewed;
      end

	   32'hF0C5A290: begin
		   lane0_reordered = lane3_deskewed;
			lane1_reordered = lane0_deskewed;
			lane2_reordered = lane1_deskewed;
			lane3_reordered = lane2_deskewed;
      end	

	   32'hF0A2C590: begin
		   lane0_reordered = lane3_deskewed;
			lane1_reordered = lane0_deskewed;
			lane2_reordered = lane2_deskewed;
			lane3_reordered = lane1_deskewed;
      end

	   32'hF0A290C5: begin
		   lane0_reordered = lane2_deskewed;
			lane1_reordered = lane0_deskewed;
			lane2_reordered = lane3_deskewed;
			lane3_reordered = lane1_deskewed;
      end

	   32'hA2F0C590: begin
		   lane0_reordered = lane3_deskewed;
			lane1_reordered = lane1_deskewed;
			lane2_reordered = lane2_deskewed;
			lane3_reordered = lane0_deskewed;
      end

	   32'hA2F090C5: begin
		   lane0_reordered = lane2_deskewed;
			lane1_reordered = lane1_deskewed;
			lane2_reordered = lane3_deskewed;
			lane3_reordered = lane0_deskewed;
      end

	   32'hA2C5F090: begin
		   lane0_reordered = lane3_deskewed;
			lane1_reordered = lane2_deskewed;
			lane2_reordered = lane1_deskewed;
			lane3_reordered = lane0_deskewed;
      end

	   32'hA2C590F0: begin
		   lane0_reordered = lane2_deskewed;
			lane1_reordered = lane3_deskewed;
			lane2_reordered = lane1_deskewed;
			lane3_reordered = lane0_deskewed;
      end

	   32'hA290C5F0: begin
		   lane0_reordered = lane1_deskewed;
			lane1_reordered = lane3_deskewed;
			lane2_reordered = lane2_deskewed;
			lane3_reordered = lane0_deskewed;
      end

	   32'hA290F0C5: begin
		   lane0_reordered = lane1_deskewed;
			lane1_reordered = lane2_deskewed;
			lane2_reordered = lane3_deskewed;
			lane3_reordered = lane0_deskewed;
      end

	   32'hC5F090A2: begin
		   lane0_reordered = lane2_deskewed;
			lane1_reordered = lane1_deskewed;
			lane2_reordered = lane0_deskewed;
			lane3_reordered = lane3_deskewed;
      end

	   32'hC5F0A290: begin
		   lane0_reordered = lane3_deskewed;
			lane1_reordered = lane1_deskewed;
			lane2_reordered = lane0_deskewed;
			lane3_reordered = lane2_deskewed;
      end

	   32'hC590F0A2: begin
		   lane0_reordered = lane1_deskewed;
			lane1_reordered = lane2_deskewed;
			lane2_reordered = lane0_deskewed;
			lane3_reordered = lane3_deskewed;
      end

	   32'hC590A2F0: begin
		   lane0_reordered = lane1_deskewed;
			lane1_reordered = lane3_deskewed;
			lane2_reordered = lane0_deskewed;
			lane3_reordered = lane2_deskewed;
      end

	   32'hC5A290F0: begin
		   lane0_reordered = lane2_deskewed;
			lane1_reordered = lane3_deskewed;
			lane2_reordered = lane0_deskewed;
			lane3_reordered = lane1_deskewed;
      end

	   32'hC5A2F090: begin
		   lane0_reordered = lane3_deskewed;
			lane1_reordered = lane2_deskewed;
			lane2_reordered = lane0_deskewed;
			lane3_reordered = lane1_deskewed;
      end
       
      default: begin
		   lane0_reordered = lane0_deskewed;
			lane1_reordered = lane1_deskewed;
			lane2_reordered = lane2_deskewed;
			lane3_reordered = lane3_deskewed;		
      end		
   endcase	
end
////////////

//alignment marker removal and descrambling

//idle_transmitted signal generation
always@* begin
   if(descrambler_out == {56'b0,8'h1E,2'b01,56'b0,8'h1E,2'b01,56'b0,8'h1E,2'b01,56'b0,8'h1E,2'b01})
	   idle_transmitted = 1;
   else
      idle_transmitted = 0; 	
end
///////

always@* begin
   if(idle_transmitted == 1 && descramble_control == 1) begin
	   descrambler_en = 0; 
		descrambler_in = lane_reordered_1;
		descramble_control_next = 0;
	end else if(descramble_control == 1)begin
	   descrambler_en = 1; 
		descrambler_in = lane_reordered_0;
		descramble_control_next = descramble_control;	
   end else if(am_detected_1 == 1) begin
	   descrambler_en = 1; 
		descrambler_in = lane_reordered_0;
		descramble_control_next = 1;	   
   end else begin
	   descrambler_en = 1;  
		descrambler_in = lane_reordered_1;
		descramble_control_next = descramble_control;	   
   end			   
end

//////////////////////////

//Domain change

//MARKER insertion
always@* begin
   if(marker_insertion_buffer_1 == IDLE && 
	   marker_insertion_buffer_0 != IDLE) begin
      next_marker_insertion_buffer_1 = marker_insertion_buffer_0;
		next_marker_insertion_buffer_2 = MARKER;
   end 
	else if(marker_insertion_buffer_0 == IDLE && marker_insertion_buffer_1 != IDLE && 
	        marker_insertion_buffer_1 != MARKER) begin
      next_marker_insertion_buffer_1 = MARKER;
		next_marker_insertion_buffer_2 = marker_insertion_buffer_1;	
	end else begin
      next_marker_insertion_buffer_1 = marker_insertion_buffer_0;
		next_marker_insertion_buffer_2 = marker_insertion_buffer_1;		
	end
end
//////////

//MARKER removal and idle insertion
always@* begin
 case(marker_removal_counter)
  2'b00: begin 
   if(marker_removal_buffer_0 != MARKER && marker_removal_state == 0) begin
	   if(read_empty_sig) begin
	      next_marker_removal_buffer_0 = IDLE;
			next_marker_removal_buffer_1 = marker_removal_buffer_0;
			next_marker_removal_buffer_2 = marker_removal_buffer_1;
			next_marker_removal_buffer_3 = marker_removal_buffer_2;
			next_marker_removal_buffer_4 = marker_removal_buffer_3;
         next_marker_removal_counter = 2'b00;
         next_marker_removal_state = marker_removal_state;			
		end 
		else begin
	      next_marker_removal_buffer_0 = FIFO_data_out_Marker_0_removed;
			next_marker_removal_buffer_1 = marker_removal_buffer_0;
			next_marker_removal_buffer_2 = marker_removal_buffer_1;
			next_marker_removal_buffer_3 = marker_removal_buffer_2;
			next_marker_removal_buffer_4 = marker_removal_buffer_3;	
         next_marker_removal_counter = 2'b00;
         next_marker_removal_state = marker_removal_state;			
    	end	
	end
	else if(marker_removal_buffer_0 == MARKER && marker_removal_state == 0) begin
	   if(read_empty_sig) begin
	      next_marker_removal_buffer_0 = IDLE;
			next_marker_removal_buffer_1 = IDLE;
			next_marker_removal_buffer_2 = marker_removal_buffer_1;
			next_marker_removal_buffer_3 = marker_removal_buffer_2;
			next_marker_removal_buffer_4 = marker_removal_buffer_3;	
         next_marker_removal_counter = 2'b01;
         next_marker_removal_state = 1;			
		end 
		else begin
	      next_marker_removal_buffer_0 = FIFO_data_out_Marker_0_removed;
			next_marker_removal_buffer_1 = IDLE;
			next_marker_removal_buffer_2 = marker_removal_buffer_1;
			next_marker_removal_buffer_3 = marker_removal_buffer_2;
			next_marker_removal_buffer_4 = marker_removal_buffer_3;
         next_marker_removal_counter = 2'b00;
         next_marker_removal_state = 1;		   
    	end	
	end
	else if(marker_removal_buffer_0 == MARKER && marker_removal_state == 1) begin
	   if(read_empty_sig) begin
	      next_marker_removal_buffer_0 = IDLE;
			next_marker_removal_buffer_1 = IDLE;
			next_marker_removal_buffer_2 = marker_removal_buffer_1;
			next_marker_removal_buffer_3 = marker_removal_buffer_2;
			next_marker_removal_buffer_4 = marker_removal_buffer_3;
         next_marker_removal_counter = 2'b00;
         next_marker_removal_state = 0;			
		end 
		else begin
	      next_marker_removal_buffer_0 = FIFO_data_out_Marker_0_removed;
			next_marker_removal_buffer_1 = IDLE;
			next_marker_removal_buffer_2 = marker_removal_buffer_1;
			next_marker_removal_buffer_3 = marker_removal_buffer_2;	
			next_marker_removal_buffer_4 = marker_removal_buffer_3;
         next_marker_removal_counter = 2'b00;
         next_marker_removal_state = 0;			
    	end	
	end
	else begin
	   if(read_empty_sig) begin
	      next_marker_removal_buffer_0 = IDLE;
			next_marker_removal_buffer_1 = marker_removal_buffer_0;
			next_marker_removal_buffer_2 = marker_removal_buffer_1;
			next_marker_removal_buffer_3 = marker_removal_buffer_2;
			next_marker_removal_buffer_4 = marker_removal_buffer_3;
         next_marker_removal_counter = 2'b01;
         next_marker_removal_state = marker_removal_state;			
		end 
		else begin
	      next_marker_removal_buffer_0 = FIFO_data_out_Marker_0_removed;
			next_marker_removal_buffer_1 = marker_removal_buffer_0;
			next_marker_removal_buffer_2 = marker_removal_buffer_1;
			next_marker_removal_buffer_3 = marker_removal_buffer_2;	
			next_marker_removal_buffer_4 = marker_removal_buffer_3;
         next_marker_removal_counter = 2'b00;
         next_marker_removal_state = marker_removal_state;				
    	end	
	end
  end

  2'b01: begin 
   if(marker_removal_buffer_1 != MARKER && marker_removal_state == 0) begin
	   if(read_empty_sig) begin
		   next_marker_removal_buffer_0 = IDLE;
	      next_marker_removal_buffer_1 = IDLE;
			next_marker_removal_buffer_2 = marker_removal_buffer_1;
			next_marker_removal_buffer_3 = marker_removal_buffer_2;
			next_marker_removal_buffer_4 = marker_removal_buffer_3;
         next_marker_removal_counter = 2'b00;
         next_marker_removal_state = marker_removal_state;			
		end 
		else begin
	      next_marker_removal_buffer_0 = FIFO_data_out_Marker_0_removed;
			next_marker_removal_buffer_1 = marker_removal_buffer_0;
			next_marker_removal_buffer_2 = marker_removal_buffer_1;
			next_marker_removal_buffer_3 = marker_removal_buffer_2;
			next_marker_removal_buffer_4 = marker_removal_buffer_3;	
         next_marker_removal_counter = 2'b00;
         next_marker_removal_state = marker_removal_state;			
    	end	
	end
	else if(marker_removal_buffer_1 == MARKER && marker_removal_state == 1) begin
	   if(read_empty_sig) begin
	      next_marker_removal_buffer_0 = IDLE;
			next_marker_removal_buffer_1 = IDLE;
			next_marker_removal_buffer_2 = IDLE;
			next_marker_removal_buffer_3 = marker_removal_buffer_2;
			next_marker_removal_buffer_4 = marker_removal_buffer_3;
         next_marker_removal_counter = 2'b00;
         next_marker_removal_state = 0;			
		end 
		else begin
	      next_marker_removal_buffer_0 = FIFO_data_out_Marker_0_removed;
			next_marker_removal_buffer_1 = IDLE;
			next_marker_removal_buffer_2 = IDLE;
			next_marker_removal_buffer_3 = marker_removal_buffer_2;	
			next_marker_removal_buffer_4 = marker_removal_buffer_3;
         next_marker_removal_counter = 2'b00;
         next_marker_removal_state = 0;			
    	end	
	end
	else begin
	   if(read_empty_sig) begin
	      next_marker_removal_buffer_0 = IDLE;
			next_marker_removal_buffer_1 = IDLE;
			next_marker_removal_buffer_2 = marker_removal_buffer_1;
			next_marker_removal_buffer_3 = marker_removal_buffer_2;
			next_marker_removal_buffer_4 = marker_removal_buffer_3;
         next_marker_removal_counter = 2'b10;
         next_marker_removal_state = marker_removal_state;			
		end 
		else begin
	      next_marker_removal_buffer_0 = IDLE;
			next_marker_removal_buffer_1 = FIFO_data_out_Marker_0_removed;
			next_marker_removal_buffer_2 = marker_removal_buffer_1;
			next_marker_removal_buffer_3 = marker_removal_buffer_2;	
			next_marker_removal_buffer_4 = marker_removal_buffer_3;
         next_marker_removal_counter = 2'b01;
         next_marker_removal_state = marker_removal_state;				
    	end	
	end
  end
 
  2'b10: begin 
   if(marker_removal_buffer_2 != MARKER && marker_removal_state == 0) begin
	   if(read_empty_sig) begin
		   next_marker_removal_buffer_0 = IDLE;
	      next_marker_removal_buffer_1 = IDLE;
			next_marker_removal_buffer_2 = IDLE;
			next_marker_removal_buffer_3 = marker_removal_buffer_2;
			next_marker_removal_buffer_4 = marker_removal_buffer_3;
         next_marker_removal_counter = 2'b00;
         next_marker_removal_state = marker_removal_state;			
		end 
		else begin
	      next_marker_removal_buffer_0 = FIFO_data_out_Marker_0_removed;
			next_marker_removal_buffer_1 = marker_removal_buffer_0;
			next_marker_removal_buffer_2 = marker_removal_buffer_1;
			next_marker_removal_buffer_3 = marker_removal_buffer_2;
			next_marker_removal_buffer_4 = marker_removal_buffer_3;	
         next_marker_removal_counter = 2'b00;
         next_marker_removal_state = marker_removal_state;			
    	end	
	end
	else if(marker_removal_buffer_2 == MARKER && marker_removal_state == 1) begin
	   if(read_empty_sig) begin
	      next_marker_removal_buffer_0 = IDLE;
			next_marker_removal_buffer_1 = IDLE;
			next_marker_removal_buffer_2 = IDLE;
			next_marker_removal_buffer_3 = IDLE;
			next_marker_removal_buffer_4 = marker_removal_buffer_3;
         next_marker_removal_counter = 2'b00;
         next_marker_removal_state = 0;			
		end 
		else begin
	      next_marker_removal_buffer_0 = FIFO_data_out_Marker_0_removed;
			next_marker_removal_buffer_1 = IDLE;
			next_marker_removal_buffer_2 = IDLE;
			next_marker_removal_buffer_3 = IDLE;	
			next_marker_removal_buffer_4 = marker_removal_buffer_3;
         next_marker_removal_counter = 2'b00;
         next_marker_removal_state = 0;			
    	end	
	end
	else begin
	   if(read_empty_sig) begin
	      next_marker_removal_buffer_0 = IDLE;
			next_marker_removal_buffer_1 = IDLE;
			next_marker_removal_buffer_2 = IDLE;
			next_marker_removal_buffer_3 = marker_removal_buffer_2;
			next_marker_removal_buffer_4 = marker_removal_buffer_3;
         next_marker_removal_counter = 2'b11;
         next_marker_removal_state = marker_removal_state;			
		end 
		else begin
	      next_marker_removal_buffer_0 = IDLE;
			next_marker_removal_buffer_1 = IDLE;
			next_marker_removal_buffer_2 = FIFO_data_out_Marker_0_removed;
			next_marker_removal_buffer_3 = marker_removal_buffer_2;	
			next_marker_removal_buffer_4 = marker_removal_buffer_3;
         next_marker_removal_counter = 2'b10;
         next_marker_removal_state = marker_removal_state;				
    	end	
	end
  end 
  
  2'b11: begin 
   if(marker_removal_buffer_3 != MARKER && marker_removal_state == 0) begin
	   if(read_empty_sig) begin
		   next_marker_removal_buffer_0 = IDLE;
	      next_marker_removal_buffer_1 = IDLE;
			next_marker_removal_buffer_2 = IDLE;
			next_marker_removal_buffer_3 = IDLE;
			next_marker_removal_buffer_4 = marker_removal_buffer_3;
         next_marker_removal_counter = 2'b00;
         next_marker_removal_state = marker_removal_state;			
		end 
		else begin
	      next_marker_removal_buffer_0 = FIFO_data_out_Marker_0_removed;
			next_marker_removal_buffer_1 = marker_removal_buffer_0;
			next_marker_removal_buffer_2 = marker_removal_buffer_1;
			next_marker_removal_buffer_3 = marker_removal_buffer_2;
			next_marker_removal_buffer_4 = marker_removal_buffer_3;	
         next_marker_removal_counter = 2'b00;
         next_marker_removal_state = marker_removal_state;			
    	end	
	end
	else if(marker_removal_buffer_3 == MARKER && marker_removal_state == 1) begin
	   if(read_empty_sig) begin
	      next_marker_removal_buffer_0 = IDLE;
			next_marker_removal_buffer_1 = IDLE;
			next_marker_removal_buffer_2 = IDLE;
			next_marker_removal_buffer_3 = IDLE;
			next_marker_removal_buffer_4 = IDLE;
         next_marker_removal_counter = 2'b00;
         next_marker_removal_state = 0;			
		end 
		else begin
	      next_marker_removal_buffer_0 = FIFO_data_out_Marker_0_removed;
			next_marker_removal_buffer_1 = IDLE;
			next_marker_removal_buffer_2 = IDLE;
			next_marker_removal_buffer_3 = IDLE;	
			next_marker_removal_buffer_4 = IDLE;
         next_marker_removal_counter = 2'b00;
         next_marker_removal_state = 0;			
    	end	
	end
	else begin
	   if(read_empty_sig) begin //error situation //exceeds buffer limit
	      next_marker_removal_buffer_0 = IDLE;
			next_marker_removal_buffer_1 = IDLE;
			next_marker_removal_buffer_2 = IDLE;
			next_marker_removal_buffer_3 = IDLE;
			next_marker_removal_buffer_4 = marker_removal_buffer_3;
         next_marker_removal_counter = 2'b00;
         next_marker_removal_state = marker_removal_state;			
		end 
		else begin
	      next_marker_removal_buffer_0 = IDLE;
			next_marker_removal_buffer_1 = IDLE;
			next_marker_removal_buffer_2 = IDLE;
			next_marker_removal_buffer_3 = FIFO_data_out_Marker_0_removed;	
			next_marker_removal_buffer_4 = marker_removal_buffer_3;
         next_marker_removal_counter = 2'b11;
         next_marker_removal_state = marker_removal_state;				
    	end	
	end
  end  

  default: begin
	      next_marker_removal_buffer_0 = IDLE;
			next_marker_removal_buffer_1 = IDLE;
			next_marker_removal_buffer_2 = IDLE;
			next_marker_removal_buffer_3 = IDLE;	
			next_marker_removal_buffer_4 = IDLE;
         next_marker_removal_counter = 2'b00;
         next_marker_removal_state = 0;	   
  end  
 endcase  
end
//////////

//RX_CLK domain 
always@(posedge RX_CLK_DIV4,negedge reset) 
begin
	if(~reset) begin
	      marker_removal_buffer_0 = 0;
			marker_removal_buffer_1 = 0;
			marker_removal_buffer_2 = 0;
			marker_removal_buffer_3 = 0;	
			marker_removal_buffer_4 = 0;
         marker_removal_counter = 0;
         marker_removal_state = 0;
	end else begin	
	      marker_removal_buffer_0 = next_marker_removal_buffer_0;
			marker_removal_buffer_1 = next_marker_removal_buffer_1;
			marker_removal_buffer_2 = next_marker_removal_buffer_2;
			marker_removal_buffer_3 = next_marker_removal_buffer_3;	
			marker_removal_buffer_4 = next_marker_removal_buffer_4;
         marker_removal_counter = next_marker_removal_counter;
         marker_removal_state = next_marker_removal_state;	
	end	
end
/////////

always@* begin
   if(marker_insertion_buffer_2 == IDLE) 
      winc = 0;
   else
      winc = 1;	
end

//////////////////////////

//RX_CLK_DIV4 generation and lane redistribution 
always@(posedge RX_CLK) begin	
   clk_dev_cnt <= clk_dev_cnt + 2'b01;
	
	if(clk_dev_cnt == 2'b11)
	   redistribution_reg <= marker_removal_buffer_4;
   else begin
      redistribution_reg[263:198] <= redistribution_reg[197:132];
		redistribution_reg[197:132] <= redistribution_reg[131:66];
		redistribution_reg[131:66] <= redistribution_reg[65:0];
		redistribution_reg[65:0] <= redistribution_reg[65:0];
   end		
	
	if(clk_dev_cnt == 2'b11 || clk_dev_cnt == 2'b00)
	   RX_CLK_DIV4 <= 1'b1;
	else
      RX_CLK_DIV4 <= 1'b0;					
end	
//////////

  
fifo lane0_fifo(.wdata(lane0_block_locked_out),.rdata(lane0_fifo_out),
                .winc(1'b1),.rinc(1'b1),.wrst_n(reset),.rrst_n(reset),
					 .wclk(lane0_clk),.rclk(lane0_clk));
					 
fifo lane1_fifo(.wdata(lane1_block_locked_out),.rdata(lane1_fifo_out),
                .winc(1'b1),.rinc(1'b1),.wrst_n(reset),.rrst_n(reset),
					 .wclk(lane1_clk),.rclk(lane0_clk));

fifo lane2_fifo(.wdata(lane2_block_locked_out),.rdata(lane2_fifo_out),
                .winc(1'b1),.rinc(1'b1),.wrst_n(reset),.rrst_n(reset),
					 .wclk(lane2_clk),.rclk(lane0_clk));

fifo lane3_fifo(.wdata(lane3_block_locked_out),.rdata(lane3_fifo_out),
                .winc(1'b1),.rinc(1'b1),.wrst_n(reset),.rrst_n(reset),
					 .wclk(lane3_clk),.rclk(lane0_clk));	

am_lock lane0_am_lock(.clk(lane0_clk),.reset(reset),.data_in({lane0_data_synced[57:34],lane0_data_synced[25:2],
                       lane0_data_synced[1:0]}),
                      .am_lock(lane0_am_lock_sig),.lane_mapping(lane0_mapping),
							 .block_locked_signal(lane0_block_locked_signal2),
							 .am_counter_out(lane0_am_counter_out));					 

am_lock lane1_am_lock(.clk(lane0_clk),.reset(reset),.data_in({lane1_data_synced[57:34],lane1_data_synced[25:2],
                       lane1_data_synced[1:0]}),
                      .am_lock(lane1_am_lock_sig),.lane_mapping(lane1_mapping),
							 .block_locked_signal(lane1_block_locked_signal2),
							 .am_counter_out(lane1_am_counter_out));
							 
am_lock lane2_am_lock(.clk(lane0_clk),.reset(reset),.data_in({lane2_data_synced[57:34],lane2_data_synced[25:2],
                      lane2_data_synced[1:0]}),
                      .am_lock(lane2_am_lock_sig),.lane_mapping(lane2_mapping),
							 .block_locked_signal(lane2_block_locked_signal2),
							 .am_counter_out(lane2_am_counter_out));

am_lock lane3_am_lock(.clk(lane0_clk),.reset(reset),.data_in({lane3_data_synced[57:34],lane3_data_synced[25:2],
                       lane3_data_synced[1:0]}),
                      .am_lock(lane3_am_lock_sig),.lane_mapping(lane3_mapping),
							 .block_locked_signal(lane3_block_locked_signal2),
							 .am_counter_out(lane3_am_counter_out));	

							 
Buffer buffer_module(.lane0_count(lane0_am_counter_out),.lane1_count(lane1_am_counter_out),
                     .lane2_count(lane2_am_counter_out),.lane3_count(lane3_am_counter_out),
							.clk(lane0_clk),.am_status(am_status),.reset(reset),.deskew_done(deskew_done),
							.lane0_data_in(lane0_data_synced),.lane1_data_in(lane1_data_synced),
							.lane2_data_in(lane2_data_synced),.lane3_data_in(lane3_data_synced),
							.lane0_data_out(lane0_deskewed),.lane1_data_out(lane1_deskewed),
							.lane2_data_out(lane2_deskewed),.lane3_data_out(lane3_deskewed),.is_am(is_am));
							
Descrambler descrambler(.data_in(descrambler_in),.data_out(descrambler_out),.clk(lane0_clk),
                        .rst(reset),.descram_en(descrambler_en),.descram_rst(descrambler_reset));
								
								
fifo_top fifo_top(.wdata(marker_insertion_buffer_2),.rdata(FIFO_data_out),.rempty(read_empty_sig),
                  .wrst_n(reset),.rrst_n(reset),.wclk(lane0_clk),
						.rclk(RX_CLK_DIV4),.winc(winc),.rinc(1'b1));
						
decoder decoder(.decoder_in(redistribution_reg[263:198]),.decoder_data_out(decoder_data_out),
                .reset(reset),.RX_CLK(RX_CLK),.deskew_done(deskew_done_2),
					 .errored_block_count(errored_block_count));		


block_lock lane0_block_lock(.reset(reset),.clk(lane0_clk),.data_in(lane0_data),
 .block_locked_signal(lane0_block_locked_signal),.data_out(lane0_block_locked_out));  
 
block_lock lane1_block_lock(.reset(reset),.clk(lane1_clk),.data_in(lane1_data),
 .block_locked_signal(lane1_block_locked_signal),.data_out(lane1_block_locked_out));  

block_lock lane2_block_lock(.reset(reset),.clk(lane2_clk),.data_in(lane2_data),
 .block_locked_signal(lane2_block_locked_signal),.data_out(lane2_block_locked_out));  

block_lock lane3_block_lock(.reset(reset),.clk(lane3_clk),.data_in(lane3_data),
 .block_locked_signal(lane3_block_locked_signal),.data_out(lane3_block_locked_out)); 
 
//lane0_clk to RX_CLK syncronization
always @(posedge RX_CLK or negedge reset)
begin
  if (!reset) begin 
    {RX_CLK_lane0_block_locked_signal2,RX_CLK_lane0_block_locked_signal1} <= 0;
	 {RX_CLK_lane1_block_locked_signal2,RX_CLK_lane1_block_locked_signal1} <= 0;
	 {RX_CLK_lane2_block_locked_signal2,RX_CLK_lane2_block_locked_signal1} <= 0;
	 {RX_CLK_lane3_block_locked_signal2,RX_CLK_lane3_block_locked_signal1} <= 0;
  end	 
  else begin
    {RX_CLK_lane0_block_locked_signal2,RX_CLK_lane0_block_locked_signal1} <= {RX_CLK_lane0_block_locked_signal1,lane0_block_locked_signal2};
	 {RX_CLK_lane1_block_locked_signal2,RX_CLK_lane1_block_locked_signal1} <= {RX_CLK_lane1_block_locked_signal1,lane1_block_locked_signal2};
	 {RX_CLK_lane2_block_locked_signal2,RX_CLK_lane2_block_locked_signal1} <= {RX_CLK_lane2_block_locked_signal1,lane2_block_locked_signal2};
	 {RX_CLK_lane3_block_locked_signal2,RX_CLK_lane3_block_locked_signal1} <= {RX_CLK_lane3_block_locked_signal1,lane3_block_locked_signal2};
  end	 
end

always @(posedge RX_CLK or negedge reset)
begin
  if (!reset) begin 
    {RX_CLK_lane0_am_lock_sig2,RX_CLK_lane0_am_lock_sig1} <= 0;
	 {RX_CLK_lane1_am_lock_sig2,RX_CLK_lane1_am_lock_sig1} <= 0;
	 {RX_CLK_lane2_am_lock_sig2,RX_CLK_lane2_am_lock_sig1} <= 0;
	 {RX_CLK_lane3_am_lock_sig2,RX_CLK_lane3_am_lock_sig1} <= 0;
  end	 
  else begin
    {RX_CLK_lane0_am_lock_sig2,RX_CLK_lane0_am_lock_sig1} <= {RX_CLK_lane0_am_lock_sig1,lane0_am_lock_sig};
	 {RX_CLK_lane1_am_lock_sig2,RX_CLK_lane1_am_lock_sig1} <= {RX_CLK_lane1_am_lock_sig1,lane1_am_lock_sig};
	 {RX_CLK_lane2_am_lock_sig2,RX_CLK_lane2_am_lock_sig1} <= {RX_CLK_lane2_am_lock_sig1,lane2_am_lock_sig};
	 {RX_CLK_lane3_am_lock_sig2,RX_CLK_lane3_am_lock_sig1} <= {RX_CLK_lane3_am_lock_sig1,lane3_am_lock_sig};
  end	 
end

always @(posedge RX_CLK or negedge reset)
begin
  if (!reset) begin 
    {RX_CLK_lane_mapping_0_sig2,RX_CLK_lane_mapping_0_sig1} <= 0;
	 {RX_CLK_lane_mapping_1_sig2,RX_CLK_lane_mapping_1_sig1} <= 0;
	 {RX_CLK_lane_mapping_2_sig2,RX_CLK_lane_mapping_2_sig1} <= 0;
	 {RX_CLK_lane_mapping_3_sig2,RX_CLK_lane_mapping_3_sig1} <= 0;
  end	 
  else begin
    {RX_CLK_lane_mapping_0_sig2,RX_CLK_lane_mapping_0_sig1} <= {RX_CLK_lane_mapping_0_sig1,lane_mapping_0_sig};
	 {RX_CLK_lane_mapping_1_sig2,RX_CLK_lane_mapping_1_sig1} <= {RX_CLK_lane_mapping_1_sig1,lane_mapping_1_sig};
	 {RX_CLK_lane_mapping_2_sig2,RX_CLK_lane_mapping_2_sig1} <= {RX_CLK_lane_mapping_2_sig1,lane_mapping_2_sig};
	 {RX_CLK_lane_mapping_3_sig2,RX_CLK_lane_mapping_3_sig1} <= {RX_CLK_lane_mapping_3_sig1,lane_mapping_3_sig};
  end	 
end

always @(posedge RX_CLK or negedge reset)
begin
  if (!reset) begin 
    {RX_CLK_bip_counter_lane_0_reg2,RX_CLK_bip_counter_lane_0_reg1} <= 0;
	 {RX_CLK_bip_counter_lane_1_reg2,RX_CLK_bip_counter_lane_1_reg1} <= 0;
	 {RX_CLK_bip_counter_lane_2_reg2,RX_CLK_bip_counter_lane_2_reg1} <= 0;
	 {RX_CLK_bip_counter_lane_3_reg2,RX_CLK_bip_counter_lane_3_reg1} <= 0;
  end	 
  else begin
    {RX_CLK_bip_counter_lane_0_reg2,RX_CLK_bip_counter_lane_0_reg1} <= {RX_CLK_bip_counter_lane_0_reg1,bip_counter_lane_0_reg};
	 {RX_CLK_bip_counter_lane_1_reg2,RX_CLK_bip_counter_lane_1_reg1} <= {RX_CLK_bip_counter_lane_1_reg1,bip_counter_lane_1_reg};
	 {RX_CLK_bip_counter_lane_2_reg2,RX_CLK_bip_counter_lane_2_reg1} <= {RX_CLK_bip_counter_lane_2_reg1,bip_counter_lane_2_reg};
	 {RX_CLK_bip_counter_lane_3_reg2,RX_CLK_bip_counter_lane_3_reg1} <= {RX_CLK_bip_counter_lane_3_reg1,bip_counter_lane_3_reg};
  end	 
end
//////  

///BIP
always@* begin
      if(am_detected_1 == 1'b1)
         begin
			   //////////////Lane_0
            BIP3_Lane_0_next[0] = BIP3_Lane_0_bit_0_temp;  
            BIP3_Lane_0_next[1] = BIP3_Lane_0_bit_1_temp;
            BIP3_Lane_0_next[2] = BIP3_Lane_0_bit_2_temp;
            BIP3_Lane_0_next[3] = BIP3_Lane_0_bit_3_temp;
            BIP3_Lane_0_next[4] = BIP3_Lane_0_bit_4_temp;
            BIP3_Lane_0_next[5] = BIP3_Lane_0_bit_5_temp;
            BIP3_Lane_0_next[6] = BIP3_Lane_0_bit_6_temp;
            BIP3_Lane_0_next[7] = BIP3_Lane_0_bit_7_temp; 
            ////////////// 

			   //////////////Lane_1
            BIP3_Lane_1_next[0] = BIP3_Lane_1_bit_0_temp;  
            BIP3_Lane_1_next[1] = BIP3_Lane_1_bit_1_temp;
            BIP3_Lane_1_next[2] = BIP3_Lane_1_bit_2_temp;
            BIP3_Lane_1_next[3] = BIP3_Lane_1_bit_3_temp;
            BIP3_Lane_1_next[4] = BIP3_Lane_1_bit_4_temp;
            BIP3_Lane_1_next[5] = BIP3_Lane_1_bit_5_temp;
            BIP3_Lane_1_next[6] = BIP3_Lane_1_bit_6_temp;
            BIP3_Lane_1_next[7] = BIP3_Lane_1_bit_7_temp; 
            //////////////		

			   //////////////Lane_2
            BIP3_Lane_2_next[0] = BIP3_Lane_2_bit_0_temp;  
            BIP3_Lane_2_next[1] = BIP3_Lane_2_bit_1_temp;
            BIP3_Lane_2_next[2] = BIP3_Lane_2_bit_2_temp;
            BIP3_Lane_2_next[3] = BIP3_Lane_2_bit_3_temp;
            BIP3_Lane_2_next[4] = BIP3_Lane_2_bit_4_temp;
            BIP3_Lane_2_next[5] = BIP3_Lane_2_bit_5_temp;
            BIP3_Lane_2_next[6] = BIP3_Lane_2_bit_6_temp;
            BIP3_Lane_2_next[7] = BIP3_Lane_2_bit_7_temp;  
            ////////////// 

			   //////////////Lane_3
            BIP3_Lane_3_next[0] = BIP3_Lane_3_bit_0_temp;  
            BIP3_Lane_3_next[1] = BIP3_Lane_3_bit_1_temp;
            BIP3_Lane_3_next[2] = BIP3_Lane_3_bit_2_temp;
            BIP3_Lane_3_next[3] = BIP3_Lane_3_bit_3_temp;
            BIP3_Lane_3_next[4] = BIP3_Lane_3_bit_4_temp;
            BIP3_Lane_3_next[5] = BIP3_Lane_3_bit_5_temp;
            BIP3_Lane_3_next[6] = BIP3_Lane_3_bit_6_temp;
            BIP3_Lane_3_next[7] = BIP3_Lane_3_bit_7_temp; 
            ////////////// 				
         end
      else
         begin
			   //////////////Lane_0
            BIP3_Lane_0_next[0] = BIP3_Lane_0_bit_0_temp_1;  
            BIP3_Lane_0_next[1] = BIP3_Lane_0_bit_1_temp_1;
            BIP3_Lane_0_next[2] = BIP3_Lane_0_bit_2_temp_1;
            BIP3_Lane_0_next[3] = BIP3_Lane_0_bit_3_temp_1;
            BIP3_Lane_0_next[4] = BIP3_Lane_0_bit_4_temp_1;
            BIP3_Lane_0_next[5] = BIP3_Lane_0_bit_5_temp_1;
            BIP3_Lane_0_next[6] = BIP3_Lane_0_bit_6_temp_1;
            BIP3_Lane_0_next[7] = BIP3_Lane_0_bit_7_temp_1; 
            ////////////// 

			   //////////////Lane_1
            BIP3_Lane_1_next[0] = BIP3_Lane_1_bit_0_temp_1;  
            BIP3_Lane_1_next[1] = BIP3_Lane_1_bit_1_temp_1;
            BIP3_Lane_1_next[2] = BIP3_Lane_1_bit_2_temp_1;
            BIP3_Lane_1_next[3] = BIP3_Lane_1_bit_3_temp_1;
            BIP3_Lane_1_next[4] = BIP3_Lane_1_bit_4_temp_1;
            BIP3_Lane_1_next[5] = BIP3_Lane_1_bit_5_temp_1;
            BIP3_Lane_1_next[6] = BIP3_Lane_1_bit_6_temp_1;
            BIP3_Lane_1_next[7] = BIP3_Lane_1_bit_7_temp_1;  
            ////////////// 

			   //////////////Lane_2
            BIP3_Lane_2_next[0] = BIP3_Lane_2_bit_0_temp_1;  
            BIP3_Lane_2_next[1] = BIP3_Lane_2_bit_1_temp_1;
            BIP3_Lane_2_next[2] = BIP3_Lane_2_bit_2_temp_1;
            BIP3_Lane_2_next[3] = BIP3_Lane_2_bit_3_temp_1;
            BIP3_Lane_2_next[4] = BIP3_Lane_2_bit_4_temp_1;
            BIP3_Lane_2_next[5] = BIP3_Lane_2_bit_5_temp_1;
            BIP3_Lane_2_next[6] = BIP3_Lane_2_bit_6_temp_1;
            BIP3_Lane_2_next[7] = BIP3_Lane_2_bit_7_temp_1; 
            ////////////// 

			   //////////////Lane_3
            BIP3_Lane_3_next[0] = BIP3_Lane_3_bit_0_temp_1;  
            BIP3_Lane_3_next[1] = BIP3_Lane_3_bit_1_temp_1;
            BIP3_Lane_3_next[2] = BIP3_Lane_3_bit_2_temp_1;
            BIP3_Lane_3_next[3] = BIP3_Lane_3_bit_3_temp_1;
            BIP3_Lane_3_next[4] = BIP3_Lane_3_bit_4_temp_1;
            BIP3_Lane_3_next[5] = BIP3_Lane_3_bit_5_temp_1;
            BIP3_Lane_3_next[6] = BIP3_Lane_3_bit_6_temp_1;
            BIP3_Lane_3_next[7] = BIP3_Lane_3_bit_7_temp_1;  
            ////////////// 			   
         end   
end			 
	
///////////////////////////////////////////////////////
assign BIP3_Lane_0_bit_0_temp = ( Lane_0_out[2] ^ Lane_0_out[10] ^ Lane_0_out[18] ^ Lane_0_out[26] ^
                                  Lane_0_out[34]^ Lane_0_out[42]^ Lane_0_out[50]^ Lane_0_out[58] );
assign BIP3_Lane_0_bit_1_temp = ( Lane_0_out[3] ^ Lane_0_out[11] ^ Lane_0_out[19] ^ Lane_0_out[27] ^
                                  Lane_0_out[35]^ Lane_0_out[43]^ Lane_0_out[51]^ Lane_0_out[59] );	
assign BIP3_Lane_0_bit_2_temp = ( Lane_0_out[4] ^ Lane_0_out[12] ^ Lane_0_out[20] ^ Lane_0_out[28] ^
                                  Lane_0_out[36]^ Lane_0_out[44]^ Lane_0_out[52]^ Lane_0_out[60] );
assign BIP3_Lane_0_bit_3_temp = ( Lane_0_out[0] ^ Lane_0_out[5] ^ Lane_0_out[13] ^ Lane_0_out[21] ^
                                  Lane_0_out[29]^ Lane_0_out[37]^ Lane_0_out[45]^ Lane_0_out[53] ^ Lane_0_out[61] );
assign BIP3_Lane_0_bit_4_temp = ( Lane_0_out[1] ^ Lane_0_out[6] ^ Lane_0_out[14] ^ Lane_0_out[22] ^
                                  Lane_0_out[30]^ Lane_0_out[38]^ Lane_0_out[46]^ Lane_0_out[54] ^ Lane_0_out[62] );
assign BIP3_Lane_0_bit_5_temp = ( Lane_0_out[7] ^ Lane_0_out[15] ^ Lane_0_out[23] ^ Lane_0_out[31] ^
                                  Lane_0_out[39]^ Lane_0_out[47]^ Lane_0_out[55]^ Lane_0_out[63] );
assign BIP3_Lane_0_bit_6_temp = ( Lane_0_out[8] ^ Lane_0_out[16] ^ Lane_0_out[24] ^ Lane_0_out[32] ^
                                  Lane_0_out[40]^ Lane_0_out[48]^ Lane_0_out[56]^ Lane_0_out[64] );
assign BIP3_Lane_0_bit_7_temp = ( Lane_0_out[9] ^ Lane_0_out[17] ^ Lane_0_out[25] ^ Lane_0_out[33] ^
                                  Lane_0_out[41]^ Lane_0_out[49]^ Lane_0_out[57]^ Lane_0_out[65] );

assign BIP3_Lane_1_bit_0_temp = ( Lane_1_out[2] ^ Lane_1_out[10] ^ Lane_1_out[18] ^ Lane_1_out[26] ^
                                  Lane_1_out[34]^ Lane_1_out[42]^ Lane_1_out[50]^ Lane_1_out[58] );
assign BIP3_Lane_1_bit_1_temp = ( Lane_1_out[3] ^ Lane_1_out[11] ^ Lane_1_out[19] ^ Lane_1_out[27] ^
                                  Lane_1_out[35]^ Lane_1_out[43]^ Lane_1_out[51]^ Lane_1_out[59] );	
assign BIP3_Lane_1_bit_2_temp = ( Lane_1_out[4] ^ Lane_1_out[12] ^ Lane_1_out[20] ^ Lane_1_out[28] ^
                                  Lane_1_out[36]^ Lane_1_out[44]^ Lane_1_out[52]^ Lane_1_out[60] );
assign BIP3_Lane_1_bit_3_temp = ( Lane_1_out[0] ^ Lane_1_out[5] ^ Lane_1_out[13] ^ Lane_1_out[21] ^
                                  Lane_1_out[29]^ Lane_1_out[37]^ Lane_1_out[45]^ Lane_1_out[53] ^ Lane_1_out[61] );
assign BIP3_Lane_1_bit_4_temp = ( Lane_1_out[1] ^ Lane_1_out[6] ^ Lane_1_out[14] ^ Lane_1_out[22] ^
                                  Lane_1_out[30]^ Lane_1_out[38]^ Lane_1_out[46]^ Lane_1_out[54] ^ Lane_1_out[62] );
assign BIP3_Lane_1_bit_5_temp = ( Lane_1_out[7] ^ Lane_1_out[15] ^ Lane_1_out[23] ^ Lane_1_out[31] ^
                                  Lane_1_out[39]^ Lane_1_out[47]^ Lane_1_out[55]^ Lane_1_out[63] );
assign BIP3_Lane_1_bit_6_temp = ( Lane_1_out[8] ^ Lane_1_out[16] ^ Lane_1_out[24] ^ Lane_1_out[32] ^
                                  Lane_1_out[40]^ Lane_1_out[48]^ Lane_1_out[56]^ Lane_1_out[64] );
assign BIP3_Lane_1_bit_7_temp = ( Lane_1_out[9] ^ Lane_1_out[17] ^ Lane_1_out[25] ^ Lane_1_out[33] ^
                                  Lane_1_out[41]^ Lane_1_out[49]^ Lane_1_out[57]^ Lane_1_out[65] );
											 
											 
assign BIP3_Lane_2_bit_0_temp = ( Lane_2_out[2] ^ Lane_2_out[10] ^ Lane_2_out[18] ^ Lane_2_out[26] ^
                                  Lane_2_out[34]^ Lane_2_out[42]^ Lane_2_out[50]^ Lane_2_out[58] );
assign BIP3_Lane_2_bit_1_temp = ( Lane_2_out[3] ^ Lane_2_out[11] ^ Lane_2_out[19] ^ Lane_2_out[27] ^
                                  Lane_2_out[35]^ Lane_2_out[43]^ Lane_2_out[51]^ Lane_2_out[59] );	
assign BIP3_Lane_2_bit_2_temp = ( Lane_2_out[4] ^ Lane_2_out[12] ^ Lane_2_out[20] ^ Lane_2_out[28] ^
                                  Lane_2_out[36]^ Lane_2_out[44]^ Lane_2_out[52]^ Lane_2_out[60] );
assign BIP3_Lane_2_bit_3_temp = ( Lane_2_out[0] ^ Lane_2_out[5] ^ Lane_2_out[13] ^ Lane_2_out[21] ^
                                  Lane_2_out[29]^ Lane_2_out[37]^ Lane_2_out[45]^ Lane_2_out[53] ^ Lane_2_out[61] );
assign BIP3_Lane_2_bit_4_temp = ( Lane_2_out[1] ^ Lane_2_out[6] ^ Lane_2_out[14] ^ Lane_2_out[22] ^
                                  Lane_2_out[30]^ Lane_2_out[38]^ Lane_2_out[46]^ Lane_2_out[54] ^ Lane_2_out[62] );
assign BIP3_Lane_2_bit_5_temp = ( Lane_2_out[7] ^ Lane_2_out[15] ^ Lane_2_out[23] ^ Lane_2_out[31] ^
                                  Lane_2_out[39]^ Lane_2_out[47]^ Lane_2_out[55]^ Lane_2_out[63] );
assign BIP3_Lane_2_bit_6_temp = ( Lane_2_out[8] ^ Lane_2_out[16] ^ Lane_2_out[24] ^ Lane_2_out[32] ^
                                  Lane_2_out[40]^ Lane_2_out[48]^ Lane_2_out[56]^ Lane_2_out[64] );
assign BIP3_Lane_2_bit_7_temp = ( Lane_2_out[9] ^ Lane_2_out[17] ^ Lane_2_out[25] ^ Lane_2_out[33] ^
                                  Lane_2_out[41]^ Lane_2_out[49]^ Lane_2_out[57]^ Lane_2_out[65] );


assign BIP3_Lane_3_bit_0_temp = ( Lane_3_out[2] ^ Lane_3_out[10] ^ Lane_3_out[18] ^ Lane_3_out[26] ^
                                  Lane_3_out[34]^ Lane_3_out[42]^ Lane_3_out[50]^ Lane_3_out[58] );
assign BIP3_Lane_3_bit_1_temp = ( Lane_3_out[3] ^ Lane_3_out[11] ^ Lane_3_out[19] ^ Lane_3_out[27] ^
                                  Lane_3_out[35]^ Lane_3_out[43]^ Lane_3_out[51]^ Lane_3_out[59] );	
assign BIP3_Lane_3_bit_2_temp = ( Lane_3_out[4] ^ Lane_3_out[12] ^ Lane_3_out[20] ^ Lane_3_out[28] ^
                                  Lane_3_out[36]^ Lane_3_out[44]^ Lane_3_out[52]^ Lane_3_out[60] );
assign BIP3_Lane_3_bit_3_temp = ( Lane_3_out[0] ^ Lane_3_out[5] ^ Lane_3_out[13] ^ Lane_3_out[21] ^
                                  Lane_3_out[29]^ Lane_3_out[37]^ Lane_3_out[45]^ Lane_3_out[53] ^ Lane_3_out[61] );
assign BIP3_Lane_3_bit_4_temp = ( Lane_3_out[1] ^ Lane_3_out[6] ^ Lane_3_out[14] ^ Lane_3_out[22] ^
                                  Lane_3_out[30]^ Lane_3_out[38]^ Lane_3_out[46]^ Lane_3_out[54] ^ Lane_3_out[62] );
assign BIP3_Lane_3_bit_5_temp = ( Lane_3_out[7] ^ Lane_3_out[15] ^ Lane_3_out[23] ^ Lane_3_out[31] ^
                                  Lane_3_out[39]^ Lane_3_out[47]^ Lane_3_out[55]^ Lane_3_out[63] );
assign BIP3_Lane_3_bit_6_temp = ( Lane_3_out[8] ^ Lane_3_out[16] ^ Lane_3_out[24] ^ Lane_3_out[32] ^
                                  Lane_3_out[40]^ Lane_3_out[48]^ Lane_3_out[56]^ Lane_3_out[64] );
assign BIP3_Lane_3_bit_7_temp = ( Lane_3_out[9] ^ Lane_3_out[17] ^ Lane_3_out[25] ^ Lane_3_out[33] ^
                                  Lane_3_out[41]^ Lane_3_out[49]^ Lane_3_out[57]^ Lane_3_out[65] );	


assign BIP3_Lane_0_bit_0_temp_1 = BIP3_Lane_0_bit_0_temp ^ BIP3_Lane_0[0];
assign BIP3_Lane_0_bit_1_temp_1 = BIP3_Lane_0_bit_1_temp ^ BIP3_Lane_0[1];	
assign BIP3_Lane_0_bit_2_temp_1 = BIP3_Lane_0_bit_2_temp ^ BIP3_Lane_0[2];
assign BIP3_Lane_0_bit_3_temp_1 = BIP3_Lane_0_bit_3_temp ^ BIP3_Lane_0[3];
assign BIP3_Lane_0_bit_4_temp_1 = BIP3_Lane_0_bit_4_temp ^ BIP3_Lane_0[4];
assign BIP3_Lane_0_bit_5_temp_1 = BIP3_Lane_0_bit_5_temp ^ BIP3_Lane_0[5];
assign BIP3_Lane_0_bit_6_temp_1 = BIP3_Lane_0_bit_6_temp ^ BIP3_Lane_0[6];
assign BIP3_Lane_0_bit_7_temp_1 = BIP3_Lane_0_bit_7_temp ^ BIP3_Lane_0[7];		

assign BIP3_Lane_1_bit_0_temp_1 = BIP3_Lane_1_bit_0_temp ^ BIP3_Lane_1[0];
assign BIP3_Lane_1_bit_1_temp_1 = BIP3_Lane_1_bit_1_temp ^ BIP3_Lane_1[1];	
assign BIP3_Lane_1_bit_2_temp_1 = BIP3_Lane_1_bit_2_temp ^ BIP3_Lane_1[2];
assign BIP3_Lane_1_bit_3_temp_1 = BIP3_Lane_1_bit_3_temp ^ BIP3_Lane_1[3];
assign BIP3_Lane_1_bit_4_temp_1 = BIP3_Lane_1_bit_4_temp ^ BIP3_Lane_1[4];
assign BIP3_Lane_1_bit_5_temp_1 = BIP3_Lane_1_bit_5_temp ^ BIP3_Lane_1[5];
assign BIP3_Lane_1_bit_6_temp_1 = BIP3_Lane_1_bit_6_temp ^ BIP3_Lane_1[6];
assign BIP3_Lane_1_bit_7_temp_1 = BIP3_Lane_1_bit_7_temp ^ BIP3_Lane_1[7];	

assign BIP3_Lane_2_bit_0_temp_1 = BIP3_Lane_2_bit_0_temp ^ BIP3_Lane_2[0];
assign BIP3_Lane_2_bit_1_temp_1 = BIP3_Lane_2_bit_1_temp ^ BIP3_Lane_2[1];	
assign BIP3_Lane_2_bit_2_temp_1 = BIP3_Lane_2_bit_2_temp ^ BIP3_Lane_2[2];
assign BIP3_Lane_2_bit_3_temp_1 = BIP3_Lane_2_bit_3_temp ^ BIP3_Lane_2[3];
assign BIP3_Lane_2_bit_4_temp_1 = BIP3_Lane_2_bit_4_temp ^ BIP3_Lane_2[4];
assign BIP3_Lane_2_bit_5_temp_1 = BIP3_Lane_2_bit_5_temp ^ BIP3_Lane_2[5];
assign BIP3_Lane_2_bit_6_temp_1 = BIP3_Lane_2_bit_6_temp ^ BIP3_Lane_2[6];
assign BIP3_Lane_2_bit_7_temp_1 = BIP3_Lane_2_bit_7_temp ^ BIP3_Lane_2[7];	

assign BIP3_Lane_3_bit_0_temp_1 = BIP3_Lane_3_bit_0_temp ^ BIP3_Lane_3[0];
assign BIP3_Lane_3_bit_1_temp_1 = BIP3_Lane_3_bit_1_temp ^ BIP3_Lane_3[1];	
assign BIP3_Lane_3_bit_2_temp_1 = BIP3_Lane_3_bit_2_temp ^ BIP3_Lane_3[2];
assign BIP3_Lane_3_bit_3_temp_1 = BIP3_Lane_3_bit_3_temp ^ BIP3_Lane_3[3];
assign BIP3_Lane_3_bit_4_temp_1 = BIP3_Lane_3_bit_4_temp ^ BIP3_Lane_3[4];
assign BIP3_Lane_3_bit_5_temp_1 = BIP3_Lane_3_bit_5_temp ^ BIP3_Lane_3[5];
assign BIP3_Lane_3_bit_6_temp_1 = BIP3_Lane_3_bit_6_temp ^ BIP3_Lane_3[6];
assign BIP3_Lane_3_bit_7_temp_1 = BIP3_Lane_3_bit_7_temp ^ BIP3_Lane_3[7];										 
///////////////////////////////////////////////////////	

assign Lane_0_out = lane_reordered_1[263:198];
assign Lane_1_out = lane_reordered_1[197:132];
assign Lane_2_out = lane_reordered_1[131:66];
assign Lane_3_out = lane_reordered_1[65:0];

//rx_test_mode operation
always @(posedge RX_CLK,negedge reset)
begin
  if (!reset) begin 
	 test_pattern_error_count <= 0;
  end	 
  else begin
	 test_pattern_error_count <= test_pattern_error_count_next;
  end	 
end

always@* begin
   if(rx_test_mode && deskew_done_2) begin
	   if((redistribution_reg[263:198] != {56'b0,8'h1E,2'b01}) && test_pattern_error_count != 16'hFFFF) begin
		   test_pattern_error_count_next =  test_pattern_error_count + 16'b1;  
		end else begin
		   test_pattern_error_count_next =  test_pattern_error_count;
		end
	end else begin
	   test_pattern_error_count_next =  test_pattern_error_count;
	end
end
///////

//PCS_status generation
assign PCS_status = (deskew_done_2 && !hi_ber);
//////
		
//align_status generation
assign align_status = deskew_done_2;
//////

//block lock signals for MDIO
assign block_lock_lane_0 = RX_CLK_lane0_block_locked_signal2;
assign block_lock_lane_1 = RX_CLK_lane1_block_locked_signal2;
assign block_lock_lane_2 = RX_CLK_lane2_block_locked_signal2;
assign block_lock_lane_3 = RX_CLK_lane3_block_locked_signal2;
//////

//AM lock signals for MDIO
assign am_lock_lane_0 = RX_CLK_lane0_am_lock_sig2;
assign am_lock_lane_1 = RX_CLK_lane1_am_lock_sig2;
assign am_lock_lane_2 = RX_CLK_lane2_am_lock_sig2;
assign am_lock_lane_3 = RX_CLK_lane3_am_lock_sig2;
//////

//lane mapping generation for MDIO
always@* begin
   case(lane0_mapping) 
	   8'h90: lane_mapping_0_sig = 2'd0;
      8'hF0: lane_mapping_0_sig = 2'd1;
      8'hC5: lane_mapping_0_sig = 2'd2;
      8'hA2: lane_mapping_0_sig = 2'd3; 	
      default : lane_mapping_0_sig = 2'd0; 		
   endcase	
	
   case(lane1_mapping) 
	   8'h90: lane_mapping_1_sig = 2'd0;
      8'hF0: lane_mapping_1_sig = 2'd1;
      8'hC5: lane_mapping_1_sig = 2'd2;
      8'hA2: lane_mapping_1_sig = 2'd3; 	
      default : lane_mapping_1_sig = 2'd0; 		
   endcase	
	
   case(lane2_mapping) 
	   8'h90: lane_mapping_2_sig = 2'd0;
      8'hF0: lane_mapping_2_sig = 2'd1;
      8'hC5: lane_mapping_2_sig = 2'd2;
      8'hA2: lane_mapping_2_sig = 2'd3; 	
      default : lane_mapping_2_sig = 2'd0; 
	endcase	

   case(lane3_mapping) 
	   8'h90: lane_mapping_3_sig = 2'd0;
      8'hF0: lane_mapping_3_sig = 2'd1;
      8'hC5: lane_mapping_3_sig = 2'd2;
      8'hA2: lane_mapping_3_sig = 2'd3; 	
      default : lane_mapping_3_sig = 2'd0; 		
   endcase			
end

assign lane_mapping_0 = RX_CLK_lane_mapping_0_sig2;
assign lane_mapping_1 = RX_CLK_lane_mapping_1_sig2;
assign lane_mapping_2 = RX_CLK_lane_mapping_2_sig2;
assign lane_mapping_3 = RX_CLK_lane_mapping_3_sig2;
//////

//BIP counters
always @(posedge lane0_clk,negedge reset)
begin
  if (!reset) begin 
	 bip_counter_lane_0_reg <= 0;
	 bip_counter_lane_1_reg <= 0;
	 bip_counter_lane_2_reg <= 0;
	 bip_counter_lane_3_reg <= 0;
  end	 
  else begin
	 bip_counter_lane_0_reg <= bip_counter_lane_0_reg_next;
	 bip_counter_lane_1_reg <= bip_counter_lane_1_reg_next;
	 bip_counter_lane_2_reg <= bip_counter_lane_2_reg_next;
	 bip_counter_lane_3_reg <= bip_counter_lane_3_reg_next;
  end	 
end

always@* begin
   if(am_detected_1 == 1'b1) begin
	   if(bip_counter_lane_0_reg == 16'hFFFF) begin
		   bip_counter_lane_0_reg_next = bip_counter_lane_0_reg;
		end else begin
		   if(BIP3_Lane_0 != Lane_0_out[33:26]) begin
			   bip_counter_lane_0_reg_next = bip_counter_lane_0_reg+16'b1;   
			end
			else begin
			   bip_counter_lane_0_reg_next = bip_counter_lane_0_reg;
			end
		end
		
	   if(bip_counter_lane_1_reg == 16'hFFFF) begin
		   bip_counter_lane_1_reg_next = bip_counter_lane_1_reg;
		end else begin
		   if(BIP3_Lane_1 != Lane_1_out[33:26]) begin
			   bip_counter_lane_1_reg_next = bip_counter_lane_1_reg+16'b1;   
			end
			else begin
			   bip_counter_lane_1_reg_next = bip_counter_lane_1_reg;
			end
		end	

	   if(bip_counter_lane_2_reg == 16'hFFFF) begin
		   bip_counter_lane_2_reg_next = bip_counter_lane_2_reg;
		end else begin
		   if(BIP3_Lane_2 != Lane_2_out[33:26]) begin
			   bip_counter_lane_2_reg_next = bip_counter_lane_2_reg+16'b1;   
			end
			else begin
			   bip_counter_lane_2_reg_next = bip_counter_lane_2_reg;
			end
		end

	   if(bip_counter_lane_3_reg == 16'hFFFF) begin
		   bip_counter_lane_3_reg_next = bip_counter_lane_3_reg;
		end else begin
		   if(BIP3_Lane_3 != Lane_3_out[33:26]) begin
			   bip_counter_lane_3_reg_next = bip_counter_lane_3_reg+16'b1;   
			end
			else begin
			   bip_counter_lane_3_reg_next = bip_counter_lane_3_reg;
			end
		end		
		
	end else begin
	   bip_counter_lane_0_reg_next = bip_counter_lane_0_reg;
	   bip_counter_lane_1_reg_next = bip_counter_lane_1_reg;
	   bip_counter_lane_2_reg_next = bip_counter_lane_2_reg;
	   bip_counter_lane_3_reg_next = bip_counter_lane_3_reg;	
	end
end

assign bip_counter_lane_0 = RX_CLK_bip_counter_lane_0_reg2;
assign bip_counter_lane_1 = RX_CLK_bip_counter_lane_1_reg2;
assign bip_counter_lane_2 = RX_CLK_bip_counter_lane_2_reg2;
assign bip_counter_lane_3 = RX_CLK_bip_counter_lane_3_reg2;
///////
				
endmodule
