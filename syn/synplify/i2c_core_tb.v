// synopsys translate_off
`include "../../rtl/verilog/oc8051_timescale.v"
// synopsys translate_on

module i2c_core_tb;

parameter DELAY = 10; // 10ns 50MHz

reg rst, clk, r_start;
reg [6:0] r_address;
reg [7:0] r_data;
reg [11:0] r_data_elements;
wire w_new_data;

wire w_io_scl, w_io_sda;

pullup(w_io_scl);
pullup(w_io_sda);
initial begin

	rst = 1;
	r_start = 0;
	r_data = 8'h96;
	@(posedge clk);
    rst = 0;
    @(posedge clk);
    r_address = 7'b1100000; //DAC Address
    r_data = 8'h01;
    r_data_elements = 12'h5;
    @(posedge clk);
	r_start = 1'b1;
	@(posedge clk);
	r_start = 1'b0;
    repeat(r_data_elements - 1) begin
        wait( w_new_data == 1 );
        @(posedge clk);
        if(w_new_data) begin
            r_data = r_data +1;
        end
        wait( w_new_data == 0 );
    end
	repeat (20) begin
		@(posedge clk);
	end
	
	$stop;
end

initial
begin
  clk = 0;
  forever #DELAY clk <= ~clk;
end

i2c_core dut(
	.rst(rst),
	.i_clk(clk),

	.io_scl(w_io_scl),
	.io_sda(w_io_sda),

	.i_start(r_start),
	.i_address(r_address),
    .i_read_nwrite(1'b0),
	.i_data(r_data),
	.i_data_elements(r_data_elements),
    .o_new_data(w_new_data)
);

endmodule
