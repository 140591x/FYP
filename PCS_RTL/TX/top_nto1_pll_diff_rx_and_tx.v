///////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2009 Xilinx, Inc.
// This design is confidential and proprietary of Xilinx, All Rights Reserved.
///////////////////////////////////////////////////////////////////////////////
//   ____  ____
//  /   /\/   /
// /___/  \  /   Vendor: Xilinx
// \   \   \/    Version: 1.0
//  \   \        Filename: top_nto1_pll_diff_rx_and_tx.v
//  /   /        Date Last Modified:  November 5 2009
// /___/   /\    Date Created: June 1 2009
// \   \  /  \
//  \___\/\___\
// 
//Device: 	Spartan 6
//Purpose:  	Example differential input receiver and transmitter for clock and data using PLL
//		Serdes factor and number of data lines are set by constants in the code
//Reference:
//    
//Revision History:
//    Rev 1.0 - First created (nicks)
//
///////////////////////////////////////////////////////////////////////////////
//
//  Disclaimer: 
//
//		This disclaimer is not a license and does not grant any rights to the materials 
//              distributed herewith. Except as otherwise provided in a valid license issued to you 
//              by Xilinx, and to the maximum extent permitted by applicable law: 
//              (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND WITH ALL FAULTS, 
//              AND XILINX HEREBY DISCLAIMS ALL WARRANTIES AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, 
//              INCLUDING BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-INFRINGEMENT, OR 
//              FITNESS FOR ANY PARTICULAR PURPOSE; and (2) Xilinx shall not be liable (whether in contract 
//              or tort, including negligence, or under any other theory of liability) for any loss or damage 
//              of any kind or nature related to, arising under or in connection with these materials, 
//              including for any direct, or any indirect, special, incidental, or consequential loss 
//              or damage (including loss of data, profits, goodwill, or any type of loss or damage suffered 
//              as a result of any action brought by a third party) even if such damage or loss was 
//              reasonably foreseeable or Xilinx had been advised of the possibility of the same.
//
//  Critical Applications:
//
//		Xilinx products are not designed or intended to be fail-safe, or for use in any application 
//		requiring fail-safe performance, such as life-support or safety devices or systems, 
//		Class III medical devices, nuclear facilities, applications related to the deployment of airbags,
//		or any other applications that could lead to death, personal injury, or severe property or 
//		environmental damage (individually and collectively, "Critical Applications"). Customer assumes 
//		the sole risk and liability of any use of Xilinx products in Critical Applications, subject only 
//		to applicable laws and regulations governing limitations on product liability.
//
//  THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS PART OF THIS FILE AT ALL TIMES.
//
//////////////////////////////////////////////////////////////////////////////

