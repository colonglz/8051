// synopsys translate_off
`include "../../rtl/verilog/oc8051_timescale.v"
// synopsys translate_on

module oc8051_dac (
	rst,
	clk,
	io_sda,
	o_scl,
    
    o_ack
	
);

    input rst;
    input clk;
    inout io_sda;
    output o_scl;
    
    output o_ack;


    wire clk_390K62Hz;
    wire clk_781K25Hz;
    wire w_clk_dac_n;
    
    wire clk_3M125Hz;
    wire clk_6M25Hz;
    wire w_clk_dac;
    wire w_clk_dac_x2;
    wire w_hs_mode;
    
    localparam MAXCOUNTER = 15; // No of samples in dac_sine_wave.in
    reg [11:0] r_buff [0:MAXCOUNTER - 1];

    reg [7:0]  r_dac_data;
    reg [5:0] r_counter;
    reg r_new_data;
    
    reg r_dac_start;
    wire w_dac_new_data;
    wire w_dac_busy;

    reg [2:0] st_M = 'h0 /* synthesis noprune */;
    localparam IDLE = 0;
    localparam STARTDAC = 1;
    localparam SEND_HSMODE = 2;
    localparam SEND_ADDRESS = 3;
    localparam WAITNEWDATAREQUEST = 4;
    localparam WAITNEWDATAREQUEST2 = 5;

    reg [2:0] r_prev_state = 'h0;
    always @( posedge w_clk_dac_n ) begin
        r_prev_state <= st_M;
    end

    // Porpuse: Drive the I2C low level block
    always @( posedge w_clk_dac_n or posedge rst ) begin
        if(rst) begin
            r_dac_start <= 1'b0;
            r_new_data <= 1'b0;
            r_dac_data <= 8'h00;
            
            r_counter <= 6'h0;
            
            st_M <= IDLE;
        end
        else begin
            case(st_M)
                IDLE: begin
                    if(1'b1/* Condition to start */) begin
                        st_M <= SEND_HSMODE;
                    end
                end
                
                SEND_HSMODE: begin
                    r_dac_data <= 8'h08;
                    r_new_data <= 1'b1;
                    
                    st_M <= STARTDAC;
                end
                
                SEND_ADDRESS: begin
                    r_dac_start <= 1'b0;
                    if ( w_dac_new_data ) begin
                        r_dac_data <= {7'b1100010, 1'b0};
                        r_new_data <= 1'b1;
                        
                        st_M <= STARTDAC;
                    end
                end
                
                STARTDAC: begin
                        r_dac_start <= 1'b1;
                        
                        if ( r_prev_state ==  SEND_HSMODE)
                            st_M <= SEND_ADDRESS;
                        else
                            st_M <= WAITNEWDATAREQUEST2;
                end
                
                WAITNEWDATAREQUEST: begin
                    r_dac_start <= 1'b0;
                    if ( w_dac_new_data ) begin
                        r_dac_data <= r_buff[r_counter][7:0];
                        
                        
                        if( r_counter == (MAXCOUNTER - 1) ) begin
                            r_counter <= 'h0;
                        end
                        else begin
                            r_counter <= r_counter + 1'b1;
                        end
                        
                        st_M <= WAITNEWDATAREQUEST2;
                    end
                    else if ( !w_dac_busy ) begin
                        r_counter <= 6'h0;
                        
                        st_M <= IDLE;
                    end
                end
                
                WAITNEWDATAREQUEST2: begin
                    r_dac_start <= 1'b0;
                    if ( w_dac_new_data ) begin
                        r_dac_data <= {4'h0, r_buff[r_counter][11:8]};
                        
                        st_M <= WAITNEWDATAREQUEST;
                    end
                    else if ( !w_dac_busy ) begin
                        r_counter <= 6'h0;
                        
                        st_M <= IDLE;
                    end
                end
                
                default: begin
                
                    r_dac_start <= 1'b0;
                    r_dac_data <= 8'h00;
                    r_new_data <= 1'b0;
                    
                    st_M <= IDLE;
                end
            
            endcase
        end
    end


    initial begin
        $readmemh("C:/Users/colon/Modular/8051/syn/synplify/dac_sine_wave.in", r_buff);
        //$readmemh("C:/Users/colon/Modular/8051/syn/synplify/dac_sine_wave.in", r_buff, 0, 51);
    end

    clk_div clk_div_dac (
        .clk_in( clk ),
        .clk_out( clk_390K62Hz )
    );
    defparam clk_div_dac.DIVIDER = 64; // 400kHz
    defparam clk_div_dac.DIVIDER_WIDTH = 6;
    
    clk_div clk_div_dac_x2 (
        .clk_in( clk ),
        .clk_out( clk_781K25Hz )
    );
    defparam clk_div_dac_x2.DIVIDER = 32; // 800kHz
    defparam clk_div_dac_x2.DIVIDER_WIDTH = 6;
    
    
    clk_div clk_div_dac_hs (
        .clk_in( clk ),
        .clk_out( clk_3M125Hz )
    );
    defparam clk_div_dac_hs.DIVIDER = 8; // 3.125MHz
    defparam clk_div_dac_hs.DIVIDER_WIDTH = 4;
    
    clk_div clk_div_dac_hs_x2 (
        .clk_in( clk ),
        .clk_out( clk_6M25Hz )
    );
    defparam clk_div_dac_hs_x2.DIVIDER = 4; // 6.25MkHz
    defparam clk_div_dac_hs_x2.DIVIDER_WIDTH = 3;
    
    
    
    

    i2c_core dac(
        .rst(rst),
        .i_clk(w_clk_dac),
        .i_clk_x2(w_clk_dac_x2),

        .o_scl(o_scl),
        .io_sda(io_sda),

        .i_start(r_dac_start),
        .i_data(r_dac_data),
        .i_new_data(r_new_data),
        .o_new_data(w_dac_new_data),
        .o_busy(w_dac_busy),
        
        .o_ack(o_ack),
        .o_hs_mode(w_hs_mode)
    );

    assign w_clk_dac_n = ~w_clk_dac;

    assign w_clk_dac = w_hs_mode ? clk_3M125Hz : clk_390K62Hz;
    assign w_clk_dac_x2 = w_hs_mode ? clk_6M25Hz : clk_781K25Hz;

endmodule
