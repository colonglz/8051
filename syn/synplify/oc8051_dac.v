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
    wire clk_396K82Hz_n;
    assign clk_396K82Hz_n = ~clk_390K62Hz;
    
    localparam MAXCOUNTER = 15; // No of samples in dac_sine_wave.in
    reg [11:0] r_buff [0:MAXCOUNTER - 1];

    reg [7:0]  r_dac_data;
    reg [5:0] r_counter;
    reg r_new_data;
    
    reg r_dac_start;
    wire w_dac_new_data;
    wire w_dac_busy;

    reg [1:0] st_M /* synthesis noprune */;
    localparam IDLE = 0;
    localparam STARTDAC = 1;
    localparam WAITNEWDATAREQUEST = 2;
    localparam WAITNEWDATAREQUEST2 = 3;


    // Porpuse: Drive the I2C low level block
    always @( posedge clk_396K82Hz_n or posedge rst ) begin
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
                        r_dac_data <= {7'b1100010, 1'b0};
                        r_new_data <= 1'b1;
                        
                        st_M <= STARTDAC;
                    end
                end
                
                STARTDAC: begin
                        r_dac_start <= 1'b1;
                        
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

    i2c_core dac(
        .rst(rst),
        .i_clk(clk_390K62Hz),
        .i_clk_x2(clk_781K25Hz),

        .o_scl(o_scl),
        .io_sda(io_sda),

        .i_start(r_dac_start),
        .i_data(r_dac_data),
        .i_new_data(r_new_data),
        .o_new_data(w_dac_new_data),
        .o_busy(w_dac_busy),
        
        .o_ack(o_ack)
    );



endmodule
