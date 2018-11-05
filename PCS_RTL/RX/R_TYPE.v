`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:14:52 11/03/2014 
// Design Name: 
// Module Name:    R_TYPE 
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
module R_TYPE(
	input wire[65:0] decoder_in,
	output reg [2:0] r_type
    );

//constant
localparam S=3'b000;
localparam C=3'b001;
localparam E=3'b010;
localparam D=3'b011;
localparam T=3'b100;

	  
wire is_error_or_idle_lane_1,is_error_or_idle_lane_2,is_error_or_idle_lane_3,
	  is_error_or_idle_lane_4,is_error_or_idle_lane_5,is_error_or_idle_lane_6,is_error_or_idle_lane_7;
	  
reg result;


always@*
begin
	if(decoder_in[1:0]==2'b10)
		r_type=D;
		
	else if(decoder_in[1:0]==2'b01&&(decoder_in[9:2]==8'h4B||(decoder_in[9:2]==8'h1E&&decoder_in[65:10]==56'h00)))
		r_type=C;
		
	else if(decoder_in[1:0]==2'b01&&decoder_in[9:2]==8'h78)
		r_type=S;
	
	else if(decoder_in[1:0]==2'b01&&result)
		r_type=T;
	
	else
		r_type=E;
end

always@*
begin
	case(decoder_in[9:2])
		8'h87:
			begin
				if(is_error_or_idle_lane_1&&is_error_or_idle_lane_2&&is_error_or_idle_lane_3&&is_error_or_idle_lane_4&&
				   is_error_or_idle_lane_5&&is_error_or_idle_lane_6&&is_error_or_idle_lane_7)
					result=1'b1;
				else
					result=1'b0;
			end
		8'h99:
			begin
				if(is_error_or_idle_lane_2&&is_error_or_idle_lane_3&&is_error_or_idle_lane_4&&
				   is_error_or_idle_lane_5&&is_error_or_idle_lane_6&&is_error_or_idle_lane_7)
					result=1'b1;
				else
					result=1'b0;
			end
		8'hAA:
			begin
				if(is_error_or_idle_lane_3&&is_error_or_idle_lane_4&&is_error_or_idle_lane_5&&is_error_or_idle_lane_6&&
				   is_error_or_idle_lane_7)
					result=1'b1;
				else
					result=1'b0;
			end
		8'hB4:
			begin
				if(is_error_or_idle_lane_4&&is_error_or_idle_lane_5&&is_error_or_idle_lane_6&&is_error_or_idle_lane_7)
					result=1'b1;
				else
					result=1'b0;
			end
		8'hCC:
			begin
				if(is_error_or_idle_lane_5&&is_error_or_idle_lane_6&&is_error_or_idle_lane_7)
					result=1'b1;
				else
					result=1'b0;
			end
		8'hD2:
			begin
				if(is_error_or_idle_lane_6&&is_error_or_idle_lane_7)
					result=1'b1;
				else
					result=1'b0;
			end
		8'hE1:
			begin
				if(is_error_or_idle_lane_7)
					result=1'b1;
				else
					result=1'b0;
			end
		8'hFF:
			result=1'b1;
		default 
			result=1'b0;
	
	endcase

end



assign is_error_or_idle_lane_1=(decoder_in[23:17]==7'h1E||decoder_in[23:17]==7'h00);
assign is_error_or_idle_lane_2=(decoder_in[30:24]==7'h1E||decoder_in[30:24]==7'h00);
assign is_error_or_idle_lane_3=(decoder_in[37:31]==7'h1E||decoder_in[37:31]==7'h00);
assign is_error_or_idle_lane_4=(decoder_in[44:38]==7'h1E||decoder_in[44:38]==7'h00);
assign is_error_or_idle_lane_5=(decoder_in[51:45]==7'h1E||decoder_in[51:45]==7'h00);
assign is_error_or_idle_lane_6=(decoder_in[58:52]==7'h1E||decoder_in[58:52]==7'h00);
assign is_error_or_idle_lane_7=(decoder_in[65:59]==7'h1E||decoder_in[65:59]==7'h00);


endmodule
