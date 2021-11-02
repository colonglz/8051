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
	o_int_rst,
	
// ADC adc128s022
	o_adc_sclk,
	o_adc_cs,
	i_adc_din,
	o_adc_dout,
    
    // DAC
    io_sda,
    o_scl,
    
    i_view
	);
	
    input [1:0] i_view;
    
    inout io_sda;
output o_scl;

input i_adc_din;
output o_adc_sclk, o_adc_cs, o_adc_dout;
wire adc_ready;
wire [11:0] adc_DB;

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

wire clk_10Mhz;

wire nrst;

wire o_ack;

assign p0_out = {7'h00,o_ack};

oc8051_top oc8051_top_1(.wb_rst_i(int_rst), .wb_clk_i(clk_10Mhz),
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
		//.wbi_dat_i(32'h00000000), 
//		wbi_stb_o, 
		//.wbi_ack_i(1'b0), 
//		wbi_cyc_o, 
		//.wbi_err_i(1'b0),

// external ram interface
//
//    .dat_i(dat_i), .dat_o(dat_o), .adr_o(adr_o), .we_o(we_o), .ack_i(ack_i), .stb_o(stb_o),
//    .cyc_o(cyc_o),
//
// //interface to data ram
		//.wbd_dat_i(8'h00), 
//		wbd_dat_o,
//		wbd_adr_o, 
//		wbd_we_o, 
		//.wbd_ack_i(1'b0),
//		wbd_stb_o, 
//		wbd_cyc_o, 
		//.wbd_err_i(1'b0),
//  ports interface
//
     .p0_i(8'h00), .p1_i({7'b0000000,adc_ready}), .p2_i(adc_DB[11:4]), .p3_i(8'h00),
     //.p0_o(p0_out), .p1_o(p1_out), .p2_o(p2_out), .p3_o(p3_out)//,
     .p0_o(), .p1_o(p1_out), .p2_o(p2_out), .p3_o(p3_out)//,
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
	.clk_out( clk_10Mhz )
 );



 
initial_rst initial_rst1 (
	.clk( clk_10Mhz ),
	.rst_out( rst_out )
 );

oc8051_adc oc8051_adc_u (
	.rst( int_rst ),
	.clk( clk ),
	
	.pin_sclk( o_adc_sclk ),
	.pin_cs( o_adc_cs ),
	.pin_din( i_adc_din ),
	.pin_dout( o_adc_dout ),
	
	//i_mode, // single or continue
	//i_num_samples, // Number of samples to take
	.i_start( p1_out[3] ),
	.o_ready( adc_ready ),
	
	.i_ADD( p1_out[2:0] ),
	.o_DB( adc_DB )
);

wire [11:0] o_dac_output;
wire [11:0] w_fifo_data;
wire w_fifo_wr_rqst;
wire w_fifo_wr_full;

oc8051_fft_top fft_u (
	.rst( int_rst ),
	.clk( clk ),
	.i_adc_input( adc_DB ),
	.i_adc_input_ready( adc_ready ),
	.o_dac_output( o_dac_output ),
    
    .o_fifo_data( w_fifo_data ),
    .o_fifo_wr_rqst( w_fifo_wr_rqst ),
    .i_fifo_wr_full( w_fifo_wr_full )
);

fft_fifo	fft_fifo_inst (
	.data ( w_fifo_data ),
	.rdclk ( w_fifo_rd_clk ),
	.rdreq ( w_fifo_rd_rqst ),
	.wrclk ( clk ),
	.wrreq ( w_fifo_wr_rqst ),
	.q ( w_fifo_rd_data ),
	.rdempty ( w_fifo_rd_empty ),
	.wrfull ( w_fifo_wr_full )
);

wire w_fifo_rd_clk;
wire [11:0] w_fifo_rd_data;
wire w_fifo_rd_empty;
wire w_fifo_rd_rqst;

oc8051_dac dac(
	.rst(int_rst),
	.clk(clk),
	.io_sda(io_sda),
	.o_scl(o_scl),
    
    .o_ack(o_ack),
    .o_fifo_clk( w_fifo_rd_clk ),
    .i_fifo_data( w_fifo_rd_data ),
    .i_fifo_rd_empty( w_fifo_rd_empty ),
	.o_fifo_rd_rqst( w_fifo_rd_rqst )
);

    input_view input_view_u(
    .i_clk(clk),
    
    .i_scl(i_view[0]),
    .i_sda(i_view[1])
    )/* synthesis preserve */;

 assign int_rst = !rst_out || nrst; 
 
 assign o_clk_8MHz = clk_10Mhz;
 assign o_int_rst = int_rst;
 
 assign nrst = ~rst;

endmodule
