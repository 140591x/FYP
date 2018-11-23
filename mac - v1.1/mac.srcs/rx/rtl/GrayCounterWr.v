//==========================================
// Function : Code Gray counter.
// Coder    : Alex Claros F.
// Date     : 15/May/2005.
//=======================================

`timescale 1ns/1ps

module GrayCounterWrite
   #(parameter   COUNTER_WIDTH = 9)
   
    (output reg  [COUNTER_WIDTH-1:0]    GrayCount_out,  //'Gray' code count output.
    
     input wire                         Enable_in,  //Count enable.
     input wire                         Clear_in,   //Count reset.
     input wire                         intRst,
     input wire [COUNTER_WIDTH-1:0]     BinaryCountReg,
     output reg [COUNTER_WIDTH-1:0]     BinaryCount,
     input wire                         Clk);

    /////////Internal connections & variables///////
    //reg    [COUNTER_WIDTH-1:0]         BinaryCount;

    /////////Code///////////////////////
    
    always @ (posedge Clk)
        if (Clear_in) begin
            BinaryCount   <= {COUNTER_WIDTH{1'b 0}} + 1;  //Gray count begins @ '1' with
            GrayCount_out <= {COUNTER_WIDTH{1'b 0}};      // first 'Enable_in'.
        end
        else if (intRst)begin
            BinaryCount <= BinaryCountReg;
            GrayCount_out <= {BinaryCountReg[COUNTER_WIDTH-1],
                              BinaryCountReg[COUNTER_WIDTH-2:0] ^ BinaryCountReg[COUNTER_WIDTH-1:1]};
        end
        else if (Enable_in) begin
            BinaryCount   <= BinaryCount + 1;
            GrayCount_out <= {BinaryCount[COUNTER_WIDTH-1],
                              BinaryCount[COUNTER_WIDTH-2:0] ^ BinaryCount[COUNTER_WIDTH-1:1]};
        end
    
endmodule