onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -label tb/rst /oc8051_fft_top_tb/rst
add wave -noupdate -label tb/clk /oc8051_fft_top_tb/clk
add wave -noupdate -label tb/r_cntr -radix unsigned /oc8051_fft_top_tb/r_cntr
add wave -noupdate -label tb/r_adc_input -radix unsigned /oc8051_fft_top_tb/r_adc_input
add wave -noupdate -label tb/r_adc_input_rdy /oc8051_fft_top_tb/r_adc_input_rdy
add wave -noupdate -divider Memory
add wave -noupdate -label mem/q -radix decimal /oc8051_fft_top_tb/dut/fft_memory/mem/q
add wave -noupdate -label mem/q2 -radix decimal /oc8051_fft_top_tb/dut/fft_memory/mem/q2
add wave -noupdate -label mem/d -radix decimal /oc8051_fft_top_tb/dut/fft_memory/mem/d
add wave -noupdate -label mem/d2 -radix decimal /oc8051_fft_top_tb/dut/fft_memory/mem/d2
add wave -noupdate -label mem/write_address -radix hexadecimal /oc8051_fft_top_tb/dut/fft_memory/mem/write_address
add wave -noupdate -label mem/read_address -radix hexadecimal /oc8051_fft_top_tb/dut/fft_memory/mem/read_address
add wave -noupdate -label mem/we /oc8051_fft_top_tb/dut/fft_memory/mem/we
add wave -noupdate -divider fft
add wave -noupdate -label dut/r_fft_state -radix unsigned /oc8051_fft_top_tb/dut/r_fft_state
add wave -noupdate -label dut/r_cnt -radix unsigned /oc8051_fft_top_tb/dut/r_cnt
add wave -noupdate -label dut/sink_sop /oc8051_fft_top_tb/dut/sink_sop
add wave -noupdate -label dut/sink_eop /oc8051_fft_top_tb/dut/sink_eop
add wave -noupdate -label dut/sink_valid /oc8051_fft_top_tb/dut/sink_valid
add wave -noupdate -format Analog-Step -height 74 -label dut/sink_real -max 2042.0 -min -61.0 -radix decimal /oc8051_fft_top_tb/dut/sink_real
add wave -noupdate -format Analog-Step -height 74 -label dut/sink_imag -max 149.0 -min -150.0 -radix decimal /oc8051_fft_top_tb/dut/sink_imag
add wave -noupdate -label dut/source_sop /oc8051_fft_top_tb/dut/source_sop
add wave -noupdate -label dut/source_eop /oc8051_fft_top_tb/dut/source_eop
add wave -noupdate -label dut/source_valid /oc8051_fft_top_tb/dut/source_valid
add wave -noupdate -format Analog-Step -height 74 -label dut/source_real -max 514.0 -min -78.0 -radix decimal /oc8051_fft_top_tb/dut/source_real
add wave -noupdate -format Analog-Step -height 74 -label dut/source_imag -max 149.0 -min -150.0 -radix decimal /oc8051_fft_top_tb/dut/source_imag
add wave -noupdate -label dut/w_source_exp -radix decimal /oc8051_fft_top_tb/dut/w_source_exp
add wave -noupdate -label dut/source_error /oc8051_fft_top_tb/dut/source_error
add wave -noupdate -label dut/w_source_exp_1 /oc8051_fft_top_tb/dut/w_source_exp_1
add wave -noupdate -label dut/w_source_exp_2 /oc8051_fft_top_tb/dut/w_source_exp_2
add wave -noupdate -format Analog-Step -height 74 -label dut/r_source_scaled -max 3103.9999999999995 -min -928.0 -radix decimal -childformat {{{/oc8051_fft_top_tb/dut/r_source_scaled[13]} -radix decimal} {{/oc8051_fft_top_tb/dut/r_source_scaled[12]} -radix decimal} {{/oc8051_fft_top_tb/dut/r_source_scaled[11]} -radix decimal} {{/oc8051_fft_top_tb/dut/r_source_scaled[10]} -radix decimal} {{/oc8051_fft_top_tb/dut/r_source_scaled[9]} -radix decimal} {{/oc8051_fft_top_tb/dut/r_source_scaled[8]} -radix decimal} {{/oc8051_fft_top_tb/dut/r_source_scaled[7]} -radix decimal} {{/oc8051_fft_top_tb/dut/r_source_scaled[6]} -radix decimal} {{/oc8051_fft_top_tb/dut/r_source_scaled[5]} -radix decimal} {{/oc8051_fft_top_tb/dut/r_source_scaled[4]} -radix decimal} {{/oc8051_fft_top_tb/dut/r_source_scaled[3]} -radix decimal} {{/oc8051_fft_top_tb/dut/r_source_scaled[2]} -radix decimal} {{/oc8051_fft_top_tb/dut/r_source_scaled[1]} -radix decimal} {{/oc8051_fft_top_tb/dut/r_source_scaled[0]} -radix decimal}} -subitemconfig {{/oc8051_fft_top_tb/dut/r_source_scaled[13]} {-height 15 -radix decimal} {/oc8051_fft_top_tb/dut/r_source_scaled[12]} {-height 15 -radix decimal} {/oc8051_fft_top_tb/dut/r_source_scaled[11]} {-height 15 -radix decimal} {/oc8051_fft_top_tb/dut/r_source_scaled[10]} {-height 15 -radix decimal} {/oc8051_fft_top_tb/dut/r_source_scaled[9]} {-height 15 -radix decimal} {/oc8051_fft_top_tb/dut/r_source_scaled[8]} {-height 15 -radix decimal} {/oc8051_fft_top_tb/dut/r_source_scaled[7]} {-height 15 -radix decimal} {/oc8051_fft_top_tb/dut/r_source_scaled[6]} {-height 15 -radix decimal} {/oc8051_fft_top_tb/dut/r_source_scaled[5]} {-height 15 -radix decimal} {/oc8051_fft_top_tb/dut/r_source_scaled[4]} {-height 15 -radix decimal} {/oc8051_fft_top_tb/dut/r_source_scaled[3]} {-height 15 -radix decimal} {/oc8051_fft_top_tb/dut/r_source_scaled[2]} {-height 15 -radix decimal} {/oc8051_fft_top_tb/dut/r_source_scaled[1]} {-height 15 -radix decimal} {/oc8051_fft_top_tb/dut/r_source_scaled[0]} {-height 15 -radix decimal}} /oc8051_fft_top_tb/dut/r_source_scaled
add wave -noupdate -divider Filter
add wave -noupdate -label filter/clk /oc8051_fft_top_tb/dut/filter/clk
add wave -noupdate -label filter/i_start /oc8051_fft_top_tb/dut/filter/i_start
add wave -noupdate -label filter/i_data -radix decimal /oc8051_fft_top_tb/dut/filter/i_data
add wave -noupdate -label filter/o_data -radix decimal /oc8051_fft_top_tb/dut/filter/o_data
add wave -noupdate -label filter/o_finish /oc8051_fft_top_tb/dut/filter/o_finish
add wave -noupdate -label filter/r_data -radix decimal /oc8051_fft_top_tb/dut/filter/r_data
add wave -noupdate -label filter/r_start_hold /oc8051_fft_top_tb/dut/filter/r_start_hold
add wave -noupdate -label filter/r_counter -radix unsigned /oc8051_fft_top_tb/dut/filter/r_counter
add wave -noupdate -divider fifo
add wave -noupdate -label w_fifo_wr_rqst /oc8051_fft_top_tb/w_fifo_wr_rqst
add wave -noupdate -format Analog-Step -height 74 -label w_fifo_data -max 4094.9999999999995 -radix unsigned -childformat {{{/oc8051_fft_top_tb/w_fifo_data[11]} -radix unsigned} {{/oc8051_fft_top_tb/w_fifo_data[10]} -radix unsigned} {{/oc8051_fft_top_tb/w_fifo_data[9]} -radix unsigned} {{/oc8051_fft_top_tb/w_fifo_data[8]} -radix unsigned} {{/oc8051_fft_top_tb/w_fifo_data[7]} -radix unsigned} {{/oc8051_fft_top_tb/w_fifo_data[6]} -radix unsigned} {{/oc8051_fft_top_tb/w_fifo_data[5]} -radix unsigned} {{/oc8051_fft_top_tb/w_fifo_data[4]} -radix unsigned} {{/oc8051_fft_top_tb/w_fifo_data[3]} -radix unsigned} {{/oc8051_fft_top_tb/w_fifo_data[2]} -radix unsigned} {{/oc8051_fft_top_tb/w_fifo_data[1]} -radix unsigned} {{/oc8051_fft_top_tb/w_fifo_data[0]} -radix unsigned}} -subitemconfig {{/oc8051_fft_top_tb/w_fifo_data[11]} {-height 15 -radix unsigned} {/oc8051_fft_top_tb/w_fifo_data[10]} {-height 15 -radix unsigned} {/oc8051_fft_top_tb/w_fifo_data[9]} {-height 15 -radix unsigned} {/oc8051_fft_top_tb/w_fifo_data[8]} {-height 15 -radix unsigned} {/oc8051_fft_top_tb/w_fifo_data[7]} {-height 15 -radix unsigned} {/oc8051_fft_top_tb/w_fifo_data[6]} {-height 15 -radix unsigned} {/oc8051_fft_top_tb/w_fifo_data[5]} {-height 15 -radix unsigned} {/oc8051_fft_top_tb/w_fifo_data[4]} {-height 15 -radix unsigned} {/oc8051_fft_top_tb/w_fifo_data[3]} {-height 15 -radix unsigned} {/oc8051_fft_top_tb/w_fifo_data[2]} {-height 15 -radix unsigned} {/oc8051_fft_top_tb/w_fifo_data[1]} {-height 15 -radix unsigned} {/oc8051_fft_top_tb/w_fifo_data[0]} {-height 15 -radix unsigned}} /oc8051_fft_top_tb/w_fifo_data
add wave -noupdate -label r_fifo_wr_full /oc8051_fft_top_tb/r_fifo_wr_full
add wave -noupdate -label r_fifo_data -radix hexadecimal /oc8051_fft_top_tb/dut/r_fifo_data
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {171700000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 67
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {108528584 ps} {193834696 ps}
