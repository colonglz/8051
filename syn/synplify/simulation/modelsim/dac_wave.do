onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -label tb/w_io_sda /oc8051_dac_tb/w_io_sda
add wave -noupdate -label tb/w_o_scl /oc8051_dac_tb/w_o_scl
add wave -noupdate -label tb/w_o_ack /oc8051_dac_tb/w_o_ack
add wave -noupdate -label tb/clk /oc8051_dac_tb/clk
add wave -noupdate -label tb/rst /oc8051_dac_tb/rst
add wave -noupdate -label tb/w_fifo_clk /oc8051_dac_tb/w_fifo_clk
add wave -noupdate -label tb/r_fifo_data -radix hexadecimal /oc8051_dac_tb/r_fifo_data
add wave -noupdate -label tb/r_fifo_rd_empty /oc8051_dac_tb/r_fifo_rd_empty
add wave -noupdate -label tb/w_fifo_rd_rqst /oc8051_dac_tb/w_fifo_rd_rqst
add wave -noupdate -label tb/cntr -radix unsigned /oc8051_dac_tb/cntr
add wave -noupdate -divider Dac
add wave -noupdate -label dut/st_M -radix unsigned /oc8051_dac_tb/dut/st_M
add wave -noupdate -label dut/r_rqst_fifo_data /oc8051_dac_tb/dut/r_rqst_fifo_data
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {54550000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
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
configure wave -timelineunits ps
update
WaveRestoreZoom {68870400 ps} {101638400 ps}
