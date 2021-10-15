// synopsys translate_off
`include "../../rtl/verilog/oc8051_timescale.v"
// synopsys translate_on

module oc8051_dac_tb;

parameter DELAY = 10; // 10ns 50MHz

wire w_io_sda;
wire w_o_scl;
wire w_o_ack;

reg clk, rst;

pullup(w_io_sda);
pullup(w_o_scl);

initial begin
    rst = 1'b1;
    # 40;
    rst = 1'b0;
end

initial
begin
  clk = 0;
  forever #DELAY clk <= ~clk;
end

oc8051_dac dut (
	.rst(rst),
	.clk(clk),
	.io_sda(w_io_sda),
	.o_scl(w_o_scl),
    
    .o_ack(w_o_ack)
	
);

endmodule
