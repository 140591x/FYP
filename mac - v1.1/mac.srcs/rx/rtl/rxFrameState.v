`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: University of Moratuwa
// Engineer: S.D.S.Madusanka
// 
// Create Date: 09/28/2018 03:24:26 PM
// Design Name: MAC
// Module Name: rxFrameState
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


module rxFrameState #(
    parameter MIN_FRAME_SIZE = 512,
    parameter ADDRESS_SIZE = 48)(
    input CLK,
    input RSTn,
    input [15:0] LEN_TYPE,
    input [63:0] PLS_DATA_IND,
    input [7:0] PLS_DATA_IND_VALID,
    input FCS_VALID,
    input FRAME_START,
    input FRAME_END,
    output [63:0] PLS_DATA,
    output ERROR,
    output [2:0] DATA_VALID,
    output SOF,
    output EOF,
    output PAD_REMOVE
    );
    
    reg [2:0]data_valid;
    reg [15:0]byte_count;
    wire [8:0]pad_size;
    reg len_typ_error;
    reg sof;
    reg eof;
    reg pad_remove;
    reg [63:0]pls_data_pipe_01;
    reg [63:0]pls_data_pipe_02;
    reg [2:0]data_valid_encode;
    reg [7:0]pls_data_ind_valid_pipe_01;
    reg [7:0]pls_data_ind_valid_pipe_02;
    reg [15:0] frame_size_rec;
    reg [15:0] pad_end_size_rec;
    
    //****
    wire [15:0] frame_size;
    wire [15:0] pad_start_size;
    wire [15:0] pad_end_size;
    wire [15:0] packet_size;
    //****
    
    initial
    begin
        data_valid <= 3'd7;
        byte_count <= 16'd0;
//        pad_size <= 9'd0;
        len_typ_error <= 0;
        sof <= 0;
        eof <= 0;
        pad_remove <= 0;
        pls_data_pipe_01 <= 64'hbe61_9000_be61_9000;
        pls_data_pipe_02 <= 64'hbe61_9000_be61_9000;
        pls_data_ind_valid_pipe_01 <= 8'hff;
        pls_data_ind_valid_pipe_02 <= 8'hff;
    end
    
    assign DATA_VALID = data_valid;
    assign ERROR = FCS_VALID | len_typ_error;
    assign SOF = sof;
    assign EOF = FRAME_END;
    assign PAD_REMOVE = pad_remove;
    assign PLS_DATA = pls_data_pipe_02;
    assign packet_size = LEN_TYPE*8 + 2*ADDRESS_SIZE + 48;
    assign pad_size = (packet_size[15:9]==7'd0)?(MIN_FRAME_SIZE - (packet_size))/8:0;
    assign frame_size = LEN_TYPE + pad_size + 18;
    assign pad_start_size = LEN_TYPE + 14;
    assign pad_end_size = LEN_TYPE + pad_size + 14;
    
    always@(posedge CLK, negedge RSTn)
    begin
        if(~RSTn)
        begin
            data_valid <= 3'd0;
            data_valid_encode <= 3'd0;
            byte_count <= 16'd0;
//            pad_size <= 9'd0;
            len_typ_error <= 0;
            sof <= 0;
            eof <= 0;
            pad_remove <= 0;
            pls_data_pipe_01 <= 64'hbe61_9000_be61_9000;
            pls_data_pipe_02 <= 64'hbe61_9000_be61_9000;
            pls_data_ind_valid_pipe_01 <= 8'hff;
            pls_data_ind_valid_pipe_02 <= 8'hff;
            pad_end_size_rec <= 16'd0;
            frame_size_rec <= 16'd0;
        end
        
        else
        begin
            
            case(pls_data_ind_valid_pipe_01)
                8'b0000_0000: data_valid_encode <= 3'd7;
                8'b1000_0000: data_valid_encode <= 3'd6;
                8'b1100_0000: data_valid_encode <= 3'd5;
                8'b1110_0000: data_valid_encode <= 3'd4;
                8'b1111_0000: data_valid_encode <= 3'd3;
                8'b1111_1000: data_valid_encode <= 3'd2;
                8'b1111_1100: data_valid_encode <= 3'd1;
                8'b1111_1110: data_valid_encode <= 3'd0;
                default: data_valid_encode <= 3'd0;
            endcase
            
            data_valid <= data_valid_encode;
            frame_size_rec <= frame_size;
            pad_end_size_rec <= pad_end_size;
            
            //control signal piping
            pls_data_ind_valid_pipe_01 <= PLS_DATA_IND_VALID;
            pls_data_ind_valid_pipe_02 <= pls_data_ind_valid_pipe_01;
            
            //data pipe lining
            pls_data_pipe_01 <= PLS_DATA_IND;
            pls_data_pipe_02 <= pls_data_pipe_01;
            
            //pipe line sof and eof
            sof <= FRAME_START;
            
            eof <= FRAME_END;
            
            //pad size identification
            
            
            //pad remove
            if(pad_size > 0)
            begin
                if(byte_count[15:3] == pad_start_size[15:3])
                begin
                    pad_remove <= 1;
                end
                
                if(byte_count[15:3] == pad_end_size_rec[15:3])
                begin
                    pad_remove <= 0;
                end
            end
            else
            begin
                pad_remove <= 0;
            end
            
            //lenght/type checking
            if(pls_data_ind_valid_pipe_02 == 8'hff | FRAME_END)
            begin
                byte_count <= 16'd0;
                len_typ_error <= 0;
            end

            else
            begin
                byte_count <= byte_count + data_valid_encode + 1;
            end
            
            if(FRAME_END)
            begin
                if(frame_size_rec != byte_count)
                begin
                    len_typ_error <= 1;
                end
            end
            else
            begin
                len_typ_error <= 0;
            end
        end
    end 
    
    
endmodule
