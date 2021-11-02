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

wire w_fifo_clk;
reg [11:0] r_fifo_data;
reg r_fifo_rd_empty;
wire w_fifo_rd_rqst;

reg [5:0] cntr = 'h0;

initial begin
    rst = 1'b1;
    r_fifo_rd_empty = 1'b1;
    r_fifo_data = 12'h000;
    # 40;
    rst = 1'b0;
    repeat(20) @(posedge w_fifo_clk);
    r_fifo_rd_empty = 1'b0;
    repeat(50) begin
        @(posedge w_fifo_rd_rqst);
        @(posedge w_fifo_clk);
        r_fifo_data = cntr;
        cntr = cntr + 1;
    end
    
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
    
    .o_ack(w_o_ack),
    
    .o_fifo_clk( w_fifo_clk ),
    .i_fifo_data( r_fifo_data ),
    .i_fifo_rd_empty( r_fifo_rd_empty ),
    .o_fifo_rd_rqst( w_fifo_rd_rqst )
	
);

endmodule
