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
add wave -noupdate -label dut/source_real -radix decimal /oc8051_fft_top_tb/dut/source_real
add wave -noupdate -format Analog-Step -height 74 -label dut/source_imag -max 149.0 -min -150.0 -radix decimal /oc8051_fft_top_tb/dut/source_imag
add wave -noupdate -label dut/w_source_exp -radix decimal /oc8051_fft_top_tb/dut/w_source_exp
add wave -noupdate -label dut/source_error /oc8051_fft_top_tb/dut/source_error
add wave -noupdate -format Analog-Step -height 74 -label dut/r_source_scaled -max 1999.9999999999998 -radix decimal /oc8051_fft_top_tb/dut/r_source_scaled
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {326439756 ps} 0}
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
WaveRestoreZoom {0 ps} {723091456 ps}
