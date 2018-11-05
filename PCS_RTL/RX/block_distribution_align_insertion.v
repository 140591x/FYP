`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:59:04 08/23/2014 
// Design Name: 
// Module Name:    block_distribution_align_insertion 
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
module block_distribution_align_insertion(
   input wire [65:0] data_in,
	input wire TX_CLK,
	input wire reset,
	output reg [65:0] Lane_0_out=0,
	output reg [65:0] Lane_1_out=0,
	output reg [65:0] Lane_2_out=0,
	output reg [65:0] Lane_3_out=0,
	output reg CLK_OUT,
	input scram_rst,
	input wire tx_test_mode
);

reg scram_en;
wire [65:0] scrambler_out;
wire [65:0] scrambler_in;

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


wire [65:0] align_marker_Lane_0,align_marker_Lane_1,align_marker_Lane_2,align_marker_Lane_3;

reg [7:0] BIP3_Lane_0,BIP3_Lane_1,BIP3_Lane_2,BIP3_Lane_3,BIP7_Lane_0,BIP7_Lane_1,BIP7_Lane_2,BIP7_Lane_3,
          BIP3_Lane_0_next,BIP3_Lane_1_next,BIP3_Lane_2_next,BIP3_Lane_3_next,
			 BIP7_Lane_0_next,BIP7_Lane_1_next,BIP7_Lane_2_next,BIP7_Lane_3_next; 

localparam idle_pattern = 17'b00000000001111001;

reg [13:0] align_count,align_count_next; 
reg [2:0] track_reg,track_reg_next;
reg [1:0] dist_count,dist_count_next;
reg CLK_OUT_next;

reg [65:0] buffer_1,buffer_2,buffer_3,buffer_4,buffer_5,buffer_6,buffer_7,buffer_8,
           buffer_3_next,buffer_4_next,buffer_5_next,buffer_6_next,buffer_7_next,
           Lane_0_out_next,Lane_1_out_next,Lane_2_out_next,Lane_3_out_next;
			  
wire buffer_5_idle,buffer_6_idle,buffer_7_idle,buffer_8_idle;			  
 			  			  
////////////////////////////////////////////////////
always@(posedge TX_CLK,negedge reset)
begin
	if(~reset) begin
	   buffer_1 <= 0;
	   buffer_2 <= 0;
	   buffer_3 <= 0;
   	buffer_4 <= 0;
	   buffer_5 <= 0;
	   buffer_6 <= 0;
	   buffer_7 <= 0;
	   buffer_8 <= 0;
	
	   align_count <= 0;
	   track_reg <= 0;
	   dist_count <= 0;
	   CLK_OUT <= 0;
	
	   Lane_0_out <= 0;
	   Lane_1_out <= 0;
	   Lane_2_out <= 0;
	   Lane_3_out <= 0;	
	
      BIP3_Lane_0 <= 0;
	   BIP7_Lane_0 <= 0;
	   BIP3_Lane_1 <= 0;
	   BIP7_Lane_1 <= 0;
	   BIP3_Lane_2 <= 0;
	   BIP7_Lane_2 <= 0;
	   BIP3_Lane_3 <= 0;
	   BIP7_Lane_3 <= 0;
	end else begin			
	   buffer_1 <= buffer_2;
	   buffer_2 <= buffer_3;
	   buffer_3 <= scrambler_out;
	   buffer_4 <= buffer_4_next;
	   buffer_5 <= buffer_5_next;
	   buffer_6 <= buffer_6_next;
	   buffer_7 <= buffer_7_next;
	   buffer_8 <= data_in;
	
	   align_count <= align_count_next;
	   track_reg <= track_reg_next;
	   dist_count <= dist_count_next;
	   CLK_OUT <= CLK_OUT_next;
	
	   Lane_0_out <= Lane_0_out_next;
	   Lane_1_out <= Lane_1_out_next;
	   Lane_2_out <= Lane_2_out_next;
	   Lane_3_out <= Lane_3_out_next;	
	
      BIP3_Lane_0 <= BIP3_Lane_0_next;
	   BIP7_Lane_0 <= BIP7_Lane_0_next;
	   BIP3_Lane_1 <= BIP3_Lane_1_next;
	   BIP7_Lane_1 <= BIP7_Lane_1_next;
	   BIP3_Lane_2 <= BIP3_Lane_2_next;
	   BIP7_Lane_2 <= BIP7_Lane_2_next;
	   BIP3_Lane_3 <= BIP3_Lane_3_next;
	   BIP7_Lane_3 <= BIP7_Lane_3_next;
	end	
end
////////////////////////////////////////////////////

////////////////////////////////////////////////////
always@*
begin
   case(track_reg) 
      3'b000:
      begin
		   buffer_3_next = buffer_4; 
         buffer_4_next = buffer_5; 
         buffer_5_next = buffer_6; 
         buffer_6_next = buffer_7;
         buffer_7_next = buffer_8;  			
      end 

      3'b001:
      begin
		   buffer_3_next = buffer_5; 
         buffer_4_next = buffer_4; 
         buffer_5_next = buffer_6; 
         buffer_6_next = buffer_7;
         buffer_7_next = buffer_8;  			
      end  

      3'b010:
      begin
		   buffer_3_next = buffer_6; 
         buffer_4_next = buffer_4; 
         buffer_5_next = buffer_5; 
         buffer_6_next = buffer_7;
         buffer_7_next = buffer_8;  			
      end 

      3'b011:
      begin
		   buffer_3_next = buffer_7; 
         buffer_4_next = buffer_4; 
         buffer_5_next = buffer_5; 
         buffer_6_next = buffer_6;
         buffer_7_next = buffer_8;  			
      end	

      3'b100:
      begin
		   buffer_3_next = buffer_8; 
         buffer_4_next = buffer_4; 
         buffer_5_next = buffer_4; 
         buffer_6_next = buffer_4;
         buffer_7_next = buffer_4;  			
      end	

      default
      begin
		   buffer_3_next = buffer_3; 
         buffer_4_next = buffer_4; 
         buffer_5_next = buffer_5;
         buffer_6_next = buffer_6;
         buffer_7_next = buffer_7; 		   
      end
   endcase		
end
/////////////////////////////////////////////////////

/////////////////////////////////////////////////////
always@*
begin
   if( ( (align_count==14'd16382) && (dist_count==2'b10) ) ||
	    ( (align_count==14'd16382) && (dist_count==2'b11) ) || ( (align_count==14'd16383) && (dist_count==2'b00) )
		  || ( (align_count==14'd16383) && (dist_count==2'b01) ) )
	   track_reg_next = 3'b000;
   else 
   begin	
      case(track_reg)
         3'b000:
			   if( buffer_5_idle && buffer_6_idle &&
				    buffer_7_idle && buffer_8_idle)
				   track_reg_next = 3'b100;
            else if(buffer_5_idle && buffer_6_idle &&
				    buffer_7)
               track_reg_next = 3'b011;
            else if(buffer_5_idle && buffer_6_idle)
               track_reg_next = 3'b010;
            else if(buffer_5_idle)
               track_reg_next = 3'b001;
            else
               track_reg_next = track_reg;   				
			3'b001:
			   if( buffer_6_idle &&
				    buffer_7_idle && buffer_8_idle)
				   track_reg_next = 3'b100;
            else if(buffer_6_idle &&
				    buffer_7_idle)
               track_reg_next = 3'b011;
            else if(buffer_6_idle)
               track_reg_next = 3'b010;
            else
               track_reg_next = track_reg; 			
			3'b010:
			   if(buffer_7_idle && buffer_8_idle)
				   track_reg_next = 3'b100;
            else if(buffer_7_idle)
               track_reg_next = 3'b011;
            else
               track_reg_next = track_reg; 			
			3'b011:
			   if(buffer_8_idle)
				   track_reg_next = 3'b100;
            else
               track_reg_next = track_reg; 			
         3'b100:	
               track_reg_next = track_reg; 			
         default
			      track_reg_next = track_reg; 
      endcase			
	end	
end
/////////////////////////////////////////////////////

/////////////////////////////////////////////////////
always@*
begin
/////////////   

	if(dist_count == 2'b11)
       begin
			 if(align_count == 14'd16383)
				 align_count_next = 14'b0;
			 else
             align_count_next = align_count+14'b1; 				  
       end
   else			  
      align_count_next = align_count;  
/////////////
   if(dist_count == 2'b11)
     	dist_count_next = 2'b00;
	else	
	   dist_count_next = dist_count+2'b01;
/////////////
   if(dist_count == 2'b11)
	   if(align_count==14'd16383)
         begin
	         Lane_0_out_next = align_marker_Lane_0;
	      	Lane_1_out_next = align_marker_Lane_1;
	      	Lane_2_out_next = align_marker_Lane_2;
	      	Lane_3_out_next = align_marker_Lane_3;
         end		
		else
         begin
	         Lane_0_out_next = buffer_1;
	      	Lane_1_out_next = buffer_2;
	      	Lane_2_out_next = buffer_3;
	      	Lane_3_out_next = scrambler_out;
         end
   else	
      begin
	      Lane_0_out_next = Lane_0_out;
	   	Lane_1_out_next = Lane_1_out;
	   	Lane_2_out_next = Lane_2_out;
	   	Lane_3_out_next = Lane_3_out;
      end
/////////////	
   
	if((align_count==14'd16382 && dist_count == 2'b11) ||
      (align_count==14'd16383 && dist_count != 2'b11))
   	scram_en = 0;
	else
      scram_en = 1; 		

   if( (dist_count == 2'b11) || (dist_count == 2'b00) )	
      CLK_OUT_next = 1'b1; 
   else 
      CLK_OUT_next = 1'b0;	
/////////////	
end
/////////////////////////////////////////////////////

/////////////////////////////////////////////////////
always@*
begin
   if(dist_count == 2'b01)
      if(align_count == 14'd0)
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

            BIP7_Lane_0_next[0] = !BIP3_Lane_0_bit_0_temp;  
            BIP7_Lane_0_next[1] = !BIP3_Lane_0_bit_1_temp;
            BIP7_Lane_0_next[2] = !BIP3_Lane_0_bit_2_temp;
            BIP7_Lane_0_next[3] = !BIP3_Lane_0_bit_3_temp;
            BIP7_Lane_0_next[4] = !BIP3_Lane_0_bit_4_temp;
            BIP7_Lane_0_next[5] = !BIP3_Lane_0_bit_5_temp;
            BIP7_Lane_0_next[6] = !BIP3_Lane_0_bit_6_temp;
            BIP7_Lane_0_next[7] = !BIP3_Lane_0_bit_7_temp; 
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

            BIP7_Lane_1_next[0] = !BIP3_Lane_1_bit_0_temp;  
            BIP7_Lane_1_next[1] = !BIP3_Lane_1_bit_1_temp;
            BIP7_Lane_1_next[2] = !BIP3_Lane_1_bit_2_temp;
            BIP7_Lane_1_next[3] = !BIP3_Lane_1_bit_3_temp;
            BIP7_Lane_1_next[4] = !BIP3_Lane_1_bit_4_temp;
            BIP7_Lane_1_next[5] = !BIP3_Lane_1_bit_5_temp;
            BIP7_Lane_1_next[6] = !BIP3_Lane_1_bit_6_temp;
            BIP7_Lane_1_next[7] = !BIP3_Lane_1_bit_7_temp; 
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

            BIP7_Lane_2_next[0] = !BIP3_Lane_2_bit_0_temp;  
            BIP7_Lane_2_next[1] = !BIP3_Lane_2_bit_1_temp;
            BIP7_Lane_2_next[2] = !BIP3_Lane_2_bit_2_temp;
            BIP7_Lane_2_next[3] = !BIP3_Lane_2_bit_3_temp;
            BIP7_Lane_2_next[4] = !BIP3_Lane_2_bit_4_temp;
            BIP7_Lane_2_next[5] = !BIP3_Lane_2_bit_5_temp;
            BIP7_Lane_2_next[6] = !BIP3_Lane_2_bit_6_temp;
            BIP7_Lane_2_next[7] = !BIP3_Lane_2_bit_7_temp; 
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

            BIP7_Lane_3_next[0] = !BIP3_Lane_3_bit_0_temp;  
            BIP7_Lane_3_next[1] = !BIP3_Lane_3_bit_1_temp;
            BIP7_Lane_3_next[2] = !BIP3_Lane_3_bit_2_temp;
            BIP7_Lane_3_next[3] = !BIP3_Lane_3_bit_3_temp;
            BIP7_Lane_3_next[4] = !BIP3_Lane_3_bit_4_temp;
            BIP7_Lane_3_next[5] = !BIP3_Lane_3_bit_5_temp;
            BIP7_Lane_3_next[6] = !BIP3_Lane_3_bit_6_temp;
            BIP7_Lane_3_next[7] = !BIP3_Lane_3_bit_7_temp; 
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

            BIP7_Lane_0_next[0] = !BIP3_Lane_0_bit_0_temp_1;  
            BIP7_Lane_0_next[1] = !BIP3_Lane_0_bit_1_temp_1;
            BIP7_Lane_0_next[2] = !BIP3_Lane_0_bit_2_temp_1;
            BIP7_Lane_0_next[3] = !BIP3_Lane_0_bit_3_temp_1;
            BIP7_Lane_0_next[4] = !BIP3_Lane_0_bit_4_temp_1;
            BIP7_Lane_0_next[5] = !BIP3_Lane_0_bit_5_temp_1;
            BIP7_Lane_0_next[6] = !BIP3_Lane_0_bit_6_temp_1;
            BIP7_Lane_0_next[7] = !BIP3_Lane_0_bit_7_temp_1; 
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

            BIP7_Lane_1_next[0] = !BIP3_Lane_1_bit_0_temp_1;  
            BIP7_Lane_1_next[1] = !BIP3_Lane_1_bit_1_temp_1;
            BIP7_Lane_1_next[2] = !BIP3_Lane_1_bit_2_temp_1;
            BIP7_Lane_1_next[3] = !BIP3_Lane_1_bit_3_temp_1;
            BIP7_Lane_1_next[4] = !BIP3_Lane_1_bit_4_temp_1;
            BIP7_Lane_1_next[5] = !BIP3_Lane_1_bit_5_temp_1;
            BIP7_Lane_1_next[6] = !BIP3_Lane_1_bit_6_temp_1;
            BIP7_Lane_1_next[7] = !BIP3_Lane_1_bit_7_temp_1; 
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

            BIP7_Lane_2_next[0] = !BIP3_Lane_2_bit_0_temp_1;  
            BIP7_Lane_2_next[1] = !BIP3_Lane_2_bit_1_temp_1;
            BIP7_Lane_2_next[2] = !BIP3_Lane_2_bit_2_temp_1;
            BIP7_Lane_2_next[3] = !BIP3_Lane_2_bit_3_temp_1;
            BIP7_Lane_2_next[4] = !BIP3_Lane_2_bit_4_temp_1;
            BIP7_Lane_2_next[5] = !BIP3_Lane_2_bit_5_temp_1;
            BIP7_Lane_2_next[6] = !BIP3_Lane_2_bit_6_temp_1;
            BIP7_Lane_2_next[7] = !BIP3_Lane_2_bit_7_temp_1; 
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

            BIP7_Lane_3_next[0] = !BIP3_Lane_3_bit_0_temp_1;  
            BIP7_Lane_3_next[1] = !BIP3_Lane_3_bit_1_temp_1;
            BIP7_Lane_3_next[2] = !BIP3_Lane_3_bit_2_temp_1;
            BIP7_Lane_3_next[3] = !BIP3_Lane_3_bit_3_temp_1;
            BIP7_Lane_3_next[4] = !BIP3_Lane_3_bit_4_temp_1;
            BIP7_Lane_3_next[5] = !BIP3_Lane_3_bit_5_temp_1;
            BIP7_Lane_3_next[6] = !BIP3_Lane_3_bit_6_temp_1;
            BIP7_Lane_3_next[7] = !BIP3_Lane_3_bit_7_temp_1; 
            ////////////// 			   
         end   
   else
	   begin
         BIP3_Lane_0_next = BIP3_Lane_0; 
         BIP7_Lane_0_next = BIP7_Lane_0;
         BIP3_Lane_1_next = BIP3_Lane_1;
         BIP7_Lane_1_next = BIP7_Lane_1;
         BIP3_Lane_2_next = BIP3_Lane_2;
         BIP7_Lane_2_next = BIP7_Lane_2;
         BIP3_Lane_3_next = BIP3_Lane_3;
         BIP7_Lane_3_next = BIP7_Lane_3;			
		end
end
/////////////////////////////////////////////////////

assign buffer_5_idle = (buffer_5 == idle_pattern);
assign buffer_6_idle = (buffer_6 == idle_pattern);
assign buffer_7_idle = (buffer_7 == idle_pattern);
assign buffer_8_idle = (buffer_8 == idle_pattern);

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

///////////////////////////////////////////////////////
assign align_marker_Lane_0[1:0] = 2'b01;			 
assign align_marker_Lane_0[9:2] = 8'h90;
assign align_marker_Lane_0[17:10] = 8'h76;
assign align_marker_Lane_0[25:18] = 8'h47;
assign align_marker_Lane_0[41:34] = 8'h6F;
assign align_marker_Lane_0[49:42] = 8'h89;
assign align_marker_Lane_0[57:50] = 8'hB8;
assign align_marker_Lane_0[33:26] = BIP3_Lane_0;
assign align_marker_Lane_0[65:58] = BIP7_Lane_0;

assign align_marker_Lane_1[1:0] = 2'b01;			 
assign align_marker_Lane_1[9:2] = 8'hF0;
assign align_marker_Lane_1[17:10] = 8'hC4;
assign align_marker_Lane_1[25:18] = 8'hE6;
assign align_marker_Lane_1[41:34] = 8'h0F;
assign align_marker_Lane_1[49:42] = 8'h3B;
assign align_marker_Lane_1[57:50] = 8'h19;
assign align_marker_Lane_1[33:26] = BIP3_Lane_1;
assign align_marker_Lane_1[65:58] = BIP7_Lane_1;

assign align_marker_Lane_2[1:0] = 2'b01;			 
assign align_marker_Lane_2[9:2] = 8'hC5;
assign align_marker_Lane_2[17:10] = 8'h65;
assign align_marker_Lane_2[25:18] = 8'h9B;
assign align_marker_Lane_2[41:34] = 8'h3A;
assign align_marker_Lane_2[49:42] = 8'h9A;
assign align_marker_Lane_2[57:50] = 8'h64;
assign align_marker_Lane_2[33:26] = BIP3_Lane_2;
assign align_marker_Lane_2[65:58] = BIP7_Lane_2;

assign align_marker_Lane_3[1:0] = 2'b01;			 
assign align_marker_Lane_3[9:2] = 8'hA2;
assign align_marker_Lane_3[17:10] = 8'h79;
assign align_marker_Lane_3[25:18] = 8'h3D;
assign align_marker_Lane_3[41:34] = 8'h5D;
assign align_marker_Lane_3[49:42] = 8'h86;
assign align_marker_Lane_3[57:50] = 8'hC2;
assign align_marker_Lane_3[33:26] = BIP3_Lane_3;
assign align_marker_Lane_3[65:58] = BIP7_Lane_3;

///////////////////////////////////////////////////////

scrambler Scrambler(.data_in(scrambler_in),.clk(TX_CLK),.rst(reset),.scram_en(scram_en),
                     .data_out(scrambler_out),.scram_rst(scram_rst));
							
//tx_test_mode operation
assign scrambler_in = tx_test_mode ? {56'b0,8'h1E,2'b01} : buffer_3_next;
//////							

endmodule
