`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/29/2018 10:37:45 PM
// Design Name: 
// Module Name: data_trans
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


module data_trans(
    input clk,
    input rst,
    //FIFO-Packet Length
    input [15:0] MAClength,//in bytes
    input empty_l,
    output reg r_en_l,//simmillar to empty in fifio
    //FIFO-Packet Data
    input empty,
    output reg r_en,
    input [63:0] RDATA,
    //XLGMI
    output reg[63:0] TXD,
    output reg[7:0] TXC,
    //management module
    output reg LengthValid
    );
    //main states 
    parameter IDLE=3'd0,START=3'd1,BUSY=3'd2,STOP1=3'd3,STOP2=3'd5,IPG=3'd4;
    reg [2:0] PS,NS;
    //sub states of STOP
    parameter S0=3'd0,S1=3'd1,S2=3'd2,S3=3'd3,S4=3'd4,S5=3'd5,S6=3'd6,S7=3'd7;
    wire [2:0] S_S;//stop states
    reg [15:0]TX_CNT; //transmited bytes
    //TXD characters
    parameter I_C=8'h07,S_C=8'hfb,T_C=8'hfd,E_C=8'hfe;
    parameter PA=8'b10101010,SFD=8'b10101011;
    always@(posedge clk,posedge rst)begin
        if(rst)
            PS<=IDLE;
        else
            PS<=NS;
    end
    //sequential logic
    always@(posedge clk)begin
        case(NS)
            IDLE:begin
                LengthValid=1'b0;
                TX_CNT<=16'd8;//last 8 bytes handle in STOP stage
                TXC<=8'hff;
                TXD<={8{I_C}};
            end
            START:begin
                TXC<=8'h01;
                TXD<={SFD,{6{PA}},S_C};
            end
            BUSY:begin
                    //if(!empty)begin
                        //r_en<=1'b1;
                        TX_CNT<=TX_CNT+8;
                        TXC<=8'h00;
                        //TXD<={RDATA[7:0],RDATA[15:8],RDATA[23:16],RDATA[31:24],RDATA[39:32],RDATA[47:40],RDATA[55:48],RDATA[63:56]};
                        TXD<=RDATA;
 /*                       end
                    else begin
                        //r_en<=1'b0;
                        TXC<=8'hff;
                        TXD<={8{E_C}};;
                        end*/
            end
            STOP1:begin
                LengthValid=1'b1;
                case(S_S)
                S7:begin
                    TXC<=8'b10000000;
                    //TXD<={T_C,RDATA[15:8],RDATA[23:16],RDATA[31:24],RDATA[39:32],RDATA[47:40],RDATA[55:48],RDATA[63:56]};
                    TXD<={T_C,RDATA[63:8]};
                end
                S6:begin
                    TXC<=8'b11000000;
                    //TXD<={I_C,T_C,RDATA[23:16],RDATA[31:24],RDATA[39:32],RDATA[47:40],RDATA[55:48],RDATA[63:56]};
                    TXD<={I_C,T_C,RDATA[63:16]};
                end
                S5:begin
                    TXC<=8'b11100000;
                    //TXD<={{2{I_C}},T_C,RDATA[31:24],RDATA[39:32],RDATA[47:40],RDATA[55:48],RDATA[63:56]};
                    TXD<={{2{I_C}},T_C,RDATA[63:24]};
                end
                S4:begin
                    TXC<=8'b11110000;
                    //TXD<={{3{I_C}},T_C,RDATA[39:32],RDATA[47:40],RDATA[55:48],RDATA[63:56]};
                    TXD<={{3{I_C}},T_C,RDATA[63:32]};
                end
                S3:begin
                    TXC<=8'b11111000;
                    //TXD<={{4{I_C}},T_C,RDATA[47:40],RDATA[55:48],RDATA[63:56]};
                    TXD<={{4{I_C}},T_C,RDATA[63:40]};
                end
                S2:begin
                    TXC<=8'b11111100;
                    //TXD<={{5{I_C}},T_C,RDATA[55:48],RDATA[63:56]};
                    TXD<={{5{I_C}},T_C,RDATA[63:48]};
                end
                S1:begin
                    TXC<=8'b11111110;
                    //TXD<={{6{I_C}},T_C,RDATA[63:56]};
                    TXD<={{6{I_C}},T_C,RDATA[63:56]};
                end
                S0:begin
                    TXC<=8'hff;
                    //TXD<={RDATA[7:0],RDATA[15:8],RDATA[23:16],RDATA[31:24],RDATA[39:32],RDATA[47:40],RDATA[55:48],RDATA[63:56]};
                    TXD<=RDATA;
                end
            STOP2:begin
                LengthValid=1'b0;
                TXC<=8'hff;
                TXD<={{7{I_C}},T_C};
            end
            IPG:begin
                LengthValid=1'b0;
                TXC<=8'hff;
                TXD<={8{I_C}};
            end
            endcase
            end
        endcase
    end
    //combinational logic
    assign S_S=MAClength[2:0];
    always@(*)begin
        if(rst)begin
            NS=IDLE;
            r_en=1'b0;
            r_en_l=1'b0;
            end
        else begin
        case(PS)
            IDLE:begin
                if(!empty_l)begin
                    //NS=CLOCKE1;
                    r_en=1'b1;
                    r_en_l=1'b1;
                    NS=START;
                    end
                else begin
                    NS=IDLE;
                    r_en=1'b0;
                    r_en_l=1'b0;
                    end
            end
            START:begin
               if(TX_CNT<=MAClength) begin
                 r_en=1'b1;
                 r_en_l=1'b0;
                 NS=BUSY;
                 end
               else begin
                     r_en=1'b0;
                     r_en_l=1'b0;
                     NS=STOP1;
                 end;
            end
            BUSY:begin
               if(TX_CNT<=MAClength) begin
                    r_en=1'b1;
                    r_en_l=1'b0;
                    NS=BUSY;
                    end
               else begin
                        r_en=1'b0;
                        r_en_l=1'b0;
                        NS=STOP1;
                    end
            end
            STOP1:begin
                r_en<=1'b0;
                r_en_l=1'b0;
                if(S_S==3'd0)
                    NS=STOP2;
                else if(S_S>=3'd4) begin
                    NS=IPG;
                end
                else
                    NS=IDLE;
            end
            STOP2:begin
                r_en<=1'b0;
                r_en_l=1'b0;
                NS=IDLE;
            end
            IPG:begin
                NS=IDLE;
                r_en<=1'b0;
                r_en_l=1'b0;
            end
            default:begin
                r_en<=1'b0;
                r_en_l=1'b0;
                NS=IDLE;
            end
        endcase            
        end
    end
endmodule