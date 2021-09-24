//	This module was designed to receive 50MHz input clock
//	and produce 8MHz output clock

module clk_div(clk_in, clk_out);

input clk_in;
output clk_out;

parameter MAXCNT = 2'h2;
reg [2:0] cntr = 3'h0;
reg reg_clk_out = 1'b0;

always @(posedge clk_in) begin
	cntr <= cntr+3'h1;
	if(cntr == MAXCNT) begin
		reg_clk_out <= ~reg_clk_out;
		cntr <= 3'h0;
	end

end

assign clk_out = reg_clk_out;

endmodule
