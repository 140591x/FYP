`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    03:09:40 11/03/2014 
// Design Name: 
// Module Name:    Buffer 
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
module Buffer(
   input wire [13:0] lane0_count,lane1_count,lane2_count,lane3_count,
	input wire clk,
   input wire reset,
	input wire am_status,
   input wire [65:0] lane0_data_in,lane1_data_in,lane2_data_in,lane3_data_in,
 	output reg [65:0] lane0_data_out,lane1_data_out,lane2_data_out,lane3_data_out,
	output reg deskew_done,
	output reg is_am //when this is 1 lane reordered out has alignment markers
);

wire [65:0] lane0_buffer_out,lane1_buffer_out,lane2_buffer_out,lane3_buffer_out;

reg [65:0] lane0_buffer [127:0];
reg [65:0] lane1_buffer [127:0];
reg [65:0] lane2_buffer [127:0];
reg [65:0] lane3_buffer [127:0];

reg [7:0] i;
reg next_is_am;

reg alignment_valid,next_deskew_done,stop_counters;

reg [6:0] counter_0,counter_1,counter_2,counter_3,
          next_counter_0,next_counter_1,next_counter_2,next_counter_3; 

reg control_0,control_1,control_2,control_3,
    next_control_0,next_control_1,next_control_2,next_control_3;
	 
//alignment_valid generation
always@*
begin
   if(lane0_count == counter_0) begin 
      if(lane1_count == counter_1 && lane2_count == counter_2 && lane3_count == counter_3)
         alignment_valid = 1;  
      else
         alignment_valid = 0; 
			
		next_is_am = 1;	
   end   		
   else begin
      alignment_valid = 1;  
		next_is_am = 0;
   end		
end
//////////

always@(posedge clk,negedge reset)
begin
	if(~reset || ~am_status) begin
      deskew_done <= 0;
		lane0_data_out <= 0;
		lane1_data_out <= 0;
		lane2_data_out <= 0;
		lane3_data_out <= 0;
		counter_0 <= 0; 
		counter_1 <= 0;
		counter_2 <= 0;
		counter_3 <= 0;
		control_0 <= 0; 
		control_1 <= 0; 
		control_2 <= 0; 
		control_3 <= 0; 
		is_am <= 0;
	end else begin			
      deskew_done <= next_deskew_done;
		lane0_data_out <= lane0_buffer_out;
		lane1_data_out <= lane1_buffer_out;
		lane2_data_out <= lane2_buffer_out;
		lane3_data_out <= lane3_buffer_out;
		counter_0 <= next_counter_0; 
		counter_1 <= next_counter_1;
		counter_2 <= next_counter_2;
		counter_3 <= next_counter_3;
		control_0 <= next_control_0; 
		control_1 <= next_control_1; 
		control_2 <= next_control_2; 
		control_3 <= next_control_3;
		is_am <= next_is_am;
	end	
end

//next counters generation
always@* begin
if(control_0 == 0) begin
   next_counter_0 = 0;
end else begin
   if(~stop_counters)
      next_counter_0 = counter_0 + 7'b1;
   else
      next_counter_0 = counter_0;
end

if(control_1 == 0) begin
   next_counter_1 = 0;
end else begin
   if(~stop_counters)
      next_counter_1 = counter_1 + 7'b1;
   else
      next_counter_1 = counter_1;
end

if(control_2 == 0) begin
   next_counter_2 = 0;
end else begin
   if(~stop_counters)
      next_counter_2 = counter_2 + 7'b1;
   else
      next_counter_2 = counter_2;
end

if(control_3 == 0) begin
   next_counter_3 = 0;
end else begin
   if(~stop_counters)
      next_counter_3 = counter_3 + 7'b1;
   else
      next_counter_3 = counter_3;
end	
end	
/////////// 

//stop_counters generation
always@* begin
if(control_0 == 1 && control_1 == 1 && control_2 == 1 && control_3 == 1)
   stop_counters = 1;
else
   stop_counters = 0;   
end	
/////////// 

//deskew
always@* begin
if(deskew_done) begin
   if(alignment_valid) begin
	   next_deskew_done = deskew_done;
		next_control_0 = control_0;
		next_control_1 = control_1;
		next_control_2 = control_2;
		next_control_3 = control_3;
   end else begin
      next_deskew_done = 0;	
		next_control_0 = 0;
		next_control_1 = 0;
		next_control_2 = 0;
		next_control_3 = 0;		
	end	
end
else begin

      if( control_0 == 1 && control_1 == 1 && control_2 == 1 && control_3 == 1) begin
         next_deskew_done = 1;
		   next_control_0 = 1;
		   next_control_1 = 1;
		   next_control_2 = 1;
		   next_control_3 = 1;   		
 		end else if(counter_0 == 7'd127 || counter_1 == 7'd127 || counter_2 == 7'd127 || counter_3 == 7'd127)begin
	      next_deskew_done = 0;
	   	next_control_0 = 0;
	   	next_control_1 = 0;
		   next_control_2 = 0;
		   next_control_3 = 0;		   
      end else begin
	
         next_deskew_done = deskew_done;
			
         if(lane0_count == 14'd16383)
            next_control_0 = 1;
         else
            next_control_0 = control_0;	
		
         if(lane1_count == 14'd16383)
            next_control_1 = 1;
         else
            next_control_1 = control_1;

         if(lane2_count == 14'd16383)
            next_control_2 = 1;
         else
            next_control_2 = control_2;

         if(lane3_count == 14'd16383)
            next_control_3 = 1;
         else
            next_control_3 = control_3;      
   end
	
end
end
///////////

//buffer implementation
  always @ (posedge clk) begin
     for(i=1; i<128 ; i = i+1 ) begin
        lane0_buffer[i] <= lane0_buffer[i-1];
		  lane1_buffer[i] <= lane1_buffer[i-1];
		  lane2_buffer[i] <= lane2_buffer[i-1];
		  lane3_buffer[i] <= lane3_buffer[i-1];
     end		
        lane0_buffer[0] <= lane0_data_in;
		  lane1_buffer[0] <= lane1_data_in;
		  lane2_buffer[0] <= lane2_data_in;
		  lane3_buffer[0] <= lane3_data_in;	  
  end
//////////

assign lane0_buffer_out = lane0_buffer[counter_0];
assign lane1_buffer_out = lane1_buffer[counter_1];
assign lane2_buffer_out = lane2_buffer[counter_2];
assign lane3_buffer_out = lane3_buffer[counter_3];

endmodule
