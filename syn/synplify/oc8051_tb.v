// synopsys translate_off
`include "../../rtl/verilog/oc8051_timescale.v"
// synopsys translate_on

`include "../../rtl/verilog/oc8051_defines.v"

module oc8051_tb;

parameter FREQ  = 12000; // frequency in kHz

parameter DELAY = 500000/FREQ;

reg  rst, clk;
reg  [7:0] p0_in, p1_in, p2_in;
wire [15:0] ext_addr, iadr_o;
wire write, write_xram, write_uart, txd, rxd, int_uart, int0, int1, t0, t1, bit_out, stb_o, ack_i;
wire ack_xram, ack_uart, cyc_o, iack_i, istb_o, icyc_o, t2, t2ex;
wire [7:0] data_in, data_out, p0_out, p1_out, p2_out, p3_out, data_out_uart, data_out_xram, p3_in;
wire wbi_err_i, wbd_err_i;

reg ea [0:1];

assign wbd_err_i = 1'b0;
assign wbi_err_i = 1'b0;

//
// oc8051 controller
//
oc8051_top oc8051_top_1(.wb_rst_i(rst), .wb_clk_i(clk),
         .int0_i(int0), .int1_i(int1),

         .wbd_dat_i(data_in), .wbd_we_o(write), .wbd_dat_o(data_out),
         .wbd_adr_o(ext_addr), .wbd_err_i(wbd_err_i),
         .wbd_ack_i(ack_i), .wbd_stb_o(stb_o), .wbd_cyc_o(cyc_o),

	 .wbi_adr_o(iadr_o), .wbi_stb_o(istb_o), .wbi_ack_i(iack_i),
         .wbi_cyc_o(icyc_o), .wbi_dat_i(idat_i), .wbi_err_i(wbi_err_i),

  `ifdef OC8051_PORTS

   `ifdef OC8051_PORT0
	 .p0_i(p0_in),
	 .p0_o(p0_out),
   `endif

   `ifdef OC8051_PORT1
	 .p1_i(p1_in),
	 .p1_o(p1_out),
   `endif

   `ifdef OC8051_PORT2
	 .p2_i(p2_in),
	 .p2_o(p2_out),
   `endif

   `ifdef OC8051_PORT3
	 .p3_i(p3_in),
	 .p3_o(p3_out),
   `endif
  `endif


   `ifdef OC8051_UART
	 .rxd_i(rxd), .txd_o(txd),
   `endif

   `ifdef OC8051_TC01
	 .t0_i(t0), .t1_i(t1),
   `endif

   `ifdef OC8051_TC2
	 .t2_i(t2), .t2ex_i(t2ex),
   `endif

	 //.ea_in(ea[0]));
	 .ea_in(1'b1));
	 

initial begin
  rst= 1'b1;
  p0_in = 8'h00;
  p1_in = 8'h00;
  p2_in = 8'h00;
#220
  rst = 1'b0;

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
