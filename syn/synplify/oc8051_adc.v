// synopsys translate_off
`include "../../rtl/verilog/oc8051_timescale.v"
// synopsys translate_on

module oc8051_adc (
	rst,
	clk,
	
	pin_sclk,
	pin_cs,
	pin_din,
	pin_dout,
	
	//i_mode, // single or continue
	//i_num_samples, // Number of samples to take
	i_start,
	o_ready,
	
	i_ADD,
	o_DB
);

input clk, rst;
input pin_din;
input i_start;
input [2:0] i_ADD;
output pin_sclk, pin_cs, pin_dout;
output o_ready;
output [11:0] o_DB;

wire clk_3M125Hz;

clk_div clk_div_adc (
	.clk_in( clk ),
	.clk_out( clk_3M125Hz )
);
defparam clk_div_adc.DIVIDER = 8;
defparam clk_div_adc.DIVIDER_WIDTH = 4;

// Purpose: Add 2 clock delay to match DAC
reg r_start_flag = 1'b0;
reg r_start_flag_rasied = 1'b0;
always @(posedge clk_3M125Hz or posedge rst) begin
    if(rst) begin
        r_start_flag <= 1'b0;
        r_start_flag_rasied <= 1'b0;
    end
    else begin
        // this will give us 2 clock delay
        if( r_start_flag == 1'b0 &
            r_start_flag_rasied == 1'b1 &
            o_ready == 1'b1 ) begin
            //r_start_flag_rasied <= 1'b0;
            r_start_flag <= 1'b1;
        end
        else if( r_start_flag_rasied == 1'b1 &
                 i_start == 1'b1 &
                 r_start_flag == 1'b1 ) begin
            r_start_flag <= 1'b0;
        end
        else if( i_start == 1'b1 &
                 r_start_flag == 1'b0 &
                 r_start_flag_rasied == 1'b0 ) begin
            r_start_flag <= 1'b1;
            r_start_flag_rasied <= 1'b1;
        end
    end
end

adc128s022_spi adc128s022_spi_u (
 .rst(rst),
 .clk(clk_3M125Hz), //195.31ksps
 .sclk(pin_sclk),
 .cs(pin_cs),
 .din(pin_din),
 .dout(pin_dout),
 
 .ADD( {2'b00,i_ADD, 11'h000} ),
 .DB(o_DB),
 
 .flagStart(r_start_flag),
 .flagReady(o_ready)
);

endmodule
