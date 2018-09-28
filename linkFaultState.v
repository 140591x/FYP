`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: uom sl
// Engineer: Anushka Siriweera
//////////////////////////////////////////////////////////////////////////////////

module Link_fault(
    input [63:0] rx_d,
    input [7:0] rx_c,
    input rx_clk,
    input reset,
    output link_fault
    
    );
    
    reg [1:0] seq_type;
    
    always @(rx_d,rx_c) begin
        if(rx_d == 64'h00_00_00_00_01_00_00_9C && rx_c == 8'b0000_0001)begin //local
            seq_type = 2'b10; 
        end
        else if ( rx_d == 64'h00_00_00_00_02_00_00_9C && rx_c == 8'b0000_0001) begin //remote
            seq_type = 2'b01;       
        end
        else begin
            seq_type = 2'b00; //ok
        end
    end
    
    reg [31:0] col_cnt;
    reg [7:0] seq_cnt;
    reg [2:0] state;
    reg [1:0] link_fault;
    reg [1:0] last_seq_type;
    always @ (posedge rx_clk or negedge reset)begin
        if(!reset ) begin
            seq_cnt<=0;
            link_fault <= 2'b00;
            state<=0;
        end
        else begin
            if(seq_type == 0 && col_cnt > 127 && (state ==3|| state == 1) ) begin // moving into state 0 -INIT
                seq_cnt<=0;
                link_fault <= 2'b00;
                state<=0;
            end
            // moving into state 1 - COUNT
            else if((seq_type >= 1  && seq_cnt<3 && seq_type == last_seq_type && state ==1) || state ==2 || (state ==0 && seq_type >= 1)) begin //local fault =01, captures all states--0,1 & 2
                seq_cnt <= seq_cnt +1;
                col_cnt <= 0;
                if(seq_type != 0) last_seq_type <=  seq_type;
                else last_seq_type <= last_seq_type;
                state <= 1;
            end
            else if(seq_type >= 1 && seq_type != last_seq_type && (state ==3|| state == 1)) begin  //moving into state 2 - NEW_FAULT_TYPE
                seq_cnt <= 0;
                state <= 2;
                last_seq_type <=  seq_type;
            end  
            // moving into state 3 - FAULT
            else if((seq_type >= 1  && seq_cnt>=3 && seq_type == last_seq_type && state ==1|| state == 3 && seq_type >= 1 && seq_type == last_seq_type)) begin //local fault =01
                col_cnt <= 0;
                link_fault <= seq_type;
                state <= 3;
            end 
            else if(seq_type == 0) col_cnt <= col_cnt+1;
            else state <= state;      //when the states are unchanged
        end
    end
    
endmodule
