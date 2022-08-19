`timescale 1ns/1ns

module tb();

	parameter DATA_BITS = 8;   		
	parameter STOP_BITS = 1;   	
	parameter TICK_NBR = 100;
	
	reg clk;
	reg enb_tx;
	reg [DATA_BITS-1:0] i_data_tx;
	
	wire o_data_tx;
//-----------------------------------------------------
//	wire [$clog2(TICK_NBR)-1:0] ticks_count_tx;
//	wire [$clog2(DATA_BITS)-1:0] bits_count_tx;
//   wire [2:0] state_tx;
//   wire [DATA_BITS-1:0] tmp_data_tx;
//-----------------------------------------------------
	initial begin
		i_data_tx <= 8'b10100011;
		clk <= 0;
		enb_tx <= 0;
	end
	
	always begin
		#10;
		clk <= !clk;
	end
	
	uart_tx #(.TICK_NBR(TICK_NBR), .STOP_BITS(STOP_BITS), .DATA_BITS(DATA_BITS)) DUT(
		.i_clk(clk),
		.i_enb_tx(enb_tx),
		.i_data_tx(i_data_tx),
		.o_data_tx(o_data_tx)
	);
	

//	uartt_tx #(.CLKS_PER_BIT(5209))uart_tx (
//		.i_Clock(clk),
//		.i_Tx_DV(enb_tx),
//		.i_Tx_Byte(i_data_tx),
//		.o_Tx_Serial(o_data_tx),
//		.r_SM_Main(state_tx)
//	);
	
	initial begin
		repeat(5) @(posedge clk);
		enb_tx <= 1;
		repeat(5) @(posedge clk);
		enb_tx <= 0;
	end
	
endmodule 