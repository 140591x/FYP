`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:31:32 08/21/2014 
// Design Name: 
// Module Name:    encode_func 
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
module encode_func(
   input wire [71:0] encoder_in_buffer,
   output reg [65:0] encoder_func_out  
);

wire [6:0] idle_or_error_lane_2;
wire [6:0] idle_or_error_lane_3;
wire [6:0] idle_or_error_lane_4;
wire [6:0] idle_or_error_lane_5;
wire [6:0] idle_or_error_lane_6;
wire [6:0] idle_or_error_lane_7;

wire is_idle_lane_1,is_idle_lane_2,is_idle_lane_3,is_idle_lane_4,is_idle_lane_5,is_idle_lane_6,is_idle_lane_7;

always@*
	if(encoder_in_buffer[7:0]==8'b00000000)						// All data
		encoder_func_out={encoder_in_buffer[71:8],2'b10};
	
	else if(encoder_in_buffer[7:0]==8'b00000001&&encoder_in_buffer[15:8]==8'hFB)			//start and data
		encoder_func_out={encoder_in_buffer[71:16],8'h78,2'b01};
		
	else if(encoder_in_buffer[7:0]==8'b00000001&&(encoder_in_buffer[15:8]==8'h9C||encoder_in_buffer[15:8]==8'h5C)) //Ordered set
		encoder_func_out={28'h0,(encoder_in_buffer[15:8]==8'h9C)?4'h0:4'hF,encoder_in_buffer[39:16],8'h4B,2'b01};
		
	else if(encoder_in_buffer[7:0]==8'b11111111&&encoder_in_buffer[15:8]==8'hFD)		//1st terminator
	
		encoder_func_out={idle_or_error_lane_7,idle_or_error_lane_6,idle_or_error_lane_5,idle_or_error_lane_4,
								idle_or_error_lane_3,idle_or_error_lane_2,is_idle_lane_1?7'h00:7'h1E,7'h00,8'h87,2'b01};
			
	else if(encoder_in_buffer[7:0]==8'b11111110&&encoder_in_buffer[23:16]==8'hFD)		//2nd terminator
	
		encoder_func_out={idle_or_error_lane_7,idle_or_error_lane_6,idle_or_error_lane_5,idle_or_error_lane_4,
								idle_or_error_lane_3,idle_or_error_lane_2,6'h00,encoder_in_buffer[15:8],8'h99,2'b01};

	else if(encoder_in_buffer[7:0]==8'b11111100&&encoder_in_buffer[31:24]==8'hFD)		//3rd terminator
	
		encoder_func_out={idle_or_error_lane_7,idle_or_error_lane_6,idle_or_error_lane_5,idle_or_error_lane_4,
								idle_or_error_lane_3,5'h00,encoder_in_buffer[23:8],8'hAA,2'b01};
								
	else if(encoder_in_buffer[7:0]==8'b11111000&&encoder_in_buffer[39:32]==8'hFD)		//4th terminator
	
		encoder_func_out={idle_or_error_lane_7,idle_or_error_lane_6,idle_or_error_lane_5,idle_or_error_lane_4,
								4'h00,encoder_in_buffer[31:8],8'hB4,2'b01};	
									
	else if(encoder_in_buffer[7:0]==8'b11110000&&encoder_in_buffer[47:40]==8'hFD)		//5th terminator
	
		encoder_func_out={idle_or_error_lane_7,idle_or_error_lane_6,idle_or_error_lane_5,
								3'h00,encoder_in_buffer[39:8],8'hCC,2'b01};
					
	else if(encoder_in_buffer[7:0]==8'b11100000&&encoder_in_buffer[55:48]==8'hFD)		//6th terminator
	
		encoder_func_out={idle_or_error_lane_7,idle_or_error_lane_6,2'h00,encoder_in_buffer[47:8],8'hD2,2'b01};	
		
	else if(encoder_in_buffer[7:0]==8'b11000000&&encoder_in_buffer[63:56]==8'hFD)		//7th terminator
	
		encoder_func_out={idle_or_error_lane_7,1'h00,encoder_in_buffer[55:8],8'hE1,2'b01};	
		
	else if(encoder_in_buffer[7:0]==8'b10000000&&encoder_in_buffer[71:64]==8'hFD)		//8th terminator
	
		encoder_func_out={encoder_in_buffer[63:8],8'hFF,2'b01};
			
	else																										//All control idle
		encoder_func_out={56'h00,8'h1E,2'b01};
	
/////////////////////////////////////////////////////
assign is_idle_lane_1 = (encoder_in_buffer[23:16] == 8'h07);
assign is_idle_lane_2 = (encoder_in_buffer[31:24] == 8'h07);
assign is_idle_lane_3 = (encoder_in_buffer[39:32] == 8'h07);
assign is_idle_lane_4 = (encoder_in_buffer[47:40] == 8'h07);
assign is_idle_lane_5 = (encoder_in_buffer[55:48] == 8'h07);
assign is_idle_lane_6 = (encoder_in_buffer[63:56] == 8'h07);
assign is_idle_lane_7 = (encoder_in_buffer[71:64] == 8'h07);

assign idle_or_error_lane_2=is_idle_lane_2?7'h00:7'h1E;
assign idle_or_error_lane_3=is_idle_lane_3?7'h00:7'h1E;
assign idle_or_error_lane_4=is_idle_lane_4?7'h00:7'h1E;
assign idle_or_error_lane_5=is_idle_lane_5?7'h00:7'h1E;
assign idle_or_error_lane_6=is_idle_lane_6?7'h00:7'h1E;
assign idle_or_error_lane_7=is_idle_lane_7?7'h00:7'h1E;

//////////////////////////////////////////////////////
	


endmodule
