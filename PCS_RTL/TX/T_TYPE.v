`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:05:47 08/21/2014 
// Design Name: 
// Module Name:    T_TYPE 
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
module T_TYPE(
   input wire [71:0] encoder_in,
   output reg [2:0] t_type    
);

//constants
localparam S = 3'b000;
localparam C = 3'b001;
localparam E = 3'b010;
localparam D = 3'b011;
localparam T = 3'b100;
//

wire is_idle_lane_0,is_idle_lane_1,is_idle_lane_2,is_idle_lane_3,
     is_idle_lane_4,is_idle_lane_5,is_idle_lane_6,is_idle_lane_7;
	  
wire is_error_lane_1,is_error_lane_2,is_error_lane_3,is_error_lane_4,is_error_lane_5
     ,is_error_lane_6,is_error_lane_7;

wire is_error_or_idle_lane_1,is_error_or_idle_lane_2,is_error_or_idle_lane_3
     ,is_error_or_idle_lane_4,is_error_or_idle_lane_5,is_error_or_idle_lane_6,is_error_or_idle_lane_7;	  

reg result;

///////////////////////////////////
always@*
begin
   if(encoder_in[7:0] == 8'b00000000)
      t_type = D;
   else if( ((encoder_in[7:0]==8'b11111111)&&is_idle_lane_0&&is_idle_lane_1&&is_idle_lane_2
	          &&is_idle_lane_3&&is_idle_lane_4&&is_idle_lane_5&&is_idle_lane_6&&is_idle_lane_7) ||
          ((encoder_in[7:0]==8'b00000001)&&((encoder_in[15:8]==8'h9c)||(encoder_in[15:8]==8'h5c))) )	
      t_type = C;
   else if((encoder_in[7:0]==8'b00000001)&&(encoder_in[15:8]==8'hFB))  
      t_type = S;
   else if(result)	
      t_type = T;
   else
      t_type = E; 	
end		


always@*
begin
	case(encoder_in[7:0])  
      8'b11111111:
		begin
		   if( (encoder_in[15:8]==8'hFD)&&is_error_or_idle_lane_1&&is_error_or_idle_lane_2&&is_error_or_idle_lane_3
              &&is_error_or_idle_lane_4&&is_error_or_idle_lane_5&&is_error_or_idle_lane_6&&is_error_or_idle_lane_7 )
			   result = 1'b1;
         else
            result = 1'b0; 			
		end
		8'b11111110:
		begin
		   if( (encoder_in[23:16]==8'hFD)&&is_error_or_idle_lane_2&&is_error_or_idle_lane_3
              &&is_error_or_idle_lane_4&&is_error_or_idle_lane_5&&is_error_or_idle_lane_6&&is_error_or_idle_lane_7 )
			   result = 1'b1;
         else
            result = 1'b0; 			
		end		
		8'b11111100:
		begin
		   if( (encoder_in[31:24]==8'hFD)&&is_error_or_idle_lane_3
              &&is_error_or_idle_lane_4&&is_error_or_idle_lane_5&&is_error_or_idle_lane_6&&is_error_or_idle_lane_7 )
			   result = 1'b1;
         else
            result = 1'b0; 			
		end		
		8'b11111000:
		begin
		   if( (encoder_in[39:32]==8'hFD)
              &&is_error_or_idle_lane_4&&is_error_or_idle_lane_5&&is_error_or_idle_lane_6&&is_error_or_idle_lane_7 )
			   result = 1'b1;
         else
            result = 1'b0; 			
		end		
		8'b11110000:
		begin
		   if( (encoder_in[47:40]==8'hFD)&&is_error_or_idle_lane_5&&is_error_or_idle_lane_6&&is_error_or_idle_lane_7 )
			   result = 1'b1;
         else
            result = 1'b0; 			
		end		
		8'b11100000:
		begin
		   if( (encoder_in[55:48]==8'hFD)&&is_error_or_idle_lane_6&&is_error_or_idle_lane_7 )
			   result = 1'b1;
         else
            result = 1'b0; 			
		end		
      8'b11000000:
		begin
		   if( (encoder_in[63:56]==8'hFD)&&is_error_or_idle_lane_7 )
			   result = 1'b1;
         else
            result = 1'b0; 			
		end		
      8'b10000000:
		begin
		   if( encoder_in[71:64]==8'hFD )
			   result = 1'b1;
         else
            result = 1'b0; 			
		end		
		default
         result = 1'b0;  		
   endcase		
end
///////////////////////////////////

///////////////////////////////////
assign is_idle_lane_0 = (encoder_in[15:8] == 8'h07);
assign is_idle_lane_1 = (encoder_in[23:16] == 8'h07);
assign is_idle_lane_2 = (encoder_in[31:24] == 8'h07);
assign is_idle_lane_3 = (encoder_in[39:32] == 8'h07);
assign is_idle_lane_4 = (encoder_in[47:40] == 8'h07);
assign is_idle_lane_5 = (encoder_in[55:48] == 8'h07);
assign is_idle_lane_6 = (encoder_in[63:56] == 8'h07);
assign is_idle_lane_7 = (encoder_in[71:64] == 8'h07);

assign is_error_lane_1 = (encoder_in[23:16] == 8'hFE);
assign is_error_lane_2 = (encoder_in[31:24] == 8'hFE);
assign is_error_lane_3 = (encoder_in[39:32] == 8'hFE);
assign is_error_lane_4 = (encoder_in[47:40] == 8'hFE);
assign is_error_lane_5 = (encoder_in[55:48] == 8'hFE);
assign is_error_lane_6 = (encoder_in[63:56] == 8'hFE);
assign is_error_lane_7 = (encoder_in[71:64] == 8'hFE);

assign is_error_or_idle_lane_1 = (is_idle_lane_1 || is_error_lane_1);
assign is_error_or_idle_lane_2 = (is_idle_lane_2 || is_error_lane_2);
assign is_error_or_idle_lane_3 = (is_idle_lane_3 || is_error_lane_3);
assign is_error_or_idle_lane_4 = (is_idle_lane_4 || is_error_lane_4);
assign is_error_or_idle_lane_5 = (is_idle_lane_5 || is_error_lane_5);
assign is_error_or_idle_lane_6 = (is_idle_lane_6 || is_error_lane_6);
assign is_error_or_idle_lane_7 = (is_idle_lane_7 || is_error_lane_7);
///////////////////////////////////
endmodule
