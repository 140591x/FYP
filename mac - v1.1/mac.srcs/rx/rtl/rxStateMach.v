`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: University of Moratuwa
// Engineer: S.D.S.Madusanka
// 
// Create Date: 09/28/2018 01:45:26 PM
// Design Name: MAC
// Module Name: rxStateMach
// Project Name: 40G Ethernet
// Target Devices: VC709
// Tool Versions: 2016.4
// Description: this block is a part of the MAC
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module rxStateMach(
    input CLK,
    input RSTn,
    input [7:0] PLS_DATA_IND_VALID,
    input [63:0] PLS_DATA_IND,
    input DA_VALID,
    output RX_DATA_CONT,
    output FRAME_START,
    output FRAME_END
    );
    
    wire valid;
    reg frame_start;
    reg frame_end;
    reg pre_valid; //logic 0 is for valid data
    reg valid_da;
    reg packet_start;
    
    assign valid = PLS_DATA_IND_VALID[0] & PLS_DATA_IND_VALID[1] & PLS_DATA_IND_VALID[2] & PLS_DATA_IND_VALID[3] & PLS_DATA_IND_VALID[4] & PLS_DATA_IND_VALID[5] & PLS_DATA_IND_VALID[6] & PLS_DATA_IND_VALID[7];
    assign FRAME_START = frame_start;
    assign FRAME_END = frame_end;
    assign RX_DATA_CONT = (~valid & valid_da) | DA_VALID;
    
    initial
    begin
        frame_start <= 0;
        frame_end <= 0;
        pre_valid <= 1;
        valid_da <= 0;
        packet_start <= 0;
    end
    
    always@(posedge CLK, negedge RSTn)
    begin
        if(~RSTn)
        begin
            frame_start <= 0;
            frame_end <= 0;
            pre_valid <= 1;
            valid_da <= 0;
        end
        
        else
        begin
            //record the previous state of the valid signal
            pre_valid <= valid;
            
            //record a valid DA frame
            if(DA_VALID)
            begin
                valid_da <= 1;
            end
            else if(valid)
            begin
                valid_da <= 0;
            end
            
            //assert the start of a frame
            if(~valid & pre_valid & PLS_DATA_IND == 64'hABAA_AAAA_AAAA_AAAA)
            begin
                packet_start <= 1;
            end
            else
            begin
                packet_start <= 0;
            end
            if(packet_start == 1)
            begin
                frame_start <= 1;
            end
            else
            begin
                frame_start <= 0;
            end
            
            //assert the end of a frame
            if(valid & ~pre_valid)
            begin
                frame_end <= 1;
            end
            else
            begin
                frame_end <= 0;
            end
        end
    end
    
    
endmodule
