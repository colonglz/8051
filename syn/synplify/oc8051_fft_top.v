// synopsys translate_off
`include "../../rtl/verilog/oc8051_timescale.v"
// synopsys translate_on

module oc8051_fft_top(
	rst,
	clk,
	i_adc_input,
	i_adc_input_ready,
	o_dac_output,
	
	w_rasing_edge_adc_input_ready
);

	parameter fftpts = 1024;
	parameter INPUTWIDTH = 12;
	parameter OUTPUTWIDTH = 12;

	input rst, clk;
	input i_adc_input_ready;
	input [INPUTWIDTH - 1:0] i_adc_input;
	output [OUTPUTWIDTH -1:0] o_dac_output;

	reg [INPUTWIDTH - 1:0] reg_buff[fftpts - 1:0];

    reg sink_valid;
    reg[INPUTWIDTH - 1:0] sink_real;
    reg[INPUTWIDTH - 1:0] sink_imag;
	wire [10:0]    fftpts_in;
    wire [10:0]    fftpts_out;
	wire 		inverse;
	wire 		sink_sop;
    wire 		sink_eop;
	wire 		source_ready;
	wire 		sink_ready;
	wire [1:0]           sink_error;
	
	wire 		source_sop;
	wire 		source_eop;
    wire 		source_valid;
	wire [1:0]           source_error;
	wire [23 - 1: 0] source_real;
    wire [23 - 1: 0] source_imag;
	
	reg 	    start;
	integer cnt;
	reg    end_test;
	wire end_input;
	wire end_output;
	
	wire reset_n;
	assign reset_n = ~rst;
   /////////////////////////
   // Set FFT Direction     
   // '0' => FFT      
   // '1' => IFFT      
   assign inverse = 1'b0; 


  //no input error
  assign sink_error = 2'b0;
     
     
  // for example purposes, the ready signal is always asserted.
  assign source_ready = 1'b1;

  
  // Filling up buffer
  reg reg_adc_input_ready_buff;
  output w_rasing_edge_adc_input_ready;
  
  reg [9:0] reg_input_cnt = 10'h0;
  wire w_input_buffer_full;
  always@(posedge clk or posedge rst) begin
	if(rst) begin
		reg_input_cnt <= 10'h0;
	end
	// In this if, may be missing another condition to stop
	// the input of data if fft is working.
	else if( w_rasing_edge_adc_input_ready ) begin
		reg_buff[reg_input_cnt] <= i_adc_input;
		reg_input_cnt <= reg_input_cnt + 1'b1;
	end
  end
  // Here we detect rasing edge of i_adc_input_ready
  always @(posedge clk or posedge rst) begin
	if(rst) begin
		reg_adc_input_ready_buff <= 1'b0;
	end
	else begin
		reg_adc_input_ready_buff <= i_adc_input_ready;
	end
  end
  assign w_rasing_edge_adc_input_ready = (i_adc_input_ready & ~reg_adc_input_ready_buff) ? 1'b1 : 1'b0;
  
  assign w_input_buffer_full = ( reg_input_cnt == fftpts-1 ) ? 1'b1 : 1'b0;
  
   ///////////////////////////////////////////////////////////////////////////////////////////////
   // All FFT MegaCore input signals are registered on the rising edge of the input clock, clk and 
   // all FFT MegaCore output signals are output on the rising edge of the input clock, clk. 
   //////////////////////////////////////////////////////////////////////////////////////////////

  // start valid for first cycle to indicate that the buffer reading should start.
  always @ (posedge clk)
  begin
     if (reset_n == 1'b0)
       start <= 1'b1;
     else
       begin
         if (sink_valid == 1'b1 & sink_ready == 1'b1)
           start <= 1'b0;
       end
   end

  //sop and eop asserted in first and last sample of data
	always @ (posedge clk) begin
		if (reset_n == 1'b0)
			cnt <= 0;
		else begin
		if (sink_valid == 1'b1 & sink_ready == 1'b1) begin
			if (cnt == fftpts - 1)
				cnt <= 0;
			else
				cnt <= cnt + 1;
			end
		end
  end

  assign fftpts_in =  fftpts;

   // signal when all of the input data has been sent to the DUT
   assign end_input = (sink_eop == 1'b1 & sink_valid == 1'b1 & sink_ready == 1'b1 ) ? 1'b1 : 1'b0;
    
   // signal when all of the output data has be received from the DUT
   assign end_output = (source_eop == 1'b1 & source_valid == 1'b1 & source_ready == 1'b1 ) ? 1'b1 : 1'b0;
  

   // generate start and end of packet signals
   assign sink_sop = (cnt == 0 & w_input_buffer_full) ? 1'b1 : 1'b0 ;
   assign sink_eop = ( cnt == fftpts - 1 ) ? 1'b1 : 1'b0;

   //halt the input when done
    always @(posedge clk)
      begin
        if (reset_n == 1'b0)
          end_test <= 1'b0;
        else
          begin
            if (end_input == 1'b1)
             end_test <= 1'b1; 
          end
      end
   
   ///////////////////////////////////////////////////////////////////////////////////////////////
   // Read input data from files. Data is generated on the negative edge of the clock, clk, in the
   // testbench and registered by the core on the positive edge of the clock                                                                    \n";
   ///////////////////////////////////////////////////////////////////////////////////////////////
   //integer rc_x;
   //integer ic_x;
   always @ (posedge clk) begin
	  if(reset_n==1'b0) begin
	     sink_real<=12'b0;
	     sink_imag<=12'b0;
	     sink_valid <= 1'b0;
	  end
	  else begin
            // send in NUM_FRAMES_c of data or until the end of the file
	     if(/*(end_test == 1'b1) ||*/ (end_input == 1'b1)) begin
		    sink_real<=12'b0;
		    sink_imag<=12'b0;
		    sink_valid <= 1'b0;
	     end
	     else if ((sink_valid == 1'b1 & sink_ready == 1'b1 ) ||
                 //(start == 1'b1 & !(sink_valid == 1'b1 & sink_ready == 1'b0))) begin
					  (w_input_buffer_full == 1'b1 & !(sink_valid == 1'b1 & sink_ready == 1'b0))) begin
          //rc_x = $fscanf(data_rf,"%d",data_real_in_int);
          sink_real <= reg_buff[cnt];
          //ic_x = $fscanf(data_if,"%d",data_imag_in_int); 
		    //sink_imag <= data_imag_in_int;
			 sink_imag<=12'b0;
		    sink_valid <= 1'b1;
		 end 
       else begin
		    sink_real <= sink_real;
		    sink_imag <= sink_imag;
		    sink_valid <= 1'b1;
		 end
	  end
   end

/////////////////////////////////////
// FFT Module Instantiation                                                               
//////////////////////////////////////
fft dut(
			.clk(clk),
			.reset_n(!int_rst),
			//////////////////////
			// Set FFT Direction     
			// '0' => FFT      
			// '1' => IFFT
			.inverse(1'b0),
			.fftpts_in(fftpts_in),
			.fftpts_out(fftpts_out),
			.sink_real(sink_real),
			.sink_imag(sink_imag),
			.sink_sop(sink_sop),
			.sink_eop(sink_eop),
			.sink_valid(sink_valid),
						 .sink_error(sink_error),
						 .source_error(source_error),
			.source_ready(source_ready),
			.sink_ready(sink_ready),
			.source_real(source_real),
			.source_imag(source_imag),
			.source_valid(source_valid),
			.source_sop(source_sop),
			.source_eop(source_eop)
			) /* synthesis noprune */;
			
endmodule
