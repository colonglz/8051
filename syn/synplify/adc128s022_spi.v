// synopsys translate_off
`include "../../rtl/verilog/oc8051_timescale.v"
// synopsys translate_on

module adc128s022_spi (
 rst,
 clk,
 sclk,
 cs,
 din,
 dout,
 
 ADD,
 DB,
 
 flagStart,
 flagReady
);

input rst, clk, din;
input [15:0] ADD;
input flagStart;

output sclk, cs, dout;
output [11:0] DB;
output flagReady;

reg reg_cs;
reg reg_dout;
reg [15:0] reg_DB;
reg [3:0] reg_clk_cntr = 4'h0; 

reg [3:0] reg_index_down = 4'hf;
reg [3:0] reg_index_up = 4'h0;
reg reg_flagReady = 1'b0;

// cs logic
always @(posedge clk or posedge rst) begin
	if(rst) begin
	 reg_cs <= 1'b1;
	end else if( flagStart )begin
		reg_cs <= 1'b0;
	end else if (reg_index_down == 4'h0) begin
		reg_cs <= 1'b1;
	end
end


// Clock counter
always @(posedge clk or posedge rst) begin
	if(rst) begin
		reg_clk_cntr <= 4'h0;
	end
	else if(!cs) begin
		reg_clk_cntr <= reg_clk_cntr + 4'h1;
	end else begin
		reg_clk_cntr <= 4'h0;
	end
end



// dout logic
always @(negedge clk or posedge rst) begin
	if(rst) begin
		reg_dout <= 1'b0;
	end
	else if(!cs) begin
		reg_dout <= ADD[reg_index_up];
	end else begin
		reg_dout <= 1'b0;
	end
end

// din logic
always @(posedge clk or posedge rst) begin
	if(rst) begin
		reg_DB <= 12'h0;
		reg_flagReady <= 1'b0;
	end
	else if(!cs) begin
		reg_DB[reg_index_down] <= din;
		if (reg_index_down == 4'h0) begin
			reg_flagReady <= 1'b1;
		end
		else begin
			reg_flagReady <= 1'b0;
		end
	end else begin
			reg_flagReady <= 1'b0;
	end
end

always @(posedge clk or posedge rst) begin
	if(rst) begin
		reg_index_down <= 4'hf;
		reg_index_up <= 4'h0;
	end else if (!cs) begin
		reg_index_down <= reg_index_down - 4'h1;
		reg_index_up <= reg_index_up + 4'h1;
	end else begin
		reg_index_down <= 4'hf;
		reg_index_up <= 4'h0;
	end
end


// clock handle
assign sclk = (!cs) ? clk : 1'b1;

assign DB = reg_DB[11:0];
assign dout = reg_dout;
assign flagReady = reg_flagReady;
assign cs = reg_cs;

endmodule