`timescale 1ps/1ps

module top_nto1_ddr_diff_rx_and_tx (

//Global reset
input wire        rstbtn_n,    //The pink reset button

//HDMI interface//////////
input wire [3:0]  RX0_TMDS,
input wire [3:0]  RX0_TMDSB,

output wire [2:0] LED,
  
input wire a,
input wire b,
input wire c,
input wire d,
input wire e,
input wire f,
////////////////////////////		

//LVDS serial interface	
input gen_clk_in_p,gen_clk_in_n,

output [3:0] dataout_p,dataout_n,
output clkout_p,clkout_n,

output wire hdmi_div_2_clk_out_p,
output wire hdmi_div_2_clk_out_n, 

/////////////////////////////

//FIFO testing
output reg LED_fifo_empty,
output reg LED_fifo_full,
input pb_in
//////////////
);	

// Parameters for serdes factor and number of IO pins

parameter integer     S = 6 ;			// Set the serdes factor to 8
parameter integer     D = 4 ;			// Set the number of inputs and outputs
parameter integer     DS = (D*S)-1 ;		// Used for bus widths = serdes factor * number of inputs - 1

// Parameters for clock generation

parameter [S-1:0] TX_CLK_GEN   = 6'b101010 ;	// Transmit a constant to make a clock

assign reset = ~rstbtn_n;

wire       	rst ;
wire	[DS:0] 	rxd ;				// Data from serdeses
reg	[DS:0] 	txd=0;				// Data to serdeses

wire [3:0] dataout_p,dataout_n;

reg [5:0] lane_0_rxd,lane_1_rxd,lane_2_rxd,lane_3_rxd;
reg [65:0] lane_0_rxd_buff,lane_1_rxd_buff,lane_2_rxd_buff,lane_3_rxd_buff;
reg [3:0] clk_gen_cnt=0;
reg [3:0] clk_gen_cnt_1=0;
reg lane0_rx_clk,lane1_rx_clk,lane2_rx_clk,lane3_rx_clk;
reg tx_clk_in=0;
reg [65:0] lane0_out_buff,lane1_out_buff,lane2_out_buff,lane3_out_buff;
wire [65:0] Lane_0_out,Lane_1_out,Lane_2_out,Lane_3_out;
reg [65:0] lane_0_rxd_registered,lane_1_rxd_registered,lane_2_rxd_registered,lane_3_rxd_registered;
wire tx_clk;

wire [14:0] tmds_data_15_bits; 
reg [71:0] enc_in,decoder_data_out_buff;
reg [1:0] clk_cnt;
reg rinc,winc;

wire [4:0] tmds_data0, tmds_data1, tmds_data2;
wire [2:0] tmdsint;

wire tmdsclk;

reg [4:0] tmdsclkint = 5'b00000;
reg toggle = 1'b0;

reg rempty_buff;
reg cnt_en,cnt_en_next; 
reg [71:0] enc_in_syn_coded;
reg [4:0] cnt_reg;
reg rinc_1,winc_1;
wire rempty;

wire [71:0] enc_in_syn,decoder_data_out_syn,decoder_data_out;

IBUFGDS #(
.DIFF_TERM("FALSE"), 
.IOSTANDARD("DEFAULT"), 
.IBUF_DELAY_VALUE("0") 
) IBUFGDS_inst (
.O(clk_out_2), 
.I(gen_clk_in_p), 
.IB(gen_clk_in_n)
);

	
assign rst = reset ; 				// active high reset pin

wire [65:0] Lane_0_out_syn,Lane_1_out_syn,Lane_2_out_syn,Lane_3_out_syn;
wire CLK_OUT;
reg tx_lane_clk=0;

always @ (posedge tx_bufg_x1) begin

   if(clk_gen_cnt_1 >= 4'd10)
      clk_gen_cnt_1 <= 4'b0;	
	else 
      clk_gen_cnt_1 <= clk_gen_cnt_1 + 4'b0001;

   if(clk_gen_cnt_1 == 4'd0 || clk_gen_cnt_1 == 4'd2 || clk_gen_cnt_1 == 4'd4 || 
	   clk_gen_cnt_1 == 4'd6) 
		tx_clk_in <= 1;
   else	
	   tx_clk_in <= 0;
		
   if(clk_gen_cnt_1 == 4'd0 || clk_gen_cnt_1 == 4'd1 || clk_gen_cnt_1 == 4'd2 || 
	   clk_gen_cnt_1 == 4'd3  || clk_gen_cnt_1 == 4'd4 )
	   tx_lane_clk <= 0;
   else 
      tx_lane_clk <= 1;			
		
	if(clk_gen_cnt_1 == 4'd0) begin	
	   lane0_out_buff <= Lane_0_out_syn;
	   lane1_out_buff <= Lane_1_out_syn;
	   lane2_out_buff <= Lane_2_out_syn;
	   lane3_out_buff <= Lane_3_out_syn;		
	end	
	else begin
      lane0_out_buff <= {lane0_out_buff[65:60],lane0_out_buff[65:60],lane0_out_buff[59:54],lane0_out_buff[53:48],
		                   lane0_out_buff[47:42],lane0_out_buff[41:36],lane0_out_buff[35:30],lane0_out_buff[29:24],
								 lane0_out_buff[23:18],lane0_out_buff[17:12],lane0_out_buff[11:6]};	
								 
      lane1_out_buff <= {lane1_out_buff[65:60],lane1_out_buff[65:60],lane1_out_buff[59:54],lane1_out_buff[53:48],
		                   lane1_out_buff[47:42],lane1_out_buff[41:36],lane1_out_buff[35:30],lane1_out_buff[29:24],
								 lane1_out_buff[23:18],lane1_out_buff[17:12],lane1_out_buff[11:6]};	

      lane2_out_buff <= {lane2_out_buff[65:60],lane2_out_buff[65:60],lane2_out_buff[59:54],lane2_out_buff[53:48],
		                   lane2_out_buff[47:42],lane2_out_buff[41:36],lane2_out_buff[35:30],lane2_out_buff[29:24],
								 lane2_out_buff[23:18],lane2_out_buff[17:12],lane2_out_buff[11:6]};	

      lane3_out_buff <= {lane3_out_buff[65:60],lane3_out_buff[65:60],lane3_out_buff[59:54],lane3_out_buff[53:48],
		                   lane3_out_buff[47:42],lane3_out_buff[41:36],lane3_out_buff[35:30],lane3_out_buff[29:24],
								 lane3_out_buff[23:18],lane3_out_buff[17:12],lane3_out_buff[11:6]};								 
	end
end

BUFG bufg_txclk (.I(tx_clk_in), .O(tx_clk));


fifo lane0_fifo_1(.wdata(Lane_0_out),.rdata(Lane_0_out_syn),
                .winc(1'b1),.rinc(1'b1),.wrst_n(~reset),.rrst_n(~reset),
					 .wclk(CLK_OUT),.rclk(tx_lane_clk));
					 
fifo lane1_fifo_1(.wdata(Lane_1_out),.rdata(Lane_1_out_syn),
                .winc(1'b1),.rinc(1'b1),.wrst_n(~reset),.rrst_n(~reset),
					 .wclk(CLK_OUT),.rclk(tx_lane_clk));

fifo lane2_fifo_1(.wdata(Lane_2_out),.rdata(Lane_2_out_syn),
                .winc(1'b1),.rinc(1'b1),.wrst_n(~reset),.rrst_n(~reset),
					 .wclk(CLK_OUT),.rclk(tx_lane_clk));

fifo lane3_fifo_1(.wdata(Lane_3_out),.rdata(Lane_3_out_syn),
                .winc(1'b1),.rinc(1'b1),.wrst_n(~reset),.rrst_n(~reset),
					 .wclk(CLK_OUT),.rclk(tx_lane_clk));
					 

always @ (posedge tx_bufg_x1) begin
	txd[20] <= lane0_out_buff[5];
	txd[16] <= lane0_out_buff[4];
	txd[12] <= lane0_out_buff[3];
	txd[8] <= lane0_out_buff[2];
	txd[4] <= lane0_out_buff[1];
	txd[0] <= lane0_out_buff[0];
	
	txd[21] <= lane1_out_buff[5];
	txd[17] <= lane1_out_buff[4];
	txd[13] <= lane1_out_buff[3];
	txd[9] <= lane1_out_buff[2];
	txd[5] <= lane1_out_buff[1];
	txd[1] <= lane1_out_buff[0];

	txd[22] <= lane2_out_buff[5];
	txd[18] <= lane2_out_buff[4];
	txd[14] <= lane2_out_buff[3];
	txd[10] <= lane2_out_buff[2];
	txd[6] <= lane2_out_buff[1];
	txd[2] <= lane2_out_buff[0];

	txd[23] <= lane3_out_buff[5];
	txd[19] <= lane3_out_buff[4];
	txd[15] <= lane3_out_buff[3];
	txd[11] <= lane3_out_buff[2];
	txd[7] <= lane3_out_buff[1];
	txd[3] <= lane3_out_buff[0];
end   

PCS_with_MDIO pcs(.lane0_data(lane_0_rxd_registered),
                  .lane1_data(lane_1_rxd_registered),
						.lane2_data(lane_2_rxd_registered),
						.lane3_data(lane_3_rxd_registered),
						.lane0_clk(lane0_rx_clk),
						.lane1_clk(lane1_rx_clk),
						.lane2_clk(lane2_rx_clk),
						.lane3_clk(lane3_rx_clk),
						.Lane_0_out(Lane_0_out),
						.Lane_1_out(Lane_1_out),
						.Lane_2_out(Lane_2_out),
						.Lane_3_out(Lane_3_out),
						.TX_CLK(tx_clk),
						.encoder_in(enc_in_syn_coded),
						.decoder_data_out(decoder_data_out),
						.RX_CLK_IN(tx_clk),
						.reset(reset),
						.loopback(1'b0),
						.tx_test_mode(1'b0),
						.rx_test_mode(1'b0),
						.CLK_OUT(CLK_OUT)
);
	
// Reference Clock Input genertaes IO clocks via 2 x BUFIO2

clock_generator_ddr_s8_diff #(
	.S 			(S))
inst_clkgen(
	.clk		(clk_out_2), 
	.ioclkap		(txioclkp),
	.ioclkan		(txioclkn),
	.serdesstrobea		(tx_serdesstrobe),
	.ioclkbp		(),
	.ioclkbn		(),
	.serdesstrobeb		(),
	.gclk			(tx_bufg_x1)) ;

// Transmitter Logic - Instantiate serialiser to generate forwarded clock

serdes_n_to_1_ddr_s8_diff #(
      	.S			(S),
      	.D			(1))
inst_clkout (
	.dataout_p  		(clkout_p),
	.dataout_n  		(clkout_n),
	.txioclkp    		(txioclkp),
	.txioclkn    		(txioclkn),
	.txserdesstrobe 	(tx_serdesstrobe),
	.gclk    		(tx_bufg_x1),
	.reset     		(rst),
	.datain  		(TX_CLK_GEN));			// Transmit a constant to make the clock

// Instantiate Outputs and output serialisers for output data lines

serdes_n_to_1_ddr_s8_diff #(
      	.S			(S),
      	.D			(D))
inst_dataout (
	.dataout_p  		(dataout_p),
	.dataout_n  		(dataout_n),
	.txioclkp    		(txioclkp),
	.txioclkn    		(txioclkn),
	.txserdesstrobe 	(tx_serdesstrobe),
	.gclk    		(tx_bufg_x1),
	.reset   		(rst),
	.datain  		(txd));	
		
//HDMI////////////////////////////

  /////////////////////////
  //
  // Input Port 0
  //
  /////////////////////////
  wire rx0_pclk, rx0_pclkx2, rx0_pclkx10, rx0_pllclk0;
  wire rx0_plllckd;
  wire rx0_reset;
  wire rx0_serdesstrobe;
  wire rx0_hsync;          // hsync data
  wire rx0_vsync;          // vsync data
  wire rx0_de;             // data enable
  wire rx0_psalgnerr;      // channel phase alignment error
  wire [7:0] rx0_red;      // pixel data out
  wire [7:0] rx0_green;    // pixel data out
  wire [7:0] rx0_blue;     // pixel data out
  wire [29:0] rx0_sdata;
  wire rx0_blue_vld;
  wire rx0_green_vld;
  wire rx0_red_vld;
  wire rx0_blue_rdy;
  wire rx0_green_rdy;
  wire rx0_red_rdy;

  dvi_decoder dvi_rx0 (
    //These are input ports
    .tmdsclk_p   (RX0_TMDS[3]),
    .tmdsclk_n   (RX0_TMDSB[3]),
    .blue_p      (RX0_TMDS[0]),
    .green_p     (RX0_TMDS[1]),
    .red_p       (RX0_TMDS[2]),
    .blue_n      (RX0_TMDSB[0]),
    .green_n     (RX0_TMDSB[1]),
    .red_n       (RX0_TMDSB[2]),
    .exrst       (~rstbtn_n),

    //These are output ports
	 .hdmi_div_2_clk_out_p(hdmi_div_2_clk_out_p),
	 .hdmi_div_2_clk_out_n(hdmi_div_2_clk_out_n),
	 
    .reset       (rx0_reset),
    .pclk        (rx0_pclk),
    .pclkx2      (rx0_pclkx2),
    .pclkx10     (rx0_pclkx10),
    .pllclk0     (rx0_pllclk0), // PLL x10 output
    .pllclk1     (rx0_pllclk1), // PLL x1 output
    .pllclk2     (rx0_pllclk2), // PLL x2 output
    .pll_lckd    (rx0_plllckd),
    .tmdsclk     (rx0_tmdsclk),
    .serdesstrobe(rx0_serdesstrobe),
    .hsync       (rx0_hsync),
    .vsync       (rx0_vsync),
    .de          (rx0_de),

    .blue_vld    (rx0_blue_vld),
    .green_vld   (rx0_green_vld),
    .red_vld     (rx0_red_vld),
    .blue_rdy    (rx0_blue_rdy),
    .green_rdy   (rx0_green_rdy),
    .red_rdy     (rx0_red_rdy),

    .psalgnerr   (rx0_psalgnerr),

    .sdout       (rx0_sdata),
    .red         (rx0_red),
    .green       (rx0_green),
    .blue        (rx0_blue)); 

  wire rstin         = rx0_reset;
  wire pclk          = rx0_pclk;
  wire pclkx2        = rx0_pclkx2;
  wire pclkx10       = rx0_pclkx10;
  wire serdesstrobe  = rx0_serdesstrobe;
  wire [29:0] s_data = rx0_sdata;

  convert_30to15_fifo pixel2x (
    .rst     (rstin),
    .clk     (pclk),
    .clkx2   (pclkx2),
    .datain  (s_data),
    .dataout (tmds_data_15_bits)); //{tmds_data2, tmds_data1, tmds_data0} tmds_data_15_bits
	 
	 
	always@(posedge pclkx2) begin
	   enc_in <= {tmds_data_15_bits,enc_in[71:57],enc_in[56:42],enc_in[41:27],12'b0};   
	end
		
	always@(posedge pclkx2) begin
	   clk_cnt <= clk_cnt + 2'b01;
	end
	
	always@* begin
	   if(clk_cnt == 2'b00) begin
		   winc = 1'b1;
			rinc = 1'b1;
		end
		else begin
		   winc = 1'b0;
			rinc = 1'b0;		
		end
	end
	
			
	fifo_2 hdmiToPcs(.wdata(enc_in),.rdata(enc_in_syn),
                .winc(winc),.rinc(rinc_1),.wrst_n(~reset),.rrst_n(~reset),
					 .wclk(pclkx2),.rclk(tx_clk), .rempty(rempty),.wfull(wfull));

					 

  always@(posedge tx_clk) begin 
	  rempty_buff <= rempty;
	  cnt_en <= cnt_en_next;
  end
		
  always@* begin 
	  if({rempty_buff,rempty} == 2'b01) begin
	     cnt_en_next = 1'b1;
		  enc_in_syn_coded = {8'hFD,56'b0,8'b10000000};
		  rinc_1 = 1'b0;
	  end else begin
	     if(cnt_reg > 5'd10 && rempty == 1'b0 && cnt_en == 1'b1) begin
		  	  cnt_en_next = 1'b0;
		     enc_in_syn_coded = {56'b0,8'hFB,8'b00000001};
		     rinc_1 = 1'b0;
        end	
		  else if(cnt_en == 1'b1) begin
		     cnt_en_next = 1'b1;
		     enc_in_syn_coded = {8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'h07,8'hFF};
		     rinc_1 = 1'b0;
        end	else begin
		     cnt_en_next = 1'b0;
		     enc_in_syn_coded = enc_in_syn;
		     rinc_1 = 1'b1;		   
        end		  
     end	  
  end		
  
  always@(posedge tx_clk) begin
     if(cnt_en == 1'b1)
	     cnt_reg <= cnt_reg + 5'b1;
	  else
        cnt_reg <= 5'b0;	
  end		  
  
  //////////////////////////////////////
  // Status LED
  //////////////////////////////////////
  assign LED = {rx0_red_rdy, rx0_green_rdy, rx0_blue_rdy};
	
//////////////////////////////////	

//FIFO Testing
   always@(posedge tx_clk) begin 
	   if(pb_in == 1'b1) begin
		   LED_fifo_empty <= 0;
      end else if(rempty == 1'b1) begin
		   LED_fifo_empty <= 1'b1;
      end else begin
		   LED_fifo_empty <= LED_fifo_empty;
      end	

	   if(pb_in == 1'b1) begin
			LED_fifo_full <= 0;
      end else if(wfull == 1'b1) begin
		   LED_fifo_full <= 1'b1;
      end else begin
		   LED_fifo_full <= LED_fifo_full;
      end		
	end
//////////////

endmodule
