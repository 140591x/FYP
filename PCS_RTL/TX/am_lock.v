`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:29:09 10/31/2014 
// Design Name: 
// Module Name:    am_lock 
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
module am_lock(
   input wire[49:0] data_in,
   input wire clk,
	input wire reset,
	input wire block_locked_signal,
	output reg am_lock,
	output wire [7:0] lane_mapping,
	output wire [13:0] am_counter_out
);

localparam AM_LOCK_INIT = 2'b00;
localparam FIND_1ST = 2'b01;
localparam COUNT_1 = 2'b10;
localparam COUNT_2 = 2'b11;

reg [49:0] first_am,first_am_next;
reg [2:0] am_invld_cnt,am_invld_cnt_next;
reg [13:0] am_counter,am_counter_next;
reg am_lock_next;
reg [2:0] state,next_state;
reg am_valid;
reg AMmatch;


always@(posedge clk,negedge reset)
begin
	if(~reset || ~block_locked_signal) begin
      am_lock <= 0; 	
      first_am <= 0;		
		am_invld_cnt <= 0;
		am_counter <= 0;
		state <= 0;
	end else begin			
      am_lock <= am_lock_next; 			
      first_am <= first_am_next;		
		am_invld_cnt <= am_invld_cnt_next;
		am_counter <= am_counter_next;
		state <= next_state;
	end	
end

//next state generation
always@*
begin
   case(state)  
	   AM_LOCK_INIT: next_state = FIND_1ST; 

      FIND_1ST: begin
		   if(am_valid)
			   next_state = COUNT_1;   
			else
			   next_state = FIND_1ST; 
      end	

      COUNT_1: begin
		   if(am_counter == 14'd16383) begin
			   if(AMmatch)
				   next_state = COUNT_2;   
				else
				   next_state = FIND_1ST;
		   end
			else
			   next_state = COUNT_1;            			
      end 
								
		COUNT_2: begin
		   if(am_counter == 14'd16383) begin
			   if(AMmatch)
				   next_state = COUNT_2;   
				else begin
				   if(am_invld_cnt == 3'b100)
					   next_state = FIND_1ST;
					else
                  next_state = COUNT_2;					
				end	
		   end
			else
			   next_state = COUNT_2; 		   
		end
		
		default: next_state = AM_LOCK_INIT;
		
   endcase	
end
////////////////////////////

always@*
begin
   case(state)  
	   AM_LOCK_INIT: begin
		   first_am_next = 0;
			am_invld_cnt_next = 0;
			am_counter_next = 0;
			am_lock_next = 0;
      end		

      FIND_1ST: begin
		   first_am_next = data_in;
			am_invld_cnt_next = 0;
			am_counter_next = 0;
			am_lock_next = am_lock;
      end	

      COUNT_1: begin
		   first_am_next = first_am;
			am_invld_cnt_next = am_invld_cnt;
			am_counter_next = am_counter + 14'b1;
			
		   if(am_counter == 14'd16383) begin
			   if(AMmatch) begin
				   am_lock_next = 1;  
            end					
				else begin
				   am_lock_next = 0; 
				end	
		   end
			else begin
			   am_lock_next = am_lock;
			end
			
      end 
								
		COUNT_2: begin
		   first_am_next = first_am;
			
			if(am_counter == 14'd16383) begin
				if(AMmatch) begin
				   am_invld_cnt_next = 0;  
					am_lock_next = am_lock;
            end					
				else begin
				   am_invld_cnt_next = am_invld_cnt + 3'b1;
					am_lock_next = am_lock;
					
					if(am_invld_cnt == 3'b011)
				   	am_lock_next = 0;
					else
                  am_lock_next = am_lock;					
				end	
			end		
			else
			   am_invld_cnt_next = am_invld_cnt;
			
			am_counter_next = am_counter + 14'b1;
			am_lock_next = am_lock;		   
		end
		
		default: begin
		   first_am_next = 0;
			am_invld_cnt_next = 0;
			am_counter_next = 0;
			am_lock_next = 0;		
		end
		
   endcase   
end


//am_valid generation
always@* begin

if( (data_in[1:0] == 2'b01) && (( data_in[9:2] == 8'h90 && data_in[17:10] == 8'h76 && 
    data_in[25:18] == 8'h47 && data_in[33:26] == 8'h6F &&
    data_in[41:34] == 8'h89 && data_in[49:42] == 8'hB8 ) ||
	 
	 ( data_in[9:2] == 8'hF0 && data_in[17:10] == 8'hC4 && 
    data_in[25:18] == 8'hE6 && data_in[33:26] == 8'h0F &&
    data_in[41:34] == 8'h3B && data_in[49:42] == 8'h19 ) ||
	 
	 ( data_in[9:2] == 8'hC5 && data_in[17:10] == 8'h65 && 
    data_in[25:18] == 8'h9B && data_in[33:26] == 8'h3A &&
    data_in[41:34] == 8'h9A && data_in[49:42] == 8'h64 ) ||
	 
	 ( data_in[9:2] == 8'hA2 && data_in[17:10] == 8'h79 && 
    data_in[25:18] == 8'h3D && data_in[33:26] == 8'h5D &&
    data_in[41:34] == 8'h86 && data_in[49:42] == 8'hC2 )
	 )
  )
     am_valid = 1'b1;
else 
     am_valid = 1'b0;
	  
end	  
///////////	 

//first_am == data_in generation
always@* begin
   AMmatch = (first_am == data_in);	           
end
//////////////////

assign am_counter_out = am_counter;
assign lane_mapping = first_am[9:2];
	 
endmodule
