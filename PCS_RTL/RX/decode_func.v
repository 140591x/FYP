`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:59:30 11/04/2014 
// Design Name: 
// Module Name:    decode_func 
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
module decode_func(
	input wire [65:0] decoder_in_buffer,
	output reg [71:0] decoder_func_out
    );

wire [7:0] idle_or_error_lane_1;	 
wire [7:0] idle_or_error_lane_2;
wire [7:0] idle_or_error_lane_3;
wire [7:0] idle_or_error_lane_4;
wire [7:0] idle_or_error_lane_5;
wire [7:0] idle_or_error_lane_6;
wire [7:0] idle_or_error_lane_7;

wire is_idle_lane_1,is_idle_lane_2,is_idle_lane_3,is_idle_lane_4,is_idle_lane_5,is_idle_lane_6,is_idle_lane_7;
	 
always@*
begin 

	if(decoder_in_buffer[1:0]==2'b10)									//All data
		decoder_func_out={decoder_in_buffer[65:2],8'b0};
		
	else
		case(decoder_in_buffer[9:2])	
			8'h1E:																						//All control idle
				decoder_func_out={8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'b11111111};
			
			8'h78:																						//start and data
				decoder_func_out={decoder_in_buffer[65:10],8'hFB,8'b00000001};
			
			8'h4B:																						//Ordered set
				if(decoder_in_buffer[37:34]==4'h0)						
					decoder_func_out={32'h00,decoder_in_buffer[33:10],8'h9C,8'b00000001};
				else																	/*check this*/
					decoder_func_out={32'h00,decoder_in_buffer[33:10],8'h5C,8'b00000001};
			
			8'h87:																						//1st terminator
				decoder_func_out={idle_or_error_lane_7,idle_or_error_lane_6,idle_or_error_lane_5,
						idle_or_error_lane_4,idle_or_error_lane_3,idle_or_error_lane_2,idle_or_error_lane_1,8'hFD,8'b11111111};	

			8'h99:																					 	//2nd terminator
				decoder_func_out={idle_or_error_lane_7,idle_or_error_lane_6,idle_or_error_lane_5,
						idle_or_error_lane_4,idle_or_error_lane_3,idle_or_error_lane_2,8'hFD,decoder_in_buffer[17:10],8'b11111110};
			
			8'hAA:																						//3rd terminator
				decoder_func_out={idle_or_error_lane_7,idle_or_error_lane_6,idle_or_error_lane_5,
						idle_or_error_lane_4,idle_or_error_lane_3,8'hFD,decoder_in_buffer[25:10],8'b11111100};
				
			8'hB4:																						//4th terminator
				decoder_func_out={idle_or_error_lane_7,idle_or_error_lane_6,idle_or_error_lane_5,
						idle_or_error_lane_4,8'hFD,decoder_in_buffer[33:10],8'b11111000};
				
			8'hCC:																						//5th terminator
				decoder_func_out={idle_or_error_lane_7,idle_or_error_lane_6,idle_or_error_lane_5,8'hFD,
						decoder_in_buffer[41:10],8'b11110000};
						
			8'hD2:																						//6th terminator
				decoder_func_out={idle_or_error_lane_7,idle_or_error_lane_6,8'hFD,decoder_in_buffer[49:10],8'b11100000};
			
			8'hE1:																						//7th terminator
				decoder_func_out={idle_or_error_lane_7,8'hFD,decoder_in_buffer[57:10],8'b11000000};
						
			8'hFF:																						//8th terminator
				decoder_func_out={8'hFD,decoder_in_buffer[65:10],8'b10000000};
				
			default:
				decoder_func_out=72'hX;
				
		endcase

end


/////////////////////////////////////////////////////
assign is_idle_lane_1 = (decoder_in_buffer[23:17] == 7'h00);
assign is_idle_lane_2 = (decoder_in_buffer[30:24] == 7'h00);
assign is_idle_lane_3 = (decoder_in_buffer[37:31] == 7'h00);
assign is_idle_lane_4 = (decoder_in_buffer[44:38] == 7'h00);
assign is_idle_lane_5 = (decoder_in_buffer[51:45] == 7'h00);
assign is_idle_lane_6 = (decoder_in_buffer[58:52] == 7'h00);
assign is_idle_lane_7 = (decoder_in_buffer[65:59] == 7'h00);

assign idle_or_error_lane_1=is_idle_lane_1?8'h07:8'hFE;
assign idle_or_error_lane_2=is_idle_lane_2?8'h07:8'hFE;
assign idle_or_error_lane_3=is_idle_lane_3?8'h07:8'hFE;
assign idle_or_error_lane_4=is_idle_lane_4?8'h07:8'hFE;
assign idle_or_error_lane_5=is_idle_lane_5?8'h07:8'hFE;
assign idle_or_error_lane_6=is_idle_lane_6?8'h07:8'hFE;
assign idle_or_error_lane_7=is_idle_lane_7?8'h07:8'hFE;


endmodule
