onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -label spi_tb/rst /adc128s022_spi_tb/rst
add wave -noupdate -label spi_tb/clk /adc128s022_spi_tb/clk
add wave -noupdate -label spi_tb/reg_ADD -radix hexadecimal /adc128s022_spi_tb/reg_ADD
add wave -noupdate -label reg_din /adc128s022_spi_tb/reg_din
add wave -noupdate -label reg_flagStart /adc128s022_spi_tb/reg_flagStart
add wave -noupdate -label w_DB -radix hexadecimal /adc128s022_spi_tb/w_DB
add wave -noupdate -label w_cs /adc128s022_spi_tb/w_cs
add wave -noupdate -label w_sclk /adc128s022_spi_tb/w_sclk
add wave -noupdate -label w_dout /adc128s022_spi_tb/w_dout
add wave -noupdate -label w_flagReady /adc128s022_spi_tb/w_flagReady
add wave -noupdate -label 1/reg_index_up -radix hexadecimal /adc128s022_spi_tb/adc128s022_1/reg_index_up
add wave -noupdate -label 1/reg_index_down -radix hexadecimal /adc128s022_spi_tb/adc128s022_1/reg_index_down
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1690000 ps} 0}
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
configure wave -timelineunits ns
update
WaveRestoreZoom {1515850 ps} {1942858 ps}
