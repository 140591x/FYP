`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: University of Moratuwa
// Engineer: S.D.S.Madusanka
// 
// Create Date: 09/30/2018 11:02:15 PM
// Design Name: rx synhronizer MAC interface
// Module Name: rxSynchr
// Project Name: 40G Ethernet
// Target Devices: VC709
// Tool Versions: 2016.4
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module rxSynchr(
    input CLK,
    input RSTn,
    input RX_CLK,
    input PAD_REMOVE,
    input RX_DATA_CONT,
    input [63:0] PLS_DATA,
    input ERROR,
    input [2:0] VALID,
    input SOF,
    input EOF,
    input RX_READ,
    output [63:0] MA_DATA,
    output MA_FRAME_ERROR,
    output [2:0] MA_DATA_VALID,
    output MA_FRAME_START,
    output MA_FRAME_END,
    output RX_READY
    );
    
    reg rx_data_cont_pipe_01;
    reg rx_data_cont_pipe_02;
    reg [63:0]pls_data_pipe;
    reg [2:0]valid_pipe;
    reg sof_pipe;
    reg eof_pipe;
    reg pad_remove_pipe;
    
    wire full;
    wire empty;
    wire [69:0]dout;
    wire [69:0]din;
    wire wr_en;
    wire rd_en;
    
    initial
    begin
        rx_data_cont_pipe_01 <= 0;
        rx_data_cont_pipe_02 <= 0;
        pls_data_pipe <= 0;
        valid_pipe <= 0;
        sof_pipe <= 0;
        eof_pipe <= 0;
        pad_remove_pipe <= 0;
    end
    
    assign wr_en = ~pad_remove_pipe & rx_data_cont_pipe_02;
    
    assign din[63:0] = pls_data_pipe;
    assign din[66:64] = valid_pipe;
    assign din[67] = ERROR;
    assign din[68] = eof_pipe;
    assign din[69] = sof_pipe;
    
    assign MA_DATA = dout[63:0];
    assign MA_DATA_VALID = dout[66:64];
    assign MA_FRAME_ERROR = dout[67];
    assign MA_FRAME_END = dout[68];
    assign MA_FRAME_START = dout[69];
    
    assign rd_en = RX_READ;
    
    assign RX_READY = ~empty;
    
data_FIFO #(    
    .DATA_WIDTH(70),
    .ADDRESS_WIDTH(9)) data_fifo_inst(
    .Data_out(dout), 
    .Empty_out(empty),
    .ReadEn_in(rd_en),
    .RClk(RX_CLK),        
    .Data_in(din),  
    .Full_out(full),
    .WriteEn_in(wr_en),
    .WClk(CLK),
    .BinaryCount(),
    .BinaryCountReg(),
    .intRst(~RSTn),                       
    .Clear_in(~RSTn));
    
    always@(posedge CLK)
    begin
        if(~RSTn)
        begin
            rx_data_cont_pipe_01 <= 0;
            rx_data_cont_pipe_02 <= 0;
            pls_data_pipe <= 0;
            valid_pipe <= 0;
            sof_pipe <= 0;
            eof_pipe <= 0;
            pad_remove_pipe <= 0;
        end
        
        else
        begin
            rx_data_cont_pipe_01 <= RX_DATA_CONT;
            rx_data_cont_pipe_02 <= rx_data_cont_pipe_01;
            pls_data_pipe <= PLS_DATA;
            valid_pipe <= VALID;
            sof_pipe <= SOF;
            eof_pipe <= EOF;
            pad_remove_pipe <= PAD_REMOVE;
        end
    end
    
endmodule
