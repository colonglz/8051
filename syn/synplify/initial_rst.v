// synopsys translate_off
`include "../../rtl/verilog/oc8051_timescale.v"
// synopsys translate_on

module initial_rst (
	clk,
	rst_out
);

input clk;
output rst_out;

parameter [2:0] MAX_CNTR = 3'h5;
reg [2:0] cntr = 3'h0;
reg reg_rst_out = 0;

always @( posedge clk ) begin
	if( cntr < MAX_CNTR ) begin
		cntr <= cntr + 3'h1;
	end
	else begin
		reg_rst_out <= 1;
	end

end

assign rst_out = reg_rst_out;

endmodule
