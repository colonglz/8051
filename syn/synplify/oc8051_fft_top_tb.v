// synopsys translate_off
`include "../../rtl/verilog/oc8051_timescale.v"
// synopsys translate_on

module oc8051_fft_top_tb;

    parameter DELAY = 10; // 10ns 50MHz
    localparam DATA_WIDTH = 12;
    localparam MAXCNTR = 15; // No of samples in dac_sine_wave.in
    localparam MAXCNTR_WIDTH = 4;

    reg rst, clk;
    reg [11:0] r_buff [0:MAXCNTR - 1];
    reg [MAXCNTR_WIDTH -1:0] r_cntr = 'h0;
    
    reg [DATA_WIDTH -1:0] r_adc_input;
    reg r_adc_input_rdy = 1'b0;
    
    initial begin
        rst = 1'b0;
        #220
        rst = 1'b1;
        #220
        rst = 1'b0;
        
        repeat( 1024 ) begin
            r_adc_input_rdy = 1'b0;
            r_adc_input = r_buff[r_cntr];
            repeat( 2 ) @(posedge clk);
            r_adc_input_rdy = 1'b1;
            repeat( 1 ) @(posedge clk);
            if( r_cntr == (MAXCNTR-1) )
                r_cntr = 'h0;
            else
                r_cntr = r_cntr + 1'b1;
        end
        
        repeat( 7000 ) @(posedge clk);
        
        repeat( 1024 ) begin
            r_adc_input_rdy = 1'b0;
            r_adc_input = r_buff[r_cntr];
            repeat( 2 ) @(posedge clk);
            r_adc_input_rdy = 1'b1;
            repeat( 1 ) @(posedge clk);
            if( r_cntr == (MAXCNTR-1) )
                r_cntr = 'h0;
            else
                r_cntr = r_cntr + 1'b1;
        end

        #80000000
        $display("time ",$time, "\n failure: end of time\n \n");
        $display("");
        $stop;
    end
    
    oc8051_fft_top dut(
        .rst( rst ),
        .clk( clk ),
        .i_adc_input( r_adc_input ),
        .i_adc_input_ready( r_adc_input_rdy )//,
        //.o_dac_output(  ) // Pending to implement and test
    );

    initial begin
      clk = 0;
      forever #DELAY clk <= ~clk;
    end
    
    initial begin
        $readmemh("C:/Users/colon/Modular/8051/syn/synplify/dac_sine_wave.in", r_buff);
    end

endmodule
