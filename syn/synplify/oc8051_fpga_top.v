// synopsys translate_off
`include "../../rtl/verilog/oc8051_timescale.v"
// synopsys translate_on

// reset must be low at oc8051 in order to work

module oc8051_fpga_top (clk, rst,
//
// interrupt interface
//
//   int1, int2,
//
// ports
//
   p0_out, p1_out, p2_out, p3_out ,
//
// external instruction rom interface
//
//   ea, iadr_o, istb_o, iack_i, icyc_o, idat_i,
//
// external data ram interface
//
//   stb_o, cyc_o, dat_i, dat_o, adr_o, ack_i, we_o,
//
// serial interface
//
//   rxd, txd, 
//
// timer/counter interface
//
//   t0, t1
	o_clk_8MHz,
	o_int_rst
	);

input clk, rst/*, int1, int2, ea, iack_i, ack_i, rxd, t0, t1*/;
//input [7:0] dat_i;
//input [31:0] idat_i;
//output txd, istb_o, icyc_o, stb_o, cyc_o, we_o;
output [7:0] p0_out, p1_out, p2_out, p3_out/*, dat_o*/;
//output [15:0] adr_o, iadr_o;

output o_clk_8MHz;
output o_int_rst;

//wire cstb_o, ccyc_o, cack_i;
//wire [15:0] cadr_o;
//wire [31:0] cdat_i;

wire int_rst; // internal reset
wire rst_out;

wire clk_8Mhz;

wire nrst;

oc8051_top oc8051_top_1(.wb_rst_i(int_rst), .wb_clk_i(clk_8Mhz),
//
// interrupt interface
//
//    .int0(int1), .int1(int2),
//
// external rom interface
// ea_in = 1'b1 (internal ROM used)
// ea_in = 1'b0 (external ROM used)
    .ea_in(1'b1), //.iadr_o(cadr_o),  .idat_i(cdat_i), .istb_o(cstb_o), .iack_i(cack_i), .icyc_o(ccyc_o),
//
//interface to instruction rom
//		wbi_adr_o, 
		.wbi_dat_i(32'h00000000), 
//		wbi_stb_o, 
		.wbi_ack_i(1'b0), 
//		wbi_cyc_o, 
		.wbi_err_i(1'b0),

// external ram interface
//
//    .dat_i(dat_i), .dat_o(dat_o), .adr_o(adr_o), .we_o(we_o), .ack_i(ack_i), .stb_o(stb_o),
//    .cyc_o(cyc_o),
//
// //interface to data ram
		.wbd_dat_i(8'h00), 
//		wbd_dat_o,
//		wbd_adr_o, 
//		wbd_we_o, 
		.wbd_ack_i(1'b0),
//		wbd_stb_o, 
//		wbd_cyc_o, 
		.wbd_err_i(1'b0),
//  ports interface
//
     .p0_i(8'hb00), .p1_i(8'hb00), .p2_i(8'hb00), .p3_i(8'hb00),
     .p0_o(p0_out), .p1_o(p1_out), .p2_o(p2_out), .p3_o(p3_out)//,
//
// serial interface
//
//     .rxd(rxd), .txd(txd),
//
// timer/counter interface
//
//     .t0(t0), .t1(t1)
);


clk_div clk_div1 ( 
	.clk_in( clk ),
	.clk_out( clk_8Mhz )
 );



 
 initial_rst initial_rst1 (
	.clk( clk_8Mhz ),
	.rst_out( rst_out )
 );

 assign int_rst = !rst_out || nrst; 
 
 assign o_clk_8MHz = clk_8Mhz;
 assign o_int_rst = int_rst;
 
 assign nrst = ~rst;

endmodule
