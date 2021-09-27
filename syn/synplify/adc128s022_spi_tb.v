// synopsys translate_off
`include "../../rtl/verilog/oc8051_timescale.v"
// synopsys translate_on

module adc128s022_spi_tb;

parameter DELAY = 10; // 10ns 50MHz

reg rst, clk;
reg [15:0] reg_ADD;
reg reg_din;
reg reg_flagStart;

wire [11:0] w_DB;
wire w_cs;
wire w_sclk;
wire w_dout;
wire w_flagReady;

reg [0:15] reg_din_word;


adc128s022_spi adc128s022_1 (
 .rst( rst ),
 .clk( clk ),
 // ADC pins
 .sclk( w_sclk ),
 .cs( w_cs ),
 .din( reg_din ),
 .dout( w_dout ),
 
 .ADD( reg_ADD ),
 .DB( w_DB ),
 
 .flagStart( reg_flagStart ),
 .flagReady( w_flagReady )
);

reg [3:0] reg_index;

initial begin
  rst = 1'b1;
  reg_ADD = 15'h010;
  reg_din = 1'b1;
  reg_flagStart = 1'b0;
  reg_index = 4'h0;
  reg_din_word = 16'h0000;
#220
  rst = 1'b0;
  reg_flagStart = 1'b1;
  @(posedge clk);
  //reg_flagStart = 1'b0;
  
  repeat(100) begin
	repeat(16) begin
		reg_din = reg_din_word[reg_index];
		@(posedge clk);
		reg_index = reg_index + 4'h1;
	end
	reg_din_word = reg_din_word + 16'h0001;
  end
  


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
