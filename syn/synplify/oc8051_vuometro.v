// synopsys translate_off
`include "../../rtl/verilog/oc8051_timescale.v"
// synopsys translate_on

module oc8050_vuometro (
    i_data,
    o_leds
);

    input [11:0] i_data;
    output [6:0] o_leds;
    
    reg [6:0] r_leds;
    
    always @(*) begin
        if(i_data > 3686)
            r_leds = 6'h3f;
        else if ( i_data > 3276 )
            r_leds = 6'h1f;
        else if ( i_data > 3072 )
            r_leds = 6'h0f;
        else if ( i_data > 2867 )
            r_leds = 6'h07;
        else if ( i_data > 2662 )
            r_leds = 6'h03;
        else if ( i_data > 2457 )
            r_leds = 6'h01;
        else
            r_leds = 6'h00;
        
    end
    
    assign o_leds = r_leds;

endmodule
