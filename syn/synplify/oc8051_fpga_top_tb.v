// synopsys translate_off
`include "../../rtl/verilog/oc8051_timescale.v"
// synopsys translate_on

module oc8051_fpga_top_tb;

parameter DELAY = 10; // 10ns 50MHz

wire [7:0] p0_out;
reg rst, clk;

oc8051_fpga_top oc8051_fpga_top1 (
	.clk( clk ),
	.rst( rst ),
	.p0_out( p0_out )
);

initial begin
//  rst= 1'b0;
//#220
  rst = 1'b1;

#80000000
  $display("time ",$time, "\n faulire: end of time\n \n");
  $display("");
  $finish;
end


initial
begin
  clk = 0;
  forever #DELAY clk <= ~clk;
end

endmodule
