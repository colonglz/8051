// synopsys translate_off
`include "../../rtl/verilog/oc8051_timescale.v"
// synopsys translate_on

module input_view (
    i_clk,
    
    i_scl,
    i_sda
);
    input i_clk, i_scl, i_sda;
    
    wire w_5Mhz_clk;
    reg r_scl /*synthesis noprune */;
    reg r_sda /*synthesis noprune */;

    always @( posedge w_5Mhz_clk ) begin
        r_scl <= i_scl;
        r_sda <= i_sda;    
    end

    clk_div clk_div_u (
        .clk_in( i_clk ),
        .clk_out( w_5Mhz_clk )
    );
    defparam clk_div_u.DIVIDER = 5; //5MHz
    defparam clk_div_u.DIVIDER_WIDTH = 3;


endmodule
