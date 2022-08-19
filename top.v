`include "define.v"
module top(board_clk, enb_tx, o_data_tx, adc_dout, adc_din, adc_cs_n, adc_sclk, led);

	input board_clk;
	input enb_tx;
	input adc_dout;
	
	output o_data_tx;	
	output adc_din;
	output adc_cs_n;
	output adc_sclk;
	output [7:0] led;
	
	wire ready_tx;
	wire [11:0] ch0;
	wire clk;
	
	reg [`DATA_BITS-1:0] i_data_tx = 0;
	
	pll	pll_inst (
	.inclk0 ( board_clk ),
	.c0 ( clk )
	);

	
	uart_tx uart_tx(
		.i_clk(clk),
		.i_enb_tx(enb_tx),
		.i_data_tx(i_data_tx),
		.o_data_tx(o_data_tx),
		.ready_tx(ready_tx)
	);
	
	unnamedadc u0 (
		.CLOCK    (clk),    //                clk.clk
		.RESET    (1'b0),    //              reset.reset
		.CH0      (ch0),      //           readings.CH0
		.CH1      (),      //                   .CH1
		.CH2      (),      //                   .CH2
		.CH3      (),      //                   .CH3
		.CH4      (),      //                   .CH4
		.CH5      (),      //                   .CH5
		.CH6      (),      //                   .CH6
		.CH7      (),      //                   .CH7
		.ADC_SCLK (adc_sclk), // external_interface.SCLK
		.ADC_CS_N (adc_cs_n), //                   .CS_N
		.ADC_DOUT (adc_dout), //                   .DOUT
		.ADC_DIN  (adc_din)   //                   .DIN
	);
	
	always @(posedge clk) begin
	if(ready_tx && enb_tx)
		i_data_tx <= ch0[`DATA_BITS-1:0];
	end
	
	assign led = ch0[7:0];
endmodule 