//	This module was designed to receive 50MHz input clock
//	and produce 8MHz output clock

module clk_div
#(
	parameter DIVIDER = 3, // 50MHz/5 = 10MHz
	parameter DIVIDER_WIDTH = 2
)
(
	clk_in,
	clk_out
);

input clk_in;
output clk_out;

//parameter MAXCNT = 2'h2;
reg [DIVIDER_WIDTH:0] cntr = {DIVIDER_WIDTH{1'b0}};
reg reg_clk_out = 1'b0;

always @(posedge clk_in) begin
	cntr <= cntr+'h1;
	if(cntr == (DIVIDER - 1) ) begin
		reg_clk_out <= ~reg_clk_out;
		cntr <= 'h0;
	end

end

assign clk_out = reg_clk_out;

endmodule
