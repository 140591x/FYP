`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:33:27 08/21/2014 
// Design Name: 
// Module Name:    encoder 
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
module encoder(
   input wire [71:0] encoder_in, //encoder_in[0] -> TXC<0> ... encoder_in[7] -> TXC<7>
	                              //encoder_in[8] -> TXD<0> ... encoder_in[71] -> TXD<63> 
											//encoder_in[0] -> encoder_in[15:8] ... encoder_in[7] -> encoder_in[71:64]  
											//XLGMII Lane<0> -> encoder_in[15:8] ... Lane<7> -> encoder_in[71:64]
	input wire TX_CLK,
	input wire reset,
	output reg [65:0] encoder_data_out
);

//Constants
localparam TX_INIT = 3'b000;
localparam TX_C = 3'b001;
localparam TX_D = 3'b010;
localparam TX_E = 3'b011;
localparam TX_T = 3'b100;

localparam S = 3'b000;
localparam C = 3'b001;
localparam E = 3'b010;
localparam D = 3'b011;
localparam T = 3'b100;

localparam EBLOCK_T = {7'h1E,7'h1E,7'h1E,7'h1E,7'h1E,7'h1E,7'h1E,7'h1E,8'h1E,2'b01};
localparam LBLOCK_T = {32'b0,8'h01,8'h00,8'h00,8'h4B,2'b01};
//

reg [2:0] encoder_state; 
reg [2:0] next_encoder_state;								 
reg [65:0] next_encoder_data_out;

reg [71:0] encoder_in_buffer;

wire [2:0] t_type;
wire [65:0] encoder_func_out; 

T_TYPE t_type_mod(.encoder_in(encoder_in),.t_type(t_type));
encode_func encode_func_mod(.encoder_in_buffer(encoder_in_buffer),.encoder_func_out(encoder_func_out));
 								 
always@(posedge TX_CLK,negedge reset)
begin
	if(~reset) begin
			encoder_state <= TX_INIT;
			encoder_data_out <= LBLOCK_T;
			encoder_in_buffer <= 0;
	end else begin			
			encoder_state <= next_encoder_state;
			encoder_data_out <= next_encoder_data_out;
			encoder_in_buffer <= encoder_in;
	end	
end
////////////////////////////////////////////////////
//next state generation
always@*
begin
	   case(encoder_state)
		   TX_INIT:
			begin
			   if(t_type == S)
				   next_encoder_state = TX_D;
				else if(t_type == C) 
               next_encoder_state = TX_C; 	
            else 
               next_encoder_state = TX_E;				
			end
			
			TX_C:
			begin
			   if(t_type == C)
				   next_encoder_state = encoder_state;
				else if(t_type == S) 
               next_encoder_state = TX_D; 	
            else 
               next_encoder_state = TX_E;				
			end
			
			TX_D:
			begin
			   if(t_type == D)
				   next_encoder_state = encoder_state;
				else if(t_type == T) 
               next_encoder_state = TX_T; 	
            else 
               next_encoder_state = TX_E;				
			end	

			TX_E:
			begin
			   if(t_type == T)
				   next_encoder_state = TX_T;
				else if(t_type == D) 
               next_encoder_state = TX_D; 	
            else if(t_type == C) 
               next_encoder_state = TX_C;
            else	
               next_encoder_state = encoder_state;				
			end	

			TX_T:
			begin
			   if(t_type == C)
				   next_encoder_state = TX_C;
				else if(t_type == S) 
               next_encoder_state = TX_D; 	
            else 
               next_encoder_state = TX_E;				
			end	

         default 
            next_encoder_state = TX_INIT;				
      endcase             	
end
/////////////////////////////////////////////////////

/////////////////////////////////////////////////////
//next_encoder_data_out generation
always @*
begin
   if(encoder_state == TX_INIT)
	   next_encoder_data_out = LBLOCK_T;
	else if(encoder_state == TX_E)	
	   next_encoder_data_out = EBLOCK_T;
	else
      next_encoder_data_out = encoder_func_out;	
end
/////////////////////////////////////////////////////

endmodule
