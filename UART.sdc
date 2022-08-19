create_clock -name board_clk -period 20.000 [get_ports {board_clk}]
derive_clock_uncertainty
derive_pll_clocks -create_base_clocks


set_false_path -from [get_ports {adc_dout enb_tx}]
set_false_path -to [get_ports {adc_cs_n adc_din adc_sclk led[*] o_data_tx}]