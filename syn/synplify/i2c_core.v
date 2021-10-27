// synopsys translate_off
`include "../../rtl/verilog/oc8051_timescale.v"
// synopsys translate_on

module i2c_core (
	rst,
	i_clk,
    i_clk_x2,
    
	o_scl,
	io_sda,

	i_start,
	i_data,
	i_new_data,
    o_new_data,
    o_busy,
    
    o_ack,
    o_hs_mode
);
    parameter DATAWIDTH = 8;
    parameter MAXELEMENTS = 4094;
    parameter MAXELEMENTSWIDTH = 12;
    
    

    input rst, i_clk, i_clk_x2;
    inout io_sda;
    output o_scl; 
    input i_start;
    input [DATAWIDTH -1:0] i_data;
    input i_new_data; // Indication that will be another transmission
                      // on the next cycle.
    output o_new_data;
    output o_busy;
    
    output o_ack;
    output o_hs_mode;
    reg r_o_hs_mode = 1'b0;
    wire Rx_sda;
    
    wire [3:0] w_core_state  /* synthesis noprune */;
    reg [3:0] r_state = 4'b0 /* synthesis noprune */;
    localparam IDLE = 0;
    localparam START_CONDITION = 1;
    localparam SEND_DATA = 2;
    localparam REQUEST_NEW_DATA = 3;
    localparam WAIT_DATA_SEND = 4;
    localparam STOP_CONDITION = 5;
    
    reg  r_scl_en = 1'b0;
    reg  r_sda_en = 1'b0;
    wire w_sda;
    reg  r_sda /* synthesis noprune */;
    reg  r_busy = 1'b0;
    
    
    reg r_start = 1'b0;
    reg r_ack;
    
    reg r_start_send_byte;
    wire w_sda_out;
    wire w_send_byte_busy;
    reg [DATAWIDTH - 1:0] r_send_byte_data;
    reg r_new_data = 1'b0;
    
    
    // Porpuse: State machine
    // State IDLE: Waiting for i_start to be asserted
    //             upon i_start assetion, sda and scl
    //             lines will be checked, if both are
    //             high (Bus ready), then START condi
    //             -tion will be generated. r_scl_en
    //             and r_sda_en asserted.
    // State SEND_DATA: Enable i2c_send_byte to
    //             send the address concatenated with
    //             Write/Read bit (Only Write for
    //             now) or data. At completion,
    //             r_sda_en will be deasserted to li-
    //             sten for ACK
    // State REQUEST_NEW_DATA: Validate ACK reponse, at com-
    //             pletion, r_sda_en will be asserted
    // State STOP_CONDITION: Generate Stop condition,
    //             deassert r_scl_en and r_sda_en and
    //             go to IDLE. 
    
    // Conditions that casues state change
    reg r_i2c_send_byte_sda_ctrl;
    wire w_start_condition;
    assign w_start_condition = (i_start | r_start);
    reg r_enable_hs_mode;
    reg r_first_byte;
	always @(posedge i_clk or posedge rst) begin
        if(rst) begin
            r_scl_en    <= 1'b0;
            r_sda_en    <= 1'b0;
            r_sda       <= 1'b1;
            
            r_state <= IDLE;
            r_start <= 1'b0;
            r_new_data <= 1'b0;
            r_busy <= 1'b0;
            
            r_start_send_byte <= 1'b0;
            r_send_byte_data  <= 8'h00;
            r_i2c_send_byte_sda_ctrl <= 1'b0;
            
            r_enable_hs_mode    <= 1'b0;
            r_first_byte        <= 1'b1;
            //r_o_hs_mode         <= 1'b0;
        end
        else begin
            case(r_state)
                IDLE: begin
                    if(i_start) begin
                        /* We could last more than 1 clock
                           to start the transmision, so we
                           need to save the start flag */
                        r_start <= 1'b1;
                        r_busy  <= 1'b1;
                        r_state <= START_CONDITION;
                    end
                    
                end
                
                START_CONDITION: begin
                    if(r_enable_hs_mode) begin
                        //r_sda_en            <= 1'b0;
                        r_enable_hs_mode    <= 1'b0;
                        /* Prepare data for i2c_send_byte so
                           it can start transmit the next clock */
                        r_start_send_byte <= 1'b1;
                        //r_start             <= 1'b1;
                    end
                    
                    if ( w_start_condition ) begin
                        r_scl_en <= 1'b1;
                        r_sda_en <= 1'b1;
                        
                        /* At this point scl is high
                           (becasue we came from a
                           rising edge), and here we
                           generate the Start condition */
                        r_sda <= 1'b0;
                        
                        /* Prepare data for i2c_send_byte so
                           it can start transmit the next clock */
                        r_send_byte_data <= i_data;
                        
                        r_start_send_byte <= 1'b1;
                        
                        r_start <= 1'b0;
                        r_state <= SEND_DATA;
                    end
                end
                
                SEND_DATA: begin
                    /* Pass sda control to i2c_send_byte
                       module */
                    r_i2c_send_byte_sda_ctrl <= 1'b1;
                    /* w_send_byte_busy will keep io_sda
                       as output until deasserts in a 
                       clock falling edge */
                    r_sda_en <= 1'b0;
                    
                    r_start_send_byte <= 1'b0;
                    
                    if( r_send_byte_data == 8'h08 && r_first_byte) begin
                        r_enable_hs_mode    <= 1'b1;
                        r_first_byte        <= 1'b0;
                    end
                    
                    r_state <= REQUEST_NEW_DATA;
                end
                
                REQUEST_NEW_DATA: begin
                    /* request next data if needed*/
                    if( i_new_data ) begin
                        if(r_new_data) begin
                            r_new_data          <= 1'b0;
                            r_send_byte_data    <= i_data;
                            r_state             <= WAIT_DATA_SEND;
                        end
                        else begin
                            r_new_data <= 1'b1;
                        end
                    end
                    else begin
                        r_state <= WAIT_DATA_SEND;
                    end
                end
                
                WAIT_DATA_SEND: begin
                    /* Wait until i2c_send_byte finishes */
                    if( !w_send_byte_busy ) begin
                        // At this point we are at the 9th
                        // clock on a raising edge
                        
                        /* Release sda */
                        r_i2c_send_byte_sda_ctrl <= 1'b0;
                        
                        /* Check if we need another transmission 
                           and set data for i2c_send_byte, it
                           will be read on the next falling edge*/
                        if( i_new_data ) begin
                           
                            // Disable sda control to allow ACK
                            r_sda_en <= 1'b0;
                            
                            if( r_enable_hs_mode ) begin
                                //r_scl_en    <= 1'b0;
                                //r_o_hs_mode <= 1'b1;
                                r_start             <= 1'b1;
                                r_sda               <= 1'b1;
                                r_state     <= START_CONDITION;
                                //r_state <= SEND_DATA;
                            end
                            else begin
                                /* Prepare data for i2c_send_byte so
                                   it can start transmit the next clock */
                                r_start_send_byte <= 1'b1;
                                
                                r_state <= SEND_DATA;
                            end
                        end
                        else begin
                            r_state     <= STOP_CONDITION;
                        end
                    end
                end
                
                //WAIT_ACK_FINISH: begin
                //    if()
                //end
                
                STOP_CONDITION: begin
                    r_scl_en    <= 1'b0;
                    if ( !r_scl_en ) begin
                        r_sda_en    <= 1'b0;
                        r_busy      <= 1'b0;
                        r_first_byte    <= 1'b1;
                        //r_o_hs_mode <= 1'b0;
                        r_state     <= IDLE;
                    end
                end
                
                default: begin
                    r_busy      <= 1'b0;
                    //r_o_hs_mode <= 1'b0;
                    r_state     <= IDLE;
                end
            endcase
        end
	end
    
    always @(posedge i_clk_x2 or posedge rst) begin
        if(rst) begin
            r_ack <= 1'b0;
            r_o_hs_mode <= 1'b0;
        end
        else begin
            if( (r_state == SEND_DATA || r_state == STOP_CONDITION) && 
                 !w_send_byte_busy && i_clk) begin
                /* Save ACK */
                r_ack <= Rx_sda;
            end
            
            if( r_state == START_CONDITION && r_enable_hs_mode &&
                 !w_send_byte_busy && i_clk) begin
                r_o_hs_mode <= 1'b1;
            end
        end
    end
    
    wire w_sda_buffer;
    i2c_send_byte i2c_send_byte_u(
	.rst(rst),
	
	.i_scl(i_clk),
	.o_sda(w_sda_buffer),
	
	.i_start_send(r_start_send_byte),
	.o_busy(w_send_byte_busy),
	.i_data(r_send_byte_data)
    ) /* synthesis preserve */;
    
    reg r_sda_out = 1'b1;
    reg r_o_busy = 1'b0;
    
    // Giving a half i_clk delay
    reg r_sda_2 = 1'b1;
    always@(posedge i_clk_x2) begin
        r_sda_out   <= w_sda_buffer;
        r_o_busy    <= w_send_byte_busy;
        r_sda_2     <= r_sda;
    end
    assign w_sda_out = r_sda_out;
    
    assign w_core_state = r_state;
    
    assign o_busy = r_busy;
    assign o_new_data = r_new_data;
    assign w_sda = ( r_i2c_send_byte_sda_ctrl | w_send_byte_busy ) ? w_sda_out :
                   //( (r_state == SEND_DATA) &  w_start_condition ) ? r_sda : r_sda;
                   ( (r_state == SEND_DATA) &  w_start_condition ) ? r_sda_2 : r_sda_2;
    // Tri state assignment
    assign o_scl = ( r_scl_en ) ? i_clk : 1'b1;
    //assign io_sda = ( r_sda_en | w_send_byte_busy ) ? w_sda : 1'bZ;
    assign io_sda = ( r_sda_en | r_o_busy ) ? w_sda : 1'bZ;
    assign Rx_sda = io_sda;
    assign o_ack = r_ack;
    
    assign o_hs_mode = r_o_hs_mode;

endmodule





module i2c_send_byte(
	rst,
	
	i_scl,
	o_sda,
	
	i_start_send,
	o_busy,
	i_data
);

    input rst, i_scl, i_start_send;
    input [7:0] i_data;

    output o_sda, o_busy;

    wire w_scl_n;


    reg [2:0] r_bit_cntr = 3'b0;
    reg r_sda;
    reg [7:0] r_data;
    reg r_busy;

    // Porpuse: place bit per bit the i_data
    // onto o_sda line
    always @(posedge w_scl_n) begin
        if( r_bit_cntr != 3'h0 ) begin
            r_sda  <= r_data[r_bit_cntr - 1'b1];
            r_bit_cntr <= r_bit_cntr - 3'h1;
            r_busy <= 1'b1;
        end
        else if( i_start_send ) begin
            r_data <= i_data;
            r_sda  <= i_data[7];
            r_bit_cntr <= 3'h7;
            r_busy <= 1'b1;
        end 
        else begin
            r_busy <= 1'b0;
            r_sda <= 1'b0;
            r_data <= 8'h00;
        end
    end


    assign w_scl_n = ~i_scl;
    assign o_sda = r_sda;
    assign o_busy = r_busy;

endmodule
