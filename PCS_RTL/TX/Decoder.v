`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:23:58 11/01/2014 
// Design Name: 
// Module Name:    decoder 
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
module decoder( 
	input wire [65:0] decoder_in,
	input wire RX_CLK,
	input wire reset,
	input wire deskew_done,
	output reg [71:0] decoder_data_out=LBLOCK_R,
   output reg [21:0] errored_block_count		
);
//Constant 

localparam RX_INIT=3'b000;
localparam RX_C=3'b001;
localparam RX_D=3'b010;
localparam RX_E=3'b011;
localparam RX_T=3'b100;

localparam S=3'b000;
localparam C=3'b001;
localparam E=3'b010;
localparam D=3'b011;
localparam T=3'b100;

localparam EBLOCK_R = {8'hFE,8'hFE,8'hFE,8'hFE,8'hFE,8'hFE,8'hFE,8'hFE,8'hFF};
localparam LBLOCK_R = {32'b0,8'h01,8'h00,8'h00,8'h9C,8'b00000001};

reg [2:0] decoder_state=RX_INIT;
reg [2:0] next_decoder_state;
reg [71:0] next_decoder_data_out;

reg [65:0] decoder_in_buffer=0;
reg [65:0] decoder_in_buffer2=0;

wire [2:0] r_type;
wire [2:0] r_type_next;
wire [71:0] decoder_func_out;

R_TYPE r_type_next_mod(.decoder_in(decoder_in),.r_type(r_type_next));
R_TYPE r_type_mod(.decoder_in(decoder_in_buffer),.r_type(r_type));
decode_func decode_func_mod(.decoder_in_buffer(decoder_in_buffer2),.decoder_func_out(decoder_func_out));

//errored_block_count generation
always@(posedge RX_CLK,negedge reset)
begin
	if(~reset)begin
		errored_block_count <= 0;
	end else begin
		if(errored_block_count == 22'h3FFFFF) begin
		   errored_block_count <= errored_block_count;   
		end else begin
		   if(decoder_state == RX_E)begin 
			   errored_block_count <= errored_block_count+22'b1;   
         end else begin
			   errored_block_count <= errored_block_count;
         end 			
		end
	end
end
//////

always@(posedge RX_CLK,negedge reset)
begin
	if(~reset||~deskew_done)begin
		decoder_state<=RX_INIT;
	end else begin
		decoder_state<=next_decoder_state;
	end
end

always@(posedge RX_CLK)
begin	
	decoder_data_out<=next_decoder_data_out;	
	decoder_in_buffer<=decoder_in;
	decoder_in_buffer2<=decoder_in_buffer;	
end

////////////////////////////////
//next state generation
always@*
begin
	case(decoder_state)
		RX_INIT:
			begin
				case(r_type)
					S:next_decoder_state=RX_D;
					C:next_decoder_state=RX_C;
					E:next_decoder_state=RX_E;
					D:next_decoder_state=RX_E;
					T:next_decoder_state=RX_E;
					default:next_decoder_state=RX_INIT;
				endcase
			end
			
		RX_C:
			begin
				case(r_type)
					C:next_decoder_state=decoder_state;
					S:next_decoder_state=RX_D;
					E:next_decoder_state=RX_E;
					D:next_decoder_state=RX_E;
					T:next_decoder_state=RX_E;
					default:next_decoder_state=RX_INIT;
				endcase
			end
			
		RX_D:
			begin
				case(r_type)
					D:next_decoder_state=decoder_state;
					T:
						if(r_type_next==S||r_type_next==C)
							next_decoder_state=RX_T;
						else
							next_decoder_state=RX_E;
					C:next_decoder_state=RX_E;
					S:next_decoder_state=RX_E;
					E:next_decoder_state=RX_E;
					default:next_decoder_state=RX_INIT;
				endcase
			end
		
		RX_E:
			begin
				case(r_type)
					D:next_decoder_state=RX_D;
					C:next_decoder_state=RX_C;
					T:
						if(r_type_next==S||r_type_next==C)
							next_decoder_state=RX_T;
						else
							next_decoder_state=decoder_state;
					E:next_decoder_state=decoder_state;
					S:next_decoder_state=decoder_state;
					default:next_decoder_state=RX_INIT;
				endcase
			end
			
		RX_T:
			begin
				case(r_type)
					C:next_decoder_state=RX_C;
					S:next_decoder_state=RX_D;
					D:next_decoder_state=RX_E;
					T:next_decoder_state=RX_E;
					E:next_decoder_state=RX_E;
					default:next_decoder_state=RX_INIT;
				endcase
			end
		
		default: 
			next_decoder_state=RX_INIT;
	endcase	
end

/////////////////////////////////////
//next decoder_data_out generation
always@*
begin
	if(decoder_state==RX_INIT)
		next_decoder_data_out=LBLOCK_R;
	else if(decoder_state==RX_E)
		next_decoder_data_out=EBLOCK_R;
	else 
		next_decoder_data_out=decoder_func_out;
end


endmodule
