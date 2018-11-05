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
output wire [3:0] TX0_TMDS,
output wire [3:0] TX0_TMDSB,
  
input wire a,
input wire b,
input wire c,
input wire d,
input wire e,
input wire f,
////////////////////////////		

//LVDS serial interface	
input		clk, 
output gen_clk_out_p,gen_clk_out_n,

input [3:0] datain_p,datain_n,
input clkin_p,clkin_n,

input hdmi_div_2_clk_in_p,
input hdmi_div_2_clk_in_n,
/////////////////////////////

//FIFO testing
output reg LED_hdmi_fifo_empty,
output reg LED_hdmi_fifo_full,
output reg LED_pcs_fifo_empty,
output reg LED_pcs_fifo_full,
input pb_in,
//////////////

//pcstohdmi Fifo mid point setting
input bt_mid,
//////////////

//error block detection
output reg Error_block_received
//////////////
);	

localparam ERROR = {8'hFE,8'hFE,8'hFE,8'hFE,8'hFE,8'hFE,8'hFE,8'hFE,8'hFF};

// Parameters for serdes factor and number of IO pins

parameter integer     S = 6 ;			// Set the serdes factor to 8
parameter integer     D = 4 ;			// Set the number of inputs and outputs
parameter integer     DS = (D*S)-1 ;		// Used for bus widths = serdes factor * number of inputs - 1

// Parameters for clock generation

parameter [S-1:0] TX_CLK_GEN   = 6'b101010 ;	// Transmit a constant to make a clock

assign reset = ~rstbtn_n;

reg [7:0] mid_cnt = 0;


OBUFDS #(
.IOSTANDARD("DEFAULT") // Specify the output I/O standard
) OBUFDS_inst (
.O(gen_clk_out_p), // Diff_p output (connect directly to top-level port)
.OB(gen_clk_out_n), // Diff_n output (connect directly to top-level port)
.I(clk_gen_out_sig) // Buffer input
);

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


IBUFG #(
.IOSTANDARD("DEFAULT"),
.IBUF_DELAY_VALUE("0") 
) IBUFG_inst (
.O(clk_out), 
.I(clk) 
);	


BUFG BUFG_inst_0 (
.O(clk_out_buff), // Clock buffer output
.I(clk_out) // Clock buffer input
);

PLL_BASE # (     //pcs_rx_clk=42.828
  .CLKIN_PERIOD(2.83),
  .CLKFBOUT_MULT(20), //set VCO to 10x of CLKIN
  .CLKOUT0_DIVIDE(15),
  .CLKOUT1_DIVIDE(15),
  .CLKOUT2_DIVIDE(15),
  .COMPENSATION("INTERNAL"),
  .DIVCLK_DIVIDE(11) // Division factor for all clocks (1 to 52)
) PLL_receiver(
  .CLKFBOUT(clkfbout),
  .CLKOUT0(pllclk0),
  .CLKOUT1(pllclk1),
  .CLKOUT2(pllclk2),
  .CLKOUT3(),
  .CLKOUT4(),
  .CLKOUT5(),
  .LOCKED(pll_lckd),
  .CLKFBIN(clkfbout),
  .CLKIN(CLKOUT0_buff),
  .RST(rst)
);

BUFG BUFG_inst_1 (
.O(pcs_rx_clk), // Clock buffer output
.I(pllclk0) // Clock buffer input
);


PLL_BASE # (   //forward clock 353.33 gives tx_clk = 42.828 // 355.55  53,3,3,5
  .CLKIN_PERIOD(10),
  .CLKFBOUT_MULT(53),
  .CLKOUT0_DIVIDE(3),
  .CLKOUT0_PHASE(0.0),
  .CLKOUT1_DIVIDE(3),
  .CLKOUT1_PHASE(180.0),
  .CLKOUT2_DIVIDE(3),
  .COMPENSATION("INTERNAL"),
  .DIVCLK_DIVIDE(5), // Division factor for all clocks (1 to 52)
  .REF_JITTER(0.010) // Input reference jitter (0.000 to 0.999 UI%)
) PLL_Ref_clk (
  .CLKFBOUT(CLKFBOUT),
  .CLKOUT0(CLKOUT0),
  .CLKOUT1(CLKOUT1),
  .CLKOUT2(CLKOUT2),
  .CLKOUT3(),
  .CLKOUT4(),
  .CLKOUT5(),
  .LOCKED(LOCKED),
  .CLKFBIN(CLKFBOUT),
  .CLKIN(clk_out),
  .RST(rst)
);


