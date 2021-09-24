onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -label tb/clk /oc8051_fpga_top_tb/clk
add wave -noupdate -label top1/int_rst /oc8051_fpga_top_tb/oc8051_fpga_top1/int_rst
add wave -noupdate -label top1/p0_out /oc8051_fpga_top_tb/oc8051_fpga_top1/p0_out
add wave -noupdate -label top1/p1_out /oc8051_fpga_top_tb/oc8051_fpga_top1/p1_out
add wave -noupdate -label top1/p2_out /oc8051_fpga_top_tb/oc8051_fpga_top1/p2_out
add wave -noupdate -label top1/p3_out /oc8051_fpga_top_tb/oc8051_fpga_top1/p3_out
add wave -noupdate -label rom1/addr -radix hexadecimal /oc8051_fpga_top_tb/oc8051_fpga_top1/oc8051_top_1/oc8051_rom1/addr
add wave -noupdate -label rom1/data_o -radix hexadecimal /oc8051_fpga_top_tb/oc8051_fpga_top1/oc8051_top_1/oc8051_rom1/data_o
add wave -noupdate -label interface1/inc_pc /oc8051_fpga_top_tb/oc8051_fpga_top1/oc8051_top_1/oc8051_memory_interface1/inc_pc
add wave -noupdate -label interface1/pc_out -radix hexadecimal /oc8051_fpga_top_tb/oc8051_fpga_top1/oc8051_top_1/oc8051_memory_interface1/pc_out
add wave -noupdate -label interface1/pc_wr_r2 /oc8051_fpga_top_tb/oc8051_fpga_top1/oc8051_top_1/oc8051_memory_interface1/pc_wr_r2
add wave -noupdate -label interface1/rd /oc8051_fpga_top_tb/oc8051_fpga_top1/oc8051_top_1/oc8051_memory_interface1/rd
add wave -noupdate -label interface1/int_ack_t /oc8051_fpga_top_tb/oc8051_fpga_top1/oc8051_top_1/oc8051_memory_interface1/int_ack_t
add wave -noupdate -label top1/clk_8Mhz /oc8051_fpga_top_tb/oc8051_fpga_top1/clk_8Mhz
add wave -noupdate -label interface1/op_pos /oc8051_fpga_top_tb/oc8051_fpga_top1/oc8051_top_1/oc8051_memory_interface1/op_pos
add wave -noupdate -label interface1/pc_buf -radix hexadecimal /oc8051_fpga_top_tb/oc8051_fpga_top1/oc8051_top_1/oc8051_memory_interface1/pc_buf
add wave -noupdate -color Red -label interface1/pc -radix hexadecimal /oc8051_fpga_top_tb/oc8051_fpga_top1/oc8051_top_1/oc8051_memory_interface1/pc
add wave -noupdate -label interface1/op1_out -radix hexadecimal /oc8051_fpga_top_tb/oc8051_fpga_top1/oc8051_top_1/oc8051_memory_interface1/op1_out
add wave -noupdate -label interface1/op2_out -radix hexadecimal /oc8051_fpga_top_tb/oc8051_fpga_top1/oc8051_top_1/oc8051_memory_interface1/op2_out
add wave -noupdate -label interface1/op3_out -radix hexadecimal /oc8051_fpga_top_tb/oc8051_fpga_top1/oc8051_top_1/oc8051_memory_interface1/op3_out
add wave -noupdate -label sp1/wr /oc8051_fpga_top_tb/oc8051_fpga_top1/oc8051_top_1/oc8051_sfr1/oc8051_sp1/wr
add wave -noupdate -label sp1/write /oc8051_fpga_top_tb/oc8051_fpga_top1/oc8051_top_1/oc8051_sfr1/oc8051_sp1/write
add wave -noupdate -label sp1/wr_addr -radix hexadecimal /oc8051_fpga_top_tb/oc8051_fpga_top1/oc8051_top_1/oc8051_sfr1/oc8051_sp1/wr_addr
add wave -noupdate -label sp1/data_in -radix hexadecimal /oc8051_fpga_top_tb/oc8051_fpga_top1/oc8051_top_1/oc8051_sfr1/oc8051_sp1/data_in
add wave -noupdate -label sp1/sp_out -radix hexadecimal /oc8051_fpga_top_tb/oc8051_fpga_top1/oc8051_top_1/oc8051_sfr1/oc8051_sp1/sp_out
add wave -noupdate -label sp1/sp -radix hexadecimal /oc8051_fpga_top_tb/oc8051_fpga_top1/oc8051_top_1/oc8051_sfr1/oc8051_sp1/sp
add wave -noupdate -label sfr1/sp -radix hexadecimal /oc8051_fpga_top_tb/oc8051_fpga_top1/oc8051_top_1/oc8051_sfr1/sp
add wave -noupdate -label sfr1/sp_w -radix hexadecimal /oc8051_fpga_top_tb/oc8051_fpga_top1/oc8051_top_1/oc8051_sfr1/sp_w
add wave -noupdate -label interface1/rd_addr -radix hexadecimal /oc8051_fpga_top_tb/oc8051_fpga_top1/oc8051_top_1/oc8051_memory_interface1/rd_addr
add wave -noupdate -label ram_top1/wr /oc8051_fpga_top_tb/oc8051_fpga_top1/oc8051_top_1/oc8051_ram_top1/wr
add wave -noupdate -label top1/wr_addr -radix hexadecimal /oc8051_fpga_top_tb/oc8051_fpga_top1/oc8051_top_1/oc8051_ram_top1/wr_addr
add wave -noupdate -label top1/wr_data -radix hexadecimal /oc8051_fpga_top_tb/oc8051_fpga_top1/oc8051_top_1/oc8051_ram_top1/wr_data
add wave -noupdate -label top1/rd_addr -radix hexadecimal /oc8051_fpga_top_tb/oc8051_fpga_top1/oc8051_top_1/oc8051_ram_top1/rd_addr
add wave -noupdate -label top1/rd_data -radix hexadecimal /oc8051_fpga_top_tb/oc8051_fpga_top1/oc8051_top_1/oc8051_ram_top1/rd_data
add wave -noupdate -label idata/rd_en /oc8051_fpga_top_tb/oc8051_fpga_top1/oc8051_top_1/oc8051_ram_top1/oc8051_idata/rd_en
add wave -noupdate -label decoder1/rd /oc8051_fpga_top_tb/oc8051_fpga_top1/oc8051_top_1/oc8051_decoder1/rd
add wave -noupdate -label decoder1/state /oc8051_fpga_top_tb/oc8051_fpga_top1/oc8051_top_1/oc8051_decoder1/state
add wave -noupdate -label decoder1/wait_data /oc8051_fpga_top_tb/oc8051_fpga_top1/oc8051_top_1/oc8051_decoder1/wait_data
add wave -noupdate -label decoder1/mem_wait /oc8051_fpga_top_tb/oc8051_fpga_top1/oc8051_top_1/oc8051_decoder1/mem_wait
add wave -noupdate -label top_1/wbd_ack_i /oc8051_fpga_top_tb/oc8051_fpga_top1/oc8051_top_1/wbd_ack_i
add wave -noupdate -label top_1/wbd_adr_o -radix hexadecimal /oc8051_fpga_top_tb/oc8051_fpga_top1/oc8051_top_1/wbd_adr_o
add wave -noupdate -label top_1/wbd_cyc_o /oc8051_fpga_top_tb/oc8051_fpga_top1/oc8051_top_1/wbd_cyc_o
add wave -noupdate -label top_1/wbd_dat_i -radix hexadecimal /oc8051_fpga_top_tb/oc8051_fpga_top1/oc8051_top_1/wbd_dat_i
add wave -noupdate -label top_1/wbd_dat_o -radix hexadecimal /oc8051_fpga_top_tb/oc8051_fpga_top1/oc8051_top_1/wbd_dat_o
add wave -noupdate -label top_1/wbd_err_i /oc8051_fpga_top_tb/oc8051_fpga_top1/oc8051_top_1/wbd_err_i
add wave -noupdate -label top_1/wbd_stb_o -radix decimal /oc8051_fpga_top_tb/oc8051_fpga_top1/oc8051_top_1/wbd_stb_o
add wave -noupdate -label top_1/wbd_we_o /oc8051_fpga_top_tb/oc8051_fpga_top1/oc8051_top_1/wbd_we_o
add wave -noupdate -label top_1/wbi_dat_i -radix hexadecimal /oc8051_fpga_top_tb/oc8051_fpga_top1/oc8051_top_1/wbi_dat_i
add wave -noupdate -label top_1/wbi_ack_i /oc8051_fpga_top_tb/oc8051_fpga_top1/oc8051_top_1/wbi_ack_i
add wave -noupdate -label interface1/dack_ir /oc8051_fpga_top_tb/oc8051_fpga_top1/oc8051_top_1/oc8051_memory_interface1/dack_ir
add wave -noupdate -label interface1/ddat_ir -radix hexadecimal /oc8051_fpga_top_tb/oc8051_fpga_top1/oc8051_top_1/oc8051_memory_interface1/ddat_ir
add wave -noupdate -label interface1/cdone /oc8051_fpga_top_tb/oc8051_fpga_top1/oc8051_top_1/oc8051_memory_interface1/cdone
add wave -noupdate -label interface1/cdata -radix hexadecimal /oc8051_fpga_top_tb/oc8051_fpga_top1/oc8051_top_1/oc8051_memory_interface1/cdata
add wave -noupdate -label interface1/op1_o -radix hexadecimal /oc8051_fpga_top_tb/oc8051_fpga_top1/oc8051_top_1/oc8051_memory_interface1/op1_o
add wave -noupdate -label interface1/mem_act /oc8051_fpga_top_tb/oc8051_fpga_top1/oc8051_top_1/oc8051_memory_interface1/mem_act
add wave -noupdate -label decoder1/op_cur -radix hexadecimal /oc8051_fpga_top_tb/oc8051_fpga_top1/oc8051_top_1/oc8051_decoder1/op_cur
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1476974 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 144
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
WaveRestoreZoom {1404216 ps} {2444385 ps}
