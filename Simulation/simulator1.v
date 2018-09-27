`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: uom sl
// Engineer: Anushka Siriweera
//////////////////////////////////////////////////////////////////////////////////


module simulator();
    reg [7:0] rx_c;
    reg [63:0] rx_d;
    wire FRAME_DATA_FLAG;
    wire [7:0] LAST_BLK_DATA;
    reg ifg_done;
    reg frame_complete;
    reg rx_clk;
    wire new_frame;
    wire new_frame_blk2;
    wire new_frame_blk3;
   // wire [47:0] dest_address;
   // wire [47:0] source_address;
    //wire [15:0] len_typ; 
    wire inject_error;
    wire  eof;
    wire [11:0]FRAME_LENGTH;
    reg [11:0]counter;
    wire da_fail;
    wire BAD_FRAME;
    wire GOOD_FRAME;
    
    reg reset;
    wire [31:0] FCS; 
    wire FCS_INVALID;  
   
    wire large_error_b;
    wire large_error_q;
    wire large_error_e;
    wire small_error;
    wire length_error;
    wire [1:0] link_fault;
    control_data_decoder c_decode(
        .rx_c(rx_c),
        .rx_d(rx_d),
        .ifg_done(ifg_done),
        .frame_complete(frame_complete),
        .counter(FRAME_LENGTH),

        .new_frame(new_frame),
        .inject_error(inject_error),
        .EOF(eof),
      //  .len_typ(len_typ),
        .da_fail(da_fail)
    );
    
    rxDataCount dcount(
        .CLK(rx_clk),
        .RESETn(reset),
        .RX_CONTROL(rx_c),
        .SOF(new_frame),
        .EOF(eof),
        .FRAME_LENGTH(FRAME_LENGTH)
    );  
     
     rxFCSCheck fcs_check(
     .CLK(rx_clk),
     .RESETn(reset),
     .RX_CONTROL(rx_c),
     .DATA_IN(rx_d),
     .ERROR(inject_error),
     .EOF(eof),
     .FCS(FCS),
     .FCS_INVALID(FCS_INVALID)
     );
     
     Link_fault    fault_sig(
       .counter(FRAME_LENGTH),
       .rx_d(rx_d),
       .rx_c(rx_c),
       .rx_clk(rx_clk),
       .reset(reset),
       .link_fault(link_fault)     
     );
     
//     rxLenCheck Length_checker(
//    .large_error_b(large_error_b),
//    .large_error_q(large_error_q),
//    .large_error_e(large_error_e),
//    .small_error(small_error),
//    .length_error(length_error),
//    .RX_D(rx_d),
//     .CLK(rx_clk),
//    .RESETn(reset),
//    .FRAME_LENGTH(FRAME_LENGTH),
//    .EOF(eof)
//     ); 



rxLenTypeCheck Len_type_checker(
	.CLK(rx_clk),
	.FRAME_SIZE(FRAME_LENGTH),
	.LEN_TYPE(rx_d[47:32]),
//	.NEW_FRAME(new_frame),
	.EOF(eof),
	.RESETn(reset),
	.INVALID_LENGTH(length_error),
	.LARGE_ERROR_E(large_error_e) ,
    .LARGE_ERROR_Q(large_error_q) ,
    .LARGE_ERROR_B(large_error_b),
    .SMALL_ERROR(small_error)     
	);
	
rxStaticsInput Statics(
            .CLK(rx_clk),
            .RESETn(reset),
            .INVALID_LENGTH(length_error),
            .SMALL_ERROR(small_error),
            .DA_FAIL(da_fail),
            .COUNTER(FRAME_LENGTH),
            .EOF(eof),
            .BAD_FRAME(BAD_FRAME),
            .GOOD_FRAME(GOOD_FRAME)
        
        );
        
         decapsulator decap(
               .SOF(new_frame),
               .CLK(rx_clk),
               .RESETn(reset),
               .LENGTH_FIELD(rx_d[47:32]),
               .LAST_BLK_DATA(LAST_BLK_DATA),
               .FRAME_LENGTH(FRAME_LENGTH),
               .FRAME_DATA_FLAG(FRAME_DATA_FLAG)
               );

    initial
    begin
        rx_clk = 0;
       // rx_c = 8'b0;
       // rx_d = 64'b0;
        ifg_done =1;
        frame_complete=1;
        counter=0;
        reset =1;
        #2 reset = 0;
        #2 reset = 1;
       
    end
    always #2 rx_clk <= ~rx_clk;
      
    integer outfile0; //file descriptor
    integer outfile1;
    integer outfile_0; //file descriptor
    integer outfile_1;
   
    
      initial   begin
      #7
      outfile0 = $fopen("F:\\Academic\\FYP\\tries\\rx_mac_anushka\\dataIn.txt","r");   //"r" means reading and "w" means writing
      outfile1 = $fopen("F:\\Academic\\FYP\\tries\\rx_mac_anushka\\controlIn.txt","r");
      #3000 
      $fclose(outfile0);
      $fclose(outfile1);  
      end
      
        //read line by line.
        always @ (posedge rx_clk) begin
            if  (!$feof(outfile0)) begin //read until an "end of file" is reached.
                outfile_0=$fscanf(outfile0,"%h\n",rx_d); //scan each line and get the value as an hexadecimal, use %b for binary and %d for decimal.             
                $display("%h \n", outfile_0);
            end 
        end
        
        always @ (posedge rx_clk) begin
             if  (! $feof(outfile1)) begin //read until an "end of file" is reached.
                outfile_1=$fscanf(outfile1,"%b\n",rx_c); //scan each line and get the value as an hexadecimal, use %b for binary and %d for decimal.             
                $display("%h \n",outfile_1);
            end 
        end
        //once reading and writing is finished, close the file.
        
  
    
endmodule