BUFG BUFG_inst_2 (
.O(CLKOUT0_buff), // Clock buffer output
.I(CLKOUT0) // Clock buffer input
);

BUFG BUFG_inst_3 (
.O(CLKOUT1_buff), // Clock buffer output
.I(CLKOUT1) // Clock buffer input
);
	
	
ODDR2 #(
   // The following parameters specify the behavior
   // of the component.
   .DDR_ALIGNMENT("NONE"), // Sets output alignment
                           // to "NONE", "C0" or "C1"
   .INIT(1'b0),    // Sets initial state of the Q 
                   //   output to 1'b0 or 1'b1
   .SRTYPE("SYNC") // Specifies "SYNC" or "ASYNC"
                   //   set/reset
)
ODDR2_inst (
   .Q(clk_gen_out_sig),   // 1-bit DDR output data
   .C0(CLKOUT0_buff), // 1-bit clock input
   .C1(CLKOUT1_buff), // 1-bit clock input
   .CE(1'b1), // 1-bit clock enable input
   .D0(1'b1), // 1-bit data input (associated with C0)
   .D1(1'b0), // 1-bit data input (associated with C1)
   .R(1'b0),   // 1-bit reset input
   .S(1'b0)    // 1-bit set input
);
	
assign rst = reset ; 				// active high reset pin

always @ (posedge rx_bufg_x1)				//rxd[0] is lane_0 first transmitted bit
                                       //rxd[20] is lane_0 last transmitted bit 
													//rxd[1] is lane_1 first transmitted bit 
													//rxd[21] is lane_1 last transmitted bit 
													
begin
	lane_0_rxd <= {rxd[20],rxd[16],rxd[12],rxd[8],rxd[4],rxd[0]}; 
	lane_1_rxd <= {rxd[21],rxd[17],rxd[13],rxd[9],rxd[5],rxd[1]}; 
	lane_2_rxd <= {rxd[22],rxd[18],rxd[14],rxd[10],rxd[6],rxd[2]}; 
	lane_3_rxd <= {rxd[23],rxd[19],rxd[15],rxd[11],rxd[7],rxd[3]}; 

   lane_0_rxd_buff[65:60] <= lane_0_rxd;
   lane_1_rxd_buff[65:60] <= lane_1_rxd;
   lane_2_rxd_buff[65:60] <= lane_2_rxd;
   lane_3_rxd_buff[65:60] <= lane_3_rxd;	
	
	lane_0_rxd_buff[59:54] <= lane_0_rxd_buff[65:60];
	lane_0_rxd_buff[53:48] <= lane_0_rxd_buff[59:54];
	lane_0_rxd_buff[47:42] <= lane_0_rxd_buff[53:48];
	lane_0_rxd_buff[41:36] <= lane_0_rxd_buff[47:42];
	lane_0_rxd_buff[35:30] <= lane_0_rxd_buff[41:36];
	lane_0_rxd_buff[29:24] <= lane_0_rxd_buff[35:30];
	lane_0_rxd_buff[23:18] <= lane_0_rxd_buff[29:24];
	lane_0_rxd_buff[17:12] <= lane_0_rxd_buff[23:18];	
	lane_0_rxd_buff[11:6] <= lane_0_rxd_buff[17:12];
	lane_0_rxd_buff[5:0] <= lane_0_rxd_buff[11:6];	
	
	lane_1_rxd_buff[59:54] <= lane_1_rxd_buff[65:60];
	lane_1_rxd_buff[53:48] <= lane_1_rxd_buff[59:54];
	lane_1_rxd_buff[47:42] <= lane_1_rxd_buff[53:48];
	lane_1_rxd_buff[41:36] <= lane_1_rxd_buff[47:42];
	lane_1_rxd_buff[35:30] <= lane_1_rxd_buff[41:36];
	lane_1_rxd_buff[29:24] <= lane_1_rxd_buff[35:30];
	lane_1_rxd_buff[23:18] <= lane_1_rxd_buff[29:24];
	lane_1_rxd_buff[17:12] <= lane_1_rxd_buff[23:18];	
	lane_1_rxd_buff[11:6] <= lane_1_rxd_buff[17:12];
	lane_1_rxd_buff[5:0] <= lane_1_rxd_buff[11:6];	

	lane_2_rxd_buff[59:54] <= lane_2_rxd_buff[65:60];
	lane_2_rxd_buff[53:48] <= lane_2_rxd_buff[59:54];
	lane_2_rxd_buff[47:42] <= lane_2_rxd_buff[53:48];
	lane_2_rxd_buff[41:36] <= lane_2_rxd_buff[47:42];
	lane_2_rxd_buff[35:30] <= lane_2_rxd_buff[41:36];
	lane_2_rxd_buff[29:24] <= lane_2_rxd_buff[35:30];
	lane_2_rxd_buff[23:18] <= lane_2_rxd_buff[29:24];
	lane_2_rxd_buff[17:12] <= lane_2_rxd_buff[23:18];	
	lane_2_rxd_buff[11:6] <= lane_2_rxd_buff[17:12];
	lane_2_rxd_buff[5:0] <= lane_2_rxd_buff[11:6];	

	lane_3_rxd_buff[59:54] <= lane_3_rxd_buff[65:60];
	lane_3_rxd_buff[53:48] <= lane_3_rxd_buff[59:54];
	lane_3_rxd_buff[47:42] <= lane_3_rxd_buff[53:48];
	lane_3_rxd_buff[41:36] <= lane_3_rxd_buff[47:42];
	lane_3_rxd_buff[35:30] <= lane_3_rxd_buff[41:36];
	lane_3_rxd_buff[29:24] <= lane_3_rxd_buff[35:30];
	lane_3_rxd_buff[23:18] <= lane_3_rxd_buff[29:24];
	lane_3_rxd_buff[17:12] <= lane_3_rxd_buff[23:18];	
	lane_3_rxd_buff[11:6] <= lane_3_rxd_buff[17:12];
	lane_3_rxd_buff[5:0] <= lane_3_rxd_buff[11:6];	

   if(clk_gen_cnt >= 4'd10)
      clk_gen_cnt <= 4'b0;	
	else 
      clk_gen_cnt <= clk_gen_cnt + 4'b0001;
	
   if(clk_gen_cnt == 4'd0 || clk_gen_cnt == 4'd1 || clk_gen_cnt == 4'd2 || 
	   clk_gen_cnt == 4'd3  || clk_gen_cnt == 4'd4 )
	   lane0_rx_clk <= 0;
   else 
      lane0_rx_clk <= 1;	
		
   if(clk_gen_cnt == 4'd2 || clk_gen_cnt == 4'd3 || clk_gen_cnt == 4'd4 || 
	   clk_gen_cnt == 4'd5  || clk_gen_cnt == 4'd6 )
	   lane1_rx_clk <= 0;
   else 
      lane1_rx_clk <= 1;

   if(clk_gen_cnt == 4'd5 || clk_gen_cnt == 4'd6 || clk_gen_cnt == 4'd7 || 
	   clk_gen_cnt == 4'd8  || clk_gen_cnt == 4'd9 )
	   lane2_rx_clk <= 0;
   else 
      lane2_rx_clk <= 1;		
   	
   if(clk_gen_cnt == 4'd7 || clk_gen_cnt == 4'd8 || clk_gen_cnt == 4'd9 || 
	   clk_gen_cnt == 4'd10  || clk_gen_cnt == 4'd0 )
	   lane3_rx_clk <= 0;
   else 
      lane3_rx_clk <= 1;	
end

wire [65:0] Lane_0_out_syn,Lane_1_out_syn,Lane_2_out_syn,Lane_3_out_syn;
wire CLK_OUT;
reg tx_lane_clk=0;
			
always @ (posedge lane0_rx_clk) begin
   lane_0_rxd_registered <= lane_0_rxd_buff;
end

always @ (posedge lane1_rx_clk) begin
   lane_1_rxd_registered <= lane_1_rxd_buff;
end

always @ (posedge lane2_rx_clk) begin
   lane_2_rxd_registered <= lane_2_rxd_buff;
end

always @ (posedge lane3_rx_clk) begin
   lane_3_rxd_registered <= lane_3_rxd_buff;
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
						.TX_CLK(pcs_rx_clk),
						.encoder_in(enc_in_syn_coded),
						.decoder_data_out(decoder_data_out),
						.RX_CLK_IN(pcs_rx_clk),
						.reset(reset),
						.loopback(1'b0),
						.tx_test_mode(1'b0),
						.rx_test_mode(1'b0),
						.CLK_OUT(CLK_OUT),
						.pcs_fifo_top_empty(pcs_fifo_top_empty),
						.pcs_fifo_top_full(pcs_fifo_top_full)
);
	
	
// Clock Input. Generate ioclocks via BUFIO2

serdes_1_to_n_clk_ddr_s8_diff #(
      	.S			(S),		
      	.DIFF_TERM		("TRUE"))		// Enable or disable diff termination
inst_clkin (
	.clkin_p   		(clkin_p),
	.clkin_n   		(clkin_n),
	.rxioclkp    		(rxioclkp),
	.rxioclkn   		(rxioclkn),
	.rx_serdesstrobe	(rx_serdesstrobe),
	.rx_bufg_x1		(rx_bufg_x1));

// Data Inputs

serdes_1_to_n_data_ddr_s8_diff #(
      	.S			(S),			
      	.D			(D),
      	.DIFF_TERM		("TRUE"))		// Enable or disable diff termination
inst_datain (
	.use_phase_detector 	(1'b1),			// '1' enables the phase detector logic
	.datain_p     		(datain_p),
	.datain_n     		(datain_n),
	.rxioclkp    		(rxioclkp),
	.rxioclkn   		(rxioclkn),
	.rxserdesstrobe 	(rx_serdesstrobe),
	.gclk    		(rx_bufg_x1),
	.bitslip   		(1'b0),
	.reset   		(rst),
	.data_out  		(rxd),
	.debug_in  		(2'b00),
	.debug    		());
	
	
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

  dvi_decoder dvi_rx0 (
    .tmdsclk_p   (hdmi_div_2_clk_in_p),
    .tmdsclk_n   (hdmi_div_2_clk_in_n),   
    .exrst       (~rstbtn_n),
    .reset       (rx0_reset),
    .pclk        (rx0_pclk),
    .pclkx2      (rx0_pclkx2),
    .pclkx10     (rx0_pclkx10), 
    .serdesstrobe(rx0_serdesstrobe)
  ); 


  // TMDS output
  wire rstin         = rx0_reset;
  wire pclk          = rx0_pclk;
  wire pclkx2        = rx0_pclkx2;
  wire pclkx10       = rx0_pclkx10;
  wire serdesstrobe  = rx0_serdesstrobe;

  //
  // Forward TMDS Clock Using OSERDES2 block
  //
  always @ (posedge pclkx2 or posedge rstin) begin
    if (rstin)
      toggle <= 1'b0;
    else
      toggle <= ~toggle;
  end

  always @ (posedge pclkx2) begin
    if (toggle)
      tmdsclkint <= 5'b11111;
    else
      tmdsclkint <= 5'b00000;
  end

  serdes_n_to_1 #(
    .SF           (5))
  clkout (
    .iob_data_out (tmdsclk),
    .ioclk        (pclkx10),
    .serdesstrobe (serdesstrobe),
    .gclk         (pclkx2),
    .reset        (rstin),
    .datain       (tmdsclkint));

  OBUFDS TMDS3 (.I(tmdsclk), .O(TX0_TMDS[3]), .OB(TX0_TMDSB[3])) ;// clock

  //
  // Forward TMDS Data: 3 channels
  //
  serdes_n_to_1 #(.SF(5)) oserdes0 (
             .ioclk(pclkx10),
             .serdesstrobe(serdesstrobe),
             .reset(rstin),
             .gclk(pclkx2),
             .datain(tmds_data0),
             .iob_data_out(tmdsint[0])) ;

  serdes_n_to_1 #(.SF(5)) oserdes1 (
             .ioclk(pclkx10),
             .serdesstrobe(serdesstrobe),
             .reset(rstin),
             .gclk(pclkx2),
             .datain(tmds_data1),
             .iob_data_out(tmdsint[1])) ;

  serdes_n_to_1 #(.SF(5)) oserdes2 (
             .ioclk(pclkx10),
             .serdesstrobe(serdesstrobe),
             .reset(rstin),
             .gclk(pclkx2),
             .datain(tmds_data2),
             .iob_data_out(tmdsint[2])) ;

  OBUFDS TMDS0 (.I(tmdsint[0]), .O(TX0_TMDS[0]), .OB(TX0_TMDSB[0])) ;
  OBUFDS TMDS1 (.I(tmdsint[1]), .O(TX0_TMDS[1]), .OB(TX0_TMDSB[1])) ;
  OBUFDS TMDS2 (.I(tmdsint[2]), .O(TX0_TMDS[2]), .OB(TX0_TMDSB[2])) ;
  

		
	always@(posedge pclkx2) begin
	   clk_cnt <= clk_cnt + 2'b01;			
	end
	
	always@* begin
	   if(clk_cnt == 2'b00) begin
		   winc = 1'b1;
		end
		else begin
		   winc = 1'b0;		
		end
	end
	
	always@* begin
	  if((mid_cnt == 8'd0) || (mid_cnt == 8'd250)) begin
	   if(clk_cnt == 2'b00) begin
			rinc = 1'b1;
		end
		else begin
			rinc = 1'b0;		
		end
	  end else begin
	      rinc = 1'b0;    
     end	  
	end	
			
	always@(posedge pclkx2) begin
	   if(clk_cnt == 2'b00) 
         decoder_data_out_buff <= decoder_data_out_syn;	
      else
         decoder_data_out_buff <= {15'b0,decoder_data_out_buff[71:57],
			   decoder_data_out_buff[56:42],decoder_data_out_buff[41:27],12'b0};		
	end
	
	
	assign tmds_data2 = decoder_data_out_buff[26:22];
	assign tmds_data1 = decoder_data_out_buff[21:17];
	assign tmds_data0 = decoder_data_out_buff[16:12];	
									 
	fifo_2 PcsTohdmi(.wdata(decoder_data_out),.rdata(decoder_data_out_syn),
                .winc(winc_1),.rinc(rinc),.wrst_n(~reset),.rrst_n(~reset),
					 .wclk(pcs_rx_clk),.rclk(pclkx2),.rempty(rempty_hdmi),.wfull(wfull_hdmi));
	
	
	//Fifo middle point
	
   always@(posedge pclkx2) begin
	   if(bt_mid == 1'b1) begin
		   mid_cnt <= 0;
      end else if(mid_cnt == 8'd250) begin
		   mid_cnt <= mid_cnt;
      end else begin
		   mid_cnt <= mid_cnt + 8'b1;
      end		
	end
	///////////

  always@* begin
     if(decoder_data_out[7:0] == 8'b0)
	     winc_1 = 1'b1;
     else
        winc_1 = 1'b0;	  
  end  
		  	
//////////////////////////////////	

//FIFO Testing
   always@(posedge pclkx2) begin 
	  //pcstoHDMI fifo
	   if(pb_in == 1'b1) begin
		   LED_hdmi_fifo_empty <= 0;
      end else if(rempty_hdmi == 1'b1) begin
		   LED_hdmi_fifo_empty <= 1'b1;
      end else begin
		   LED_hdmi_fifo_empty <= LED_hdmi_fifo_empty;
      end	

	   if(pb_in == 1'b1) begin
			LED_hdmi_fifo_full <= 0;
      end else if(wfull_hdmi == 1'b1) begin
		   LED_hdmi_fifo_full <= 1'b1;
      end else begin
		   LED_hdmi_fifo_full <= LED_hdmi_fifo_full;
      end	
     ////////
    
	  //PCS fifo top
	   if(pb_in == 1'b1) begin
		   LED_pcs_fifo_empty <= 0;
      end else if(pcs_fifo_top_empty == 1'b1) begin
		   LED_pcs_fifo_empty <= 1'b1;
      end else begin
		   LED_pcs_fifo_empty <= LED_pcs_fifo_empty;
      end	

	   if(pb_in == 1'b1) begin
			LED_pcs_fifo_full <= 0;
      end else if(pcs_fifo_top_full == 1'b1) begin
		   LED_pcs_fifo_full <= 1'b1;
      end else begin
		   LED_pcs_fifo_full <= LED_pcs_fifo_full;
      end
     //////////		
	end
//////////////

//Testing for error block receiving
always@(posedge pcs_rx_clk) begin
   if(pb_in == 1'b1) begin
	   Error_block_received <= 0;
	end else if(decoder_data_out == ERROR) begin
	   Error_block_received <= 1'b1; 
	end else begin
	   Error_block_received <= Error_block_received; 
	end
end
//////////////
endmodule
