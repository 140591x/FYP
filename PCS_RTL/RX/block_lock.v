`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:57:36 10/29/2014 
// Design Name: 
// Module Name:    block_lock 
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
module block_lock(
   input wire clk,
	input wire reset,
	input wire [65:0] data_in,
	output wire block_locked_signal,
	output reg [65:0] data_out
);

localparam INIT = 2'b00;
localparam RESET_CNT = 2'b01;
localparam TEST_SH = 2'b10;
localparam TEST_SH2 = 2'b11;

reg [131:0] buffer;
reg [6:0] position,next_position; 
reg [1:0] state,next_state;
reg [9:0] sh_cnt,next_sh_cnt;
reg block_locked,next_block_locked;
reg slip,sh_valid;
reg [6:0] sh_invld_cnt,next_sh_invld_cnt;

//////////////////////////
always@(posedge clk,negedge reset)
begin
	if(~reset) begin
      position <= 7'd0;
		state <= 2'b00;
		sh_cnt <= 10'b0;
		sh_invld_cnt <= 7'b0; 
		block_locked <= 1'b0;
		buffer <= 132'b0;
	end else begin			
      position <= next_position;
		state <= next_state;
		sh_cnt <= next_sh_cnt;
		sh_invld_cnt <= next_sh_invld_cnt; 
		block_locked <= next_block_locked;
		buffer <= {data_in,buffer[131:66]};
	end	
end
///////////////////////////
always@*
begin
   if(slip == 1'b0)
	   next_position = position;
	else if(position == 7'd65)
		next_position = 0;
   else			
      next_position = (position+7'd1);	
end
////////////////////////////

////////////////////////////
always@*
begin
   if(data_out[0] != data_out[1]) 
      sh_valid = 1'b1; 	
	else
      sh_valid = 1'b0; 	
end
////////////////////////////
always@*
begin
   case(position)
	   7'd0: data_out = buffer[131:66];
		7'd1: data_out = buffer[130:65];
		7'd2: data_out = buffer[129:64];
		7'd3: data_out = buffer[128:63];
	   7'd4: data_out = buffer[127:62];
		7'd5: data_out = buffer[126:61];
		7'd6: data_out = buffer[125:60];
		7'd7: data_out = buffer[124:59];	
	   7'd8: data_out = buffer[123:58];
		7'd9: data_out = buffer[122:57];
		7'd10: data_out = buffer[121:56];
		7'd11: data_out = buffer[120:55];
	   7'd12: data_out = buffer[119:54];
		7'd13: data_out = buffer[118:53];
		7'd14: data_out = buffer[117:52];
		7'd15: data_out = buffer[116:51];		
	   7'd16: data_out = buffer[115:50];
		7'd17: data_out = buffer[114:49];
		7'd18: data_out = buffer[113:48];
		7'd19: data_out = buffer[112:47];
	   7'd20: data_out = buffer[111:46];
		7'd21: data_out = buffer[110:45];
		7'd22: data_out = buffer[109:44];
		7'd23: data_out = buffer[108:43];	
	   7'd24: data_out = buffer[107:42];
		7'd25: data_out = buffer[106:41];
		7'd26: data_out = buffer[105:40];
		7'd27: data_out = buffer[104:39];
	   7'd28: data_out = buffer[103:38];
		7'd29: data_out = buffer[102:37];
		7'd30: data_out = buffer[101:36];
		7'd31: data_out = buffer[100:35];			
	   7'd32: data_out = buffer[99:34];
		7'd33: data_out = buffer[98:33];
		7'd34: data_out = buffer[97:32];
		7'd35: data_out = buffer[96:31];
	   7'd36: data_out = buffer[95:30];
		7'd37: data_out = buffer[94:29];
		7'd38: data_out = buffer[93:28];
		7'd39: data_out = buffer[92:27];	
	   7'd40: data_out = buffer[91:26];
		7'd41: data_out = buffer[90:25];
		7'd42: data_out = buffer[89:24];
		7'd43: data_out = buffer[88:23];
	   7'd44: data_out = buffer[87:22];
		7'd45: data_out = buffer[86:21];
		7'd46: data_out = buffer[85:20];
		7'd47: data_out = buffer[84:19];		
	   7'd48: data_out = buffer[83:18];
		7'd49: data_out = buffer[82:17];
		7'd50: data_out = buffer[81:16];
		7'd51: data_out = buffer[80:15];
	   7'd52: data_out = buffer[79:14];
		7'd53: data_out = buffer[78:13];
		7'd54: data_out = buffer[77:12];
		7'd55: data_out = buffer[76:11];	
	   7'd56: data_out = buffer[75:10];
		7'd57: data_out = buffer[74:9];
		7'd58: data_out = buffer[73:8];
		7'd59: data_out = buffer[72:7];
	   7'd60: data_out = buffer[71:6];
		7'd61: data_out = buffer[70:5];
		7'd62: data_out = buffer[69:4];
		7'd63: data_out = buffer[68:3];	
		7'd64: data_out = buffer[67:2];
		7'd65: data_out = buffer[66:1];
      default: data_out = 66'b0;		
	endcase
end
/////////////////////
always@*
begin
   case(state)
	   INIT: next_state = RESET_CNT;
		RESET_CNT: 
		   begin
			   if(block_locked)
				   next_state = TEST_SH2;
				else
				   next_state = TEST_SH;
			end
		TEST_SH:
		   begin
			   if(sh_cnt < 10'd64 && sh_valid)
				   next_state = TEST_SH;         
				else
				   next_state = RESET_CNT;   
         end			
		TEST_SH2:
		   begin
			   if(sh_cnt == 10'd1023 || sh_invld_cnt == 7'd65 )
				   next_state = RESET_CNT;         
				else
				   next_state = TEST_SH2;   
         end		
		default: next_state = INIT;
	endcase
end
/////////////////////
always@*
begin
   case(state)
	   INIT: 
		begin 
		   next_block_locked = 1'b0;
			next_sh_cnt = 10'b0;
			next_sh_invld_cnt = 7'b0;
			slip = 1'b0;
		end
		RESET_CNT: 
		begin
	   	next_block_locked = block_locked;
			next_sh_cnt = 10'b0;
			next_sh_invld_cnt = 7'b0;	
         slip = 1'b0;			
		end
		TEST_SH:
		   begin
			   if(!sh_valid) begin
				   next_block_locked = 1'b0;
		      	next_sh_cnt = sh_cnt;
		      	next_sh_invld_cnt = sh_invld_cnt;
               slip = 1'b1;
            end					
			   else if(sh_cnt == 10'd64) begin
				   next_block_locked = 1'b1;   
		      	next_sh_cnt = sh_cnt;
			      next_sh_invld_cnt	= sh_invld_cnt;
               slip = 1'b0;
            end					
				else begin
				   next_block_locked = block_locked;  
			      next_sh_cnt = sh_cnt+10'b1;
			      next_sh_invld_cnt = sh_invld_cnt;	
               slip = 1'b0;
            end					
         end			
		TEST_SH2:
		   begin
			   if(sh_invld_cnt == 7'd65) begin
				   next_block_locked = 1'b0; 
		       	next_sh_cnt = sh_cnt;
		       	next_sh_invld_cnt	= sh_invld_cnt;
               slip = 1'b1;
            end					
				else begin
				   next_block_locked = block_locked; 
			      next_sh_cnt = sh_cnt+10'b1;
					
					if(sh_valid)
					   next_sh_invld_cnt = sh_invld_cnt;
					else	
			         next_sh_invld_cnt = sh_invld_cnt+7'b1;	
						
               slip = 1'b0;	
            end					
         end		
		default: 
		begin
		   next_block_locked = 1'b0;
			next_sh_cnt = sh_cnt;
			next_sh_invld_cnt	= sh_invld_cnt;
			slip = 1'b0;
		end	
	endcase
end
//////////////////////
assign block_locked_signal = block_locked;

endmodule
