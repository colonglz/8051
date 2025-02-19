create_clock -period 20 [get_ports clk]
create_generated_clock -divide_by 6 -source [get_ports clk] -name \
clk_8M33hz [get_pins clk_div1|reg_clk_out|q]
create_generated_clock -divide_by 16 -source [get_ports clk] -name \
clk_3M125hz [get_pins oc8051_adc_u|clk_div_adc|reg_clk_out|q]

# DAC clocks
create_generated_clock -divide_by 250 -source [get_ports clk] -name \
clk_390K62Hz [get_pins dac|clk_div_dac|reg_clk_out|q]
create_generated_clock -divide_by 125 -source [get_ports clk] -name \
clk_781K25Hz [get_pins dac|clk_div_dac_x2|reg_clk_out|q]
create_generated_clock -divide_by 16 -source [get_ports clk] -name \
clk_3M125Hz [get_pins dac|clk_div_dac_hs|reg_clk_out|q]
create_generated_clock -divide_by 8 -source [get_ports clk] -name \
clk_6M25Hz [get_pins dac|clk_div_dac_hs_x2|reg_clk_out|q]


#set cellcollection [get_cells -hierarchical *]
# Create a collection of all cells in the design
# Output cell names.
#foreach_in_collection cell $cellcollection {
# puts $cell
# puts [get_cell_info -name $cell]
#}
 
#set fullcollection [get_pins -nocase clk_div1|reg_clk_out|q]
# Output pin IDs and names.
#foreach_in_collection pin $fullcollection {
# puts -nonewline $pin
# puts -nonewline ": "
# puts [get_pin_info -name $pin]
#}

#set portscollection [get_ports clk]
#foreach_in_collection port $portscollection {
# puts [get_port_info -name $port]
#}