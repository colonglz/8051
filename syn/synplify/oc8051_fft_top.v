// synopsys translate_off
`include "../../rtl/verilog/oc8051_timescale.v"
// synopsys translate_on

module oc8051_fft_top(
	rst,
	clk,
	i_adc_input,
	i_adc_input_ready,
	o_dac_output,
    
    o_fifo_data,
    o_fifo_wr_rqst,
    i_fifo_wr_full,
    
    i_fft_filter_selector
);

    parameter fftpts = 1024;
    localparam headroom = 40;
    localparam totalbuffer = fftpts + headroom;
    parameter INPUTWIDTH = 12;
    parameter OUTPUTWIDTH = 12;
    localparam SOURCEWIDTH = 12;
    
    output [11:0] o_fifo_data;
    output o_fifo_wr_rqst;
    input i_fifo_wr_full;

    input rst, clk;
    input i_adc_input_ready;
    input [INPUTWIDTH - 1:0] i_adc_input;
    output [OUTPUTWIDTH -1:0] o_dac_output;
    
    input [1:0] i_fft_filter_selector;

    reg [INPUTWIDTH - 1:0] reg_buff[fftpts + headroom - 1:0];
    reg [INPUTWIDTH:0] r_index_h;
    reg [INPUTWIDTH:0] r_index_l;

    reg sink_valid;
    reg signed [INPUTWIDTH - 1:0] sink_real;
    reg signed [INPUTWIDTH - 1:0] sink_imag;
    wire [10:0]    fftpts_in;
    wire [10:0]    fftpts_out;
	reg 		sink_sop;
    wire 		sink_eop;
	wire 		source_ready;
	wire 		sink_ready;
	wire [1:0]  sink_error;
	
	wire 		source_sop;
	wire 		source_eop;
    wire 		source_valid;
	wire [1:0]           source_error;
	wire signed [SOURCEWIDTH - 1: 0] source_real;
    wire signed [SOURCEWIDTH - 1: 0] source_imag;
    wire	[5:0]	w_source_exp;
	
	reg [INPUTWIDTH - 1 : 0] r_cnt;
	reg    end_test;
	wire end_input;
	wire end_output;
    
    wire w_input_buffer_full_rasing_edge;
	
	wire reset_n;
	assign reset_n = ~rst;
   /////////////////////////
   // Set FFT Direction     
   // '0' => FFT      
   // '1' => IFFT      
    reg [2:0] r_fft_state = 'h0;
    localparam IDLE = 0;
    localparam FEED_ADC = 1;        // feed adc input to fft
    localparam SAVE_FFT_OUTPUT = 2; // save fft output
    localparam START_MEM_READ = 3;
    localparam FEED_IFFT = 4;        // feed fft with fft output
    localparam SCALE_IFFT_OUTPUT = 5;
    
    wire signed [5:0] w_source_exp_1;
    wire signed [5:0] w_source_exp_2;
    
    wire w_filter_finish;
    wire [11:0] w_filter_data;
    wire [11:0] w_filter_data2;

  //no input error
  assign sink_error = 2'b0;
     
     
  // for example purposes, the ready signal is always asserted.
  assign source_ready = 1'b1;
  
  wire w_start_sink;
  assign w_start_sink = w_input_buffer_full_rasing_edge == 1'b1 & !(sink_valid == 1'b1 & sink_ready == 1'b0);

  
  // Filling up buffer
  reg reg_adc_input_ready_buff;
  wire w_rasing_edge_adc_input_ready;
  
  reg [9:0] reg_input_cnt = 10'h0;
  wire w_input_buffer_full;
  // Porpuse: Save adc input into buffer
  always@(posedge clk or posedge rst) begin
	if(rst) begin
		reg_input_cnt   <= 10'h0;
        r_index_h       <= 'h0;
	end
	else if( w_rasing_edge_adc_input_ready ) begin
		reg_buff[r_index_h] <= i_adc_input;
        if( r_index_h == totalbuffer - 1 ) begin
            r_index_h   <= 'h0;
        end
        else begin
            r_index_h <= r_index_h + 1'b1;
        end
        
		reg_input_cnt <= reg_input_cnt + 1'b1;
	end
  end
  
    // Porpuse: capture the new index low for the
    // circular buffer
    reg [INPUTWIDTH:0] r_next_index_l;
    always @(posedge clk or posedge rst) begin
        if(rst) begin
            r_index_l       <= 'h0;
            r_next_index_l  <= 'h0;
        end
        else begin
            if(w_input_buffer_full_rasing_edge) begin
                r_next_index_l  <= r_index_h;
            end
            else if ( sink_eop & r_fft_state == FEED_ADC ) begin
                r_index_l       <= r_next_index_l;
            end
        end
    end
    // Porpuse: detect rasing edge of i_adc_input_ready
    reg r_input_buffer_full_buff;
    
    always @(posedge clk or posedge rst) begin
        if(rst) begin
            reg_adc_input_ready_buff <= 1'b0;
            r_input_buffer_full_buff <= 1'b0;
        end
        else begin
            reg_adc_input_ready_buff <= i_adc_input_ready;
            r_input_buffer_full_buff <= w_input_buffer_full;
        end
    end
    assign w_rasing_edge_adc_input_ready = (i_adc_input_ready & ~reg_adc_input_ready_buff) ? 1'b1 : 1'b0;
  
    assign w_input_buffer_full = ( reg_input_cnt == fftpts-1 ) ? 1'b1 : 1'b0;
    assign w_input_buffer_full_rasing_edge = (w_input_buffer_full & ~r_input_buffer_full_buff) ? 1'b1 : 1'b0;
  
   ///////////////////////////////////////////////////////////////////////////////////////////////
   // All FFT MegaCore input signals are registered on the rising edge of the input clock, clk and 
   // all FFT MegaCore output signals are output on the rising edge of the input clock, clk. 
   //////////////////////////////////////////////////////////////////////////////////////////////

    //sop and eop asserted in first and last sample of data
    reg [INPUTWIDTH:0] r_sink_index;
    reg r_sink_index_saved;
    
	// Porpuse: provide the index from the ADC input buffer for data
    //          sent to fft, each clock cycle r_cnt will
    //          increase in 1 up to reach 1023. It will start
    //          to count when sink_sop is asserted.
    always @ (posedge clk) begin
		if (reset_n == 1'b0) begin
            r_cnt               <= 'h0;
            r_sink_index        <= 'h0;
            r_sink_index_saved  <= 1'b0;
		end
        else begin
            //if (sink_sop | r_sink_index_saved) begin
            if (r_fft_state == FEED_ADC | r_fft_state == FEED_IFFT | r_sink_index_saved) begin
                if( !r_sink_index_saved ) begin
                    r_sink_index_saved  <= 1'b1;
                end
                
                if ( r_sink_index == totalbuffer - 1 ) begin
                    r_sink_index <= 'h0;
                end
                else begin
                    r_sink_index <= r_sink_index + 'h1;
                end
                
                if (r_cnt == fftpts) begin
                    r_cnt               <= 'h0;
                    r_sink_index_saved  <= 1'b0;
                end
                else
                    r_cnt <= r_cnt + 1'b1;
            end
            else begin
                r_cnt               <= 'h0;
                r_sink_index        <= r_index_l;
                r_sink_index_saved  <= 1'b0;
            end
        end
  end

  assign fftpts_in =  fftpts;

   // signal when all of the input data has been sent to the DUT
   assign end_input = (sink_eop == 1'b1 & sink_valid == 1'b1 & sink_ready == 1'b1 ) ? 1'b1 : 1'b0;
    
   // signal when all of the output data has be received from the DUT
   assign end_output = (source_eop == 1'b1 & source_valid == 1'b1 & source_ready == 1'b1 ) ? 1'b1 : 1'b0;
  

   // generate start and end of packet signals
   assign sink_eop = ( r_cnt == fftpts ) ? 1'b1 : 1'b0;

   //halt the input when done
    always @(posedge clk) begin
        if (reset_n == 1'b0)
          end_test <= 1'b0;
        else begin
            if (end_input == 1'b1)
                end_test <= 1'b1; 
        end
    end
   
   ///////////////////////////////////////////////////////////////////////////////////////////////
   // Read input data from files. Data is generated on the negative edge of the clock, clk, in the
   // testbench and registered by the core on the positive edge of the clock                                                                    \n";
   ///////////////////////////////////////////////////////////////////////////////////////////////
   wire [11:0] w_fft_memory_o_data;
   wire [11:0] w_fft_memory_o_data2;
   reg r_fft_inverse;
   reg r_fft_memory_rd_start;
   reg r_sink_sop_flag = 1'b0;
   always @ (posedge clk) begin
	  if(reset_n==1'b0) begin
	     sink_real  <=12'b0;
	     sink_imag  <=12'b0;
	     sink_valid <= 1'b0;
         sink_sop   <= 1'b0;
         r_fft_inverse <= 1'b0;
         r_sink_sop_flag <= 1'b0;
	  end
	  else begin
         // send in NUM_FRAMES_c of data or until the end of the file
	     if( end_input == 1'b1 ) begin
		    sink_real   <= 12'b0;
		    sink_imag   <= 12'b0;
		    sink_valid  <= 1'b0;
            r_sink_sop_flag <= 1'b0;
	     end
	     else if( r_fft_state == FEED_ADC | r_fft_state == FEED_IFFT /*| sink_valid*/) begin   
            
            if( r_sink_sop_flag == 1'b0 ) begin
                sink_sop <= 1'b1;
                r_sink_sop_flag <= 1'b1;
            end
            else
                sink_sop <= 1'b0;
            
            if (r_fft_state == FEED_ADC ) begin
                // FFT receives a signed number, so we need to
                // adapt reg_buff since ADC input is only positive
                // numbers.
                sink_real       <= {1'b0,reg_buff[r_sink_index][11:1]}; 
                sink_imag       <= 12'b0;
                r_fft_inverse   <= 1'b0;
            end
            // FEED_IFFT
            else begin
                //sink_real   <= w_fft_memory_o_data;
                //sink_imag   <= w_fft_memory_o_data2;
                sink_real   <= w_filter_data;
                sink_imag   <= w_filter_data2;
                
                //sink_imag       <=12'b0;
                r_fft_inverse <= 1'b1;
            end
            
            if ( r_cnt == fftpts  ) begin
                sink_valid <= 1'b0;
                r_sink_sop_flag <= 1'b0;
            end
            else
                sink_valid <= 1'b1;
		 end
         else begin
              sink_real <= sink_real;
              sink_imag <= sink_imag;
              sink_valid <= sink_valid;
         end
	  end
   end
   
    // fft state machine
    // IDLE
    // FEED_ADC         fill fft with adc input
    // SAVE_FFT_OUTPUT  save to fft memory the fourier transmorm
    // FEED_IFFT         feed fft with fft output
    reg signed [13:0] r_source_scaled;
    reg r_delay2 = 1'b0;
    reg r_source_scaled_valid = 1'b0;
    always @(posedge clk or posedge rst) begin
        if( rst ) begin
            r_fft_memory_rd_start <= 1'b0;
            r_fft_state <= 'h0;
            r_delay2 <= 1'b0;
            r_source_scaled_valid <= 1'b0;
        end
        else begin
            case ( r_fft_state )
            IDLE: begin
                if(r_cnt == 0 & w_input_buffer_full_rasing_edge & sink_ready)
                    r_fft_state <= FEED_ADC;
            end
            
            FEED_ADC: begin
                if( sink_eop )
                    r_fft_state <= SAVE_FFT_OUTPUT;
            end
            
            SAVE_FFT_OUTPUT: begin
                if( source_eop )
                    r_fft_state <= START_MEM_READ;
            end
            
            START_MEM_READ: begin
                
                // two clock cycle delay
                if( r_delay2 ) // Delay to accoutn for filter
                    r_fft_state <= FEED_IFFT;
                else if(r_fft_memory_rd_start) begin
                    r_delay2 <= 1'b1;
                    r_fft_memory_rd_start <= 1'b0;
                end
                else begin
                    r_fft_memory_rd_start   <= 1'b1;
                end
            end
            
            FEED_IFFT: begin
                r_delay2 <= 1'b0;
                if( sink_eop ) // temporal
                    r_fft_state <= SCALE_IFFT_OUTPUT;
            end
            
            SCALE_IFFT_OUTPUT: begin
                if( source_valid ) begin
                    r_source_scaled <= source_real <<< -(w_source_exp_1 + w_source_exp_2 + 10); //Scaling
                    r_source_scaled_valid <= 1'b1;
                    
                    if(source_eop) begin
                        r_fft_state <= IDLE;
                        r_source_scaled_valid <= 1'b0;
                    end
                end
            end
            
            endcase
        end
    end
    
    assign w_source_exp_1 = ( r_fft_state == 2 && source_eop ) ? w_source_exp : w_source_exp_1;
    assign w_source_exp_2 = ( r_fft_state == 5 && source_sop ) ? w_source_exp : w_source_exp_2;
    
    // Purpose: Fill up fifo with filtered data
    reg r_fifo_wr_rqst  = 1'b0;
    reg [11:0]r_fifo_data     = 'h0;
    wire clk_n;
    assign clk_n = ~clk;
    always @(posedge clk_n or posedge rst) begin
        if(rst) begin
            r_fifo_wr_rqst  <= 1'b0;
            r_fifo_data     <= 'h0;
        end
        else begin
            if(r_fft_state           == SCALE_IFFT_OUTPUT && 
               r_source_scaled_valid == 1'b1              &&
               i_fifo_wr_full        == 1'b0                 ) begin
                
                r_fifo_wr_rqst  <= 1'b1;
                if ( (r_source_scaled + 2048) > 4095 ) begin
                    r_fifo_data <= 12'hfff;
                end
                else if ( (r_source_scaled + 2048) < 0 ) begin
                    r_fifo_data <= 12'h000;
                end
                else begin
                    r_fifo_data <= (r_source_scaled[11:0]*4) + 2048;
                    //r_fifo_data <= r_source_scaled;
                    //r_fifo_data <= 12'hAAA;
                end
            end
            else begin
                r_fifo_wr_rqst  <= 1'b0;
                r_fifo_data <= r_fifo_data;
            end
        end
    end
    assign o_fifo_data = r_fifo_data;
    assign o_fifo_wr_rqst = r_fifo_wr_rqst;
   
    fft_filter filter(
        .rst( rst ),
        .clk( clk ),
    
        .i_start( r_fft_memory_rd_start ),
        .o_finish( w_filter_finish ),
    
        .i_data( w_fft_memory_o_data ), // Real part
        .i_data2( w_fft_memory_o_data2 ), // Imaginary part
        .o_data( w_filter_data ), // Real part
        .o_data2( w_filter_data2 ), // Imaginary part
        
        .i_filter_selector( i_fft_filter_selector )
    );
   
   
    fft_output_handle fft_memory(
        .i_clk( clk ),
        .i_rst( rst ),
    
        .i_wr_start( source_sop ),
        .i_data( source_real ),
        .i_data2( source_imag ),
    
        .i_rd_start( r_fft_memory_rd_start ),
        .o_data( w_fft_memory_o_data ),  // Real part
        .o_data2( w_fft_memory_o_data2 ) // Imaginary part
    );
    
    
    assign o_dac_output = r_source_scaled;
   

    /////////////////////////////////////
    // FFT Module Instantiation                                                               
    //////////////////////////////////////
    fft dut(
        .clk(clk),
        .reset_n(!rst),
        //////////////////////
        // Set FFT Direction     
        // '0' => FFT      
        // '1' => IFFT
        .inverse(r_fft_inverse),
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
        .source_eop(source_eop),
        .source_exp(w_source_exp)
    ) /* synthesis noprune */;
	
endmodule


// This module saves the output of fft
// and outputs saved data when requested.
//
// i_wr_start indicates the start of write_address
//            operation. Each data will be saved
//            with each i_clock cycle until reach
//            ELEMENTS
// i_data     Data to write in memory
// i_rd_start indicates the start of read data
//            it will start at 0 an finish at
//            ElEMENTS
// o_data     Read data.
module fft_output_handle(
    i_clk,
    i_rst,
    
    i_wr_start,
    i_data,
    i_data2,
    
    i_rd_start,
    o_data,
    o_data2
);
    parameter DATA_WIDTH = 12;
    localparam ELEMENTS = 1024;
    localparam ELEMENTS_WIDTH = 10;
    
    input i_clk, i_rst;
    input i_wr_start;
    input [DATA_WIDTH -1:0] i_data;
    input [DATA_WIDTH -1:0] i_data2;
    
    input i_rd_start;
    output [DATA_WIDTH -1:0] o_data;
    output [DATA_WIDTH -1:0] o_data2;
    
    wire w_mem_we;
    reg r_start_hold = 1'b0;
    //reg [ELEMENTS_WIDTH -1:0] index = 'h0;
    
    reg r_rd_start_hold = 1'b0;
    reg [ELEMENTS_WIDTH -1:0] r_rd_index = 'h0;
    reg [ELEMENTS_WIDTH -1:0] r_wr_index = 'h0;
    
    // Porpuse: Fill up the memory when i_wr_start
    // is asserted.
    always @(posedge i_clk or posedge i_rst) begin
        if(i_rst) begin
            r_start_hold    <= 1'b0;
            r_wr_index      <= 'h0;
        end
        else begin
            if( i_wr_start | r_start_hold ) begin
                if(r_wr_index == (ELEMENTS - 1) ) begin
                    r_start_hold    <= 1'b0;
                    r_wr_index      <= 'h0;
                end
                else begin
                    r_start_hold    <= 1'b1;
                    r_wr_index      <= r_wr_index + 1'b1;
                end
            end
        end
    end
    
    // Porpuse: Send out data when requested
    always @(posedge i_clk or posedge i_rst) begin
        if ( i_rst ) begin
            r_rd_start_hold <= 1'b0;
            r_rd_index      <= 'h0;
        end
        else begin
            if( i_rd_start | r_rd_start_hold ) begin
                if( r_rd_index ==  (ELEMENTS-1) ) begin
                    r_rd_start_hold <= 1'b0;
                    r_rd_index      <= 'h0;
                end
                else begin
                    r_rd_start_hold <= 1'b1;
                    r_rd_index      <= r_rd_index + 1'b1;
                end
            end
        end
    end
    
    assign w_mem_we = i_wr_start | r_start_hold;
    
    fft_memory mem (
    .q( o_data ),
    .q2( o_data2 ),
    .d( i_data ),
    .d2( i_data2 ),
    .write_address( r_wr_index ),
    .read_address( r_rd_index ),
    .we( w_mem_we ),
    .clk( i_clk ) );
    

endmodule


module fft_memory (
    q,
    q2,
    d,
    d2,
    write_address,
    read_address,
    we,
    clk
);
    parameter WIDTH = 12;
    parameter LENGTH = 1024;
    parameter LENGTHWIDTH = 10;
    
    output reg [WIDTH - 1:0] q;
    output reg [WIDTH - 1:0] q2;
    input [WIDTH - 1:0] d;
    input [WIDTH - 1:0] d2;
    input [LENGTHWIDTH - 1:0] write_address, read_address;
    input we, clk;
    
    
    reg [WIDTH - 1:0] mem [LENGTH - 1:0];
    reg [WIDTH - 1:0] mem2 [LENGTH - 1:0]; // Second memory is for imaginary part
    always @(posedge clk) begin
        if (we) begin
            mem[write_address] <= d;
            mem2[write_address] <= d2;
        end
        q <= mem[read_address]; // q doesn't get d in this clock cycle
        q2 <= mem2[read_address]; // q doesn't get d in this clock cycle
    end
    
endmodule

// This module will take in the output of fft
// and apply the filter saved in fft_filter.in
// output data should feed IFFT
module fft_filter (
    rst,
    clk,
    
    i_start,
    o_finish,
    
    i_data,
    i_data2,
    o_data,
    o_data2,
    
    i_filter_selector
);
    input rst, clk;
    input           i_start;
    input   [11:0]  i_data;
    input   [11:0]  i_data2;
    output  [11:0]  o_data;
    output  [11:0]  o_data2;
    output          o_finish;
    input [1:0]     i_filter_selector;
    
    reg     [11:0]  r_data = 'h0;
    reg     [11:0]  r_data2 = 'h0;
    
    parameter LENGTH = 1024;
    reg r_filter_buff[0:LENGTH -1];
    reg r_filter_buff2[0:LENGTH -1];
    reg r_filter_buff3[0:LENGTH -1];
    reg r_filter_buff4[0:LENGTH -1];
    reg r_start_hold = 1'b0;
    
    reg [9:0] r_counter = 'h0;
    
    always @(posedge clk or posedge rst) begin
        if(rst) begin
            r_start_hold    <= 1'b0;
            r_counter       <= 'h0;
            r_data          <= 'h0;
            r_data2         <= 'h0;
        end
        else begin
            if( i_start ) begin
                r_start_hold    <= 1'b1;
            end
            
            if(r_start_hold) begin
                if( r_counter == 'h3ff ) begin
                    r_start_hold    <= 1'b0;
                    r_counter       <= 'h0;
                end
                else begin
                    //r_start_hold    <= 1'b1;
                    r_counter       <= r_counter + 1'b1;
                end
                
                case (i_filter_selector)
                    2'b00: begin
                        r_data  <= r_filter_buff[r_counter] ? i_data : 12'h0;
                        r_data2 <= r_filter_buff[r_counter] ? i_data2 : 12'h0;
                    end
                    
                    2'b01: begin
                        r_data  <= r_filter_buff2[r_counter] ? i_data : 12'h0;
                        r_data2 <= r_filter_buff2[r_counter] ? i_data2 : 12'h0;
                    end
                    2'b10: begin
                        r_data  <= r_filter_buff3[r_counter] ? i_data : 12'h0;
                        r_data2 <= r_filter_buff3[r_counter] ? i_data2 : 12'h0;
                    end
                    2'b11: begin
                        r_data  <= r_filter_buff4[r_counter] ? i_data : 12'h0;
                        r_data2 <= r_filter_buff4[r_counter] ? i_data2 : 12'h0;
                    end
                endcase
                
            end
        end
    end
    
    initial begin
        $readmemb("C:/Users/colon/Modular/8051/syn/synplify/fft_filter.in", r_filter_buff);
        $readmemb("C:/Users/colon/Modular/8051/syn/synplify/fft_filter2.in", r_filter_buff2);
        $readmemb("C:/Users/colon/Modular/8051/syn/synplify/fft_filter3.in", r_filter_buff3);
        $readmemb("C:/Users/colon/Modular/8051/syn/synplify/fft_filter4.in", r_filter_buff4);
    end
    
    
    assign o_data = r_data;
    assign o_data2 = r_data2;
    assign o_finish = (r_counter == 'h0 & r_start_hold) ? 1'b1 : 1'b0;

endmodule
