`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/30/2018 10:07:00 AM
// Design Name: 
// Module Name: MAC_TX
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module MAC_TX(
    input t_clk,//for transmitter 625MHz
    input clk, //CPU clock
    input rst,
    input [63:0] tx_data,
    input tx_sop,
    input tx_eop,
    input [2:0] v_b,//#number of valid bytes,always one except eop can have other values
    output tx_ready,
    input tx_error,
    input tx_valid,
    output [63:0] TX_D,
    output [7:0] TX_C,
    output TX_CLK,
    output [15:0] MAClengthOut,
    output LengthValid //for management module
    );
    parameter ADDRESS_WIDTH=9,
              DATA_WIDTH=64;//FIFO
    //Packet Data FIFO
    wire [DATA_WIDTH-1:0] w_dataD;
    wire w_enD,fifo_rst,fullD,ReadEn_inD,Empty_outD;
    wire [ADDRESS_WIDTH-1:0] BinaryCount;
    wire [ADDRESS_WIDTH-1:0] BinaryCountReg;
    wire [63:0] Data_outD;
    //Packet Length FIFO
    wire w_en_l,full_l,empty_l,r_en_l;
    wire [15:0] MAClengthIn;
    //wire [15:0] MAClengthOut;
    //CRC
    wire crc_rst_top,crc_rst;
    wire [31:0] crc_val;
    wire w_en_crc;
    wire [2:0] v_b_crc;
    
    //Managment Status Register TX
    //assign txStateRegPlus={};
    
    assign TX_CLK=t_clk;
    
    D_FETCH D_FETCH_Top(
        .clk(clk),
        .rst(rst),
        .tx_data(tx_data),
        .v_b(v_b),
        .sop(tx_sop),
        .eop(tx_eop),
        .tx_ready(tx_ready),
        .tx_valid(tx_valid),
        .tx_error(tx_error),
        //FIFO-Packet Data
        .w_data(w_dataD),
        .w_en(w_enD),
        .fifo_rst(fifo_rst),
        .full(fullD),
        .BinaryCount(BinaryCount),
        .BinaryCountReg(BinaryCountReg),
        //FIFO-Packet Length
        .w_en_l(w_en_l),
        .full_l(full_l),
        .MAClength(MAClengthIn),
        //CRC
        .crc_rst(crc_rst),
        .crc_val(crc_val),
        .w_en_crc(w_en_crc),
        .v_b_crc(v_b_crc)
        );
        
    data_trans data_trans_top(
        .clk(t_clk),
        .rst(rst),
        //FIFO-Packet Length
        .MAClength(MAClengthOut),//in bytes
        .empty_l(empty_l),
        .r_en_l(r_en_l),//simmillar to empty in fifio
        //FIFO-Packet Data
        .empty(Empty_outD),
        .r_en(ReadEn_inD),
        .RDATA(Data_outD),
        //XLGMI
        .TXD(TX_D),
        .TXC(TX_C),
        //management module
        .LengthValid(LengthValid)
        );
        
    data_FIFO
          #(.DATA_WIDTH(DATA_WIDTH),
            .ADDRESS_WIDTH(ADDRESS_WIDTH),
            .FIFO_DEPTH(1 << ADDRESS_WIDTH))
             //Reading port
            data_FIFO_top(.Data_out(Data_outD), 
             .Empty_out(Empty_outD),
             .ReadEn_in(ReadEn_inD),
             .RClk(t_clk),        
             //Writing Ports
             .Data_in(w_dataD),  
             .Full_out(fullD),
             .WriteEn_in(w_enD),
             .WClk(clk),
             .BinaryCount(BinaryCount),
             .BinaryCountReg(BinaryCountReg),
             
             .intRst(fifo_rst), //reset from data_trans                        
             .Clear_in(rst));

    length_FIFO
          #(.DATA_WIDTH(16),
            .ADDRESS_WIDTH(ADDRESS_WIDTH-1),
            .FIFO_DEPTH(1 << (ADDRESS_WIDTH-1)))
             //Reading port
            length_FIFO_top(.Data_out(MAClengthOut), 
             .Empty_out(empty_l),
             .ReadEn_in(r_en_l),
             .RClk(t_clk),        
             //Writing Port
             .Data_in(MAClengthIn),  
             .Full_out(full_l),
             .WriteEn_in(w_en_l),
             .WClk(clk),
                                  
             .Clear_in(rst));  
     
     assign crc_rst_top=rst || crc_rst;
     CRC32_TX  CRC32_top(
                       .CLK(clk),
                       .RESET(crc_rst_top),
                       .DATA_IN(w_dataD),
                       .v_b(v_b_crc),
                       .w_en(w_en_crc),
                       .FCS(crc_val)
                     );
endmodule
