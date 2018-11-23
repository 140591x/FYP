`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/27/2018 09:35:00 PM
// Design Name: 
// Module Name: D_FETCH
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


module D_FETCH(
    input clk,
    input rst,
    input [63:0] tx_data,
    input [2:0] v_b,//#number of valid bytes,always zero except eop can have value, 000---->indicates 8
    input sop,
    input eop,
    output reg tx_ready,
    input tx_valid, 
    input tx_error,
    //FIFO-Packet Data
    output reg [63:0] w_data,
    output reg w_en,
    output reg fifo_rst,
    input full,
    input [ADDR_WIDTH-1:0] BinaryCount,
    output reg [ADDR_WIDTH-1:0] BinaryCountReg,
    //FIFO-Packet Length
    output reg w_en_l,
    input full_l,
    output reg [15:0] MAClength,
    //CRC
    output reg crc_rst,
    output reg w_en_crc,
    output reg [2:0] v_b_crc,
    input [31:0] crc_val
    );
    //parameter minFrameSize=64-4;
    parameter MFS=16'd60;//bytes
    parameter ADDR_WIDTH = 9;

    //FIFO control
    parameter IDLE=3'd1,WRITE=3'd2,WAIT=3'd3,ERROR=3'd0,WRITECRC1=3'd4,WRITECRC2=3'd7,PADDING=3'd5,CLOCKE1=3'd6;
    reg [2:0] PS,NS;
    reg eop_status,t_okay;
    reg [15:0] t_length;
    
    //other Registers
    reg [63:0] w_dataReg;
    reg [2:0] v_bReg;
    reg [1:0] ccnt; //clock count
    //reg wcrc1; //to hold at state WRITECRC1 two cycles
    //reg [15:0] t_lengthReg;
    reg padded;
    reg padd1;
    //tx_ready
    always@(*)begin
        if(rst)
            tx_ready<=1'b0;
        else
            if((full || full_l) || (NS!=IDLE && NS!=WRITE))
                tx_ready<=1'b0;
            else
                tx_ready<=1'b1;    
    end
    //sequential logic
    always@(posedge clk or posedge rst)begin
        if (rst)
            PS<=IDLE;
        else
            PS<=NS;       
    end
    always@(posedge clk) begin
        case(NS)
            IDLE:begin
                //wcrc1=1'd0;
                ccnt=2'd0;
                v_b_crc=3'd0;
                padd1=1'd0;
                padded=1'b0;
                t_length<=15'd0;
                w_data<=64'd0;
                w_en<=1'b0;
                w_en_crc<=1'b0;
                w_en_l<=1'b0;
                fifo_rst<=1'b0;
                eop_status<=1'b0;
                t_okay=1'b0;
                crc_rst<=1'b0; 
            end
            WRITE:begin
                if(tx_valid)begin
                if(sop)
                    BinaryCountReg=BinaryCount;
                if(eop)begin
                    w_en<=1'b0;
                    w_en_crc<=1'b0;
                    w_dataReg<=tx_data;
                    v_bReg<=v_b;
                    t_length<=t_length+{11'd0,~(v_b[0]||v_b[1]||v_b[2]),v_b};
                    eop_status<=1'b1;  
                    if(tx_error)
                        t_okay<=1'b0;
                    else
                        t_okay<=1'b1;
                    end  
                else begin
                   t_length<=t_length+15'd8; 
                   w_data<=tx_data;
                   w_en<=1'b1;
                   w_en_crc<=1'b1;
                   end
               end
            end
            PADDING:begin
               padded<=1'b1;
               w_en<=1'b1;
               w_en_crc<=1'b1;
               if(padd1) begin
                   t_length<=t_length+15'd8;
                   w_data<=64'd0;//arbitary 
                   end
               else begin
                    padd1=1'd1;
                    case(v_bReg)
                        3'd0:begin 
                            w_data<=w_dataReg;
                        end
                        3'd1:begin 
                            w_data<={w_dataReg[63:56],56'd0};
                            t_length<=t_length+15'd7;
                        end
                        3'd2:begin 
                            w_data<={w_dataReg[63:48],48'd0};
                            t_length<=t_length+15'd6;
                        end
                        3'd3: begin
                            w_data<={w_dataReg[63:40],40'd0};
                            t_length<=t_length+15'd5;
                        end
                        3'd4:begin 
                            w_data<={w_dataReg[63:32],32'd0};
                            t_length<=t_length+15'd4;
                        end
                        3'd5:begin  
                            w_data<={w_dataReg[63:24],24'd0};
                            t_length<=t_length+15'd3;
                        end
                        3'd6:begin 
                            w_data<={w_dataReg[63:16],16'd0};
                            t_length<=t_length+15'd2;
                        end
                        3'd7:begin
                            w_data<={w_dataReg[63:8],8'd0};
                            t_length<=t_length+15'd1;
                        end
                    endcase
               end
            end
            WRITECRC1:begin
               ccnt<=ccnt+2'd1;
               case(ccnt)
               2'd0:begin
                   w_en_crc<=1'b1; 
                   w_en<=1'b0;
                   w_en_l<=1'b1;
               end
               2'd1:begin
                   w_en_crc<=1'b0; 
                   w_en<=1'b0;
                   w_en_l<=1'b0;
               end
               2'd2:begin
                   w_en_crc<=1'b0; 
                   w_en<=1'b1;
                   w_en_l<=1'b0;
               end                            
               endcase

               if(padded) begin
                    MAClength<=MFS+15'd4;
                    w_data<={32'd0,crc_val};
                    v_b_crc<=3'd2;
                    end
               else begin;
                    MAClength<=t_length+15'd4;
                    v_b_crc<=v_bReg;
                    case(v_bReg)
                        3'd0:w_data<=w_dataReg;
                        3'd1:w_data<={w_dataReg[63:56],crc_val,24'd0};
                        3'd2:w_data<={w_dataReg[63:48],crc_val,16'd0};
                        3'd3:w_data<={w_dataReg[63:40],crc_val,8'd0};
                        3'd4:w_data<={w_dataReg[63:32],crc_val};
                        3'd5:w_data<={w_dataReg[63:24],crc_val[31:8]};
                        3'd6:w_data<={w_dataReg[63:16],crc_val[31:16]};
                        3'd7:w_data<={w_dataReg[63:8],crc_val[31:24]};
                    endcase
                    end
            end
            WRITECRC2:begin
                case(v_bReg)
                    3'd0:w_data<={crc_val,32'd0};
                    3'd5:w_data<={crc_val[7:0],56'd0};
                    3'd6:w_data<={crc_val[15:0],48'd0};
                    3'd7:w_data<={crc_val[23:0],40'd0};
                endcase
            end
            WAIT:begin
                w_en<=1'b0;
                w_en_crc<=1'b0;
            end
            ERROR:begin
                w_en<=1'b0;
                w_en_crc<=1'b0;
                fifo_rst<=1'b1;
            end
            CLOCKE1:begin
                ccnt=2'd0;
                padd1=1'd0;
                padded=1'b0;
                t_length<=15'd0;
                w_data<=64'd0;
                w_en<=1'b0;
                w_en_l<=1'b0;
                w_en_crc<=1'b0;
                fifo_rst<=1'b0;
                eop_status<=1'b0;
                t_okay=1'b0;
                crc_rst<=1'b1;
            end           
        endcase
    end
       
    //combinational logic
    always@(*)begin
        if(rst)
            NS=IDLE;
        else begin
            case(PS)
                IDLE:begin
                    if(!full && sop && tx_valid)begin
                        NS=WRITE;
                        end
                    else begin
                        NS=IDLE;
                        end
                end
                WRITE:begin
                    if((full || !tx_valid) && !eop_status)
                        NS=WAIT;
                    else if (!eop_status)
                        NS=WRITE;
                    else if(!t_okay)
                        NS=ERROR;
                    else if(t_length<MFS)
                        NS=PADDING; 
                    else
                        NS=WRITECRC1;
                end
                PADDING:begin
                    if(t_length>=(MFS-16'd4))
                        NS=WRITECRC1;
                    else
                        NS=PADDING;
                end
                WRITECRC1:begin
                    if(ccnt!=2'd3)begin
                       NS=WRITECRC1;
                    end
                    else if((v_bReg>=3'd5 || v_bReg==3'd0) && !padded)
                        NS=WRITECRC2;
                    else
                        NS=CLOCKE1;
                end
                WRITECRC2:begin
                    NS=CLOCKE1;
                end
                WAIT:begin
                    if(!full && tx_valid)
                        NS=WRITE;
                    else
                        NS=WAIT;
                end
                ERROR:begin
                    NS=CLOCKE1;
                end
                CLOCKE1:begin
                    NS=IDLE;
                end
            endcase
        end
    end
  
endmodule