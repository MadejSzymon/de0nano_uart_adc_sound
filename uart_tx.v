`include "define.v"
module uart_tx 
(i_clk, i_data_tx, i_enb_tx, o_data_tx, ready_tx);
	
	input i_clk;
	input [`DATA_BITS-1:0] i_data_tx;
	input i_enb_tx;
	
	output reg o_data_tx;
	output ready_tx;
//-------------------------------------------------------
	reg [$clog2(`TICK_NBR)-1:0] ticks_count_tx;
	reg [$clog2(`DATA_BITS+2)-1:0] bits_count_tx;
	reg [1:0] state_tx;
	reg [1:0] next_tx;
	reg [`DATA_BITS-1:0] tmp_data_tx;
//-------------------------------------------------------	
	
	parameter [1:0] IDLE = 2'b00,
						 START = 2'b01,
						 DATA = 2'b10,
						 STOP = 2'b11;
	
	initial begin
		state_tx <= IDLE;
		ticks_count_tx <= 0;
		bits_count_tx <= 0;
		o_data_tx <= 1;
		tmp_data_tx <= 0;
	end
	
	assign ready_tx = (state_tx == IDLE && i_enb_tx == 1'b1) ? 1'b1 : 1'b0;
	
	always@(*) begin
		case(state_tx)
		IDLE:begin
			if(i_enb_tx)
				next_tx = START;
			else
				next_tx = IDLE;
		end
		START: begin
			if(ticks_count_tx == `TICK_NBR-1)
				next_tx = DATA;
			else
				next_tx = START;
		end
		DATA: begin
			if(bits_count_tx == `DATA_BITS)
				next_tx = STOP;
			else
				next_tx = DATA;
		end
		STOP: begin
			if(bits_count_tx == `DATA_BITS + `STOP_BITS)
				next_tx = IDLE;
			else
				next_tx = STOP;
		end
		endcase
	end
	
	always @(posedge i_clk) begin
		state_tx <= next_tx;
	end
	
	always @(posedge i_clk) begin
		case (state_tx)
			IDLE:
			begin
				ticks_count_tx <= 0;
				bits_count_tx <= 0;
				o_data_tx <= 1;
				tmp_data_tx <= i_data_tx;
			end
			
			START:
			begin
				o_data_tx <= 0;
				if (ticks_count_tx == `TICK_NBR-1)
					ticks_count_tx <= 0;
				else
					ticks_count_tx <= ticks_count_tx + 1'b1;
			end
			
			DATA:
			begin
				o_data_tx <= tmp_data_tx[0];
				if (ticks_count_tx == `TICK_NBR-1) begin
					bits_count_tx <= bits_count_tx + 1'b1;
					if (bits_count_tx != `DATA_BITS - 1)
						tmp_data_tx <= tmp_data_tx >> 1;
					ticks_count_tx <= 0;
				end
				else begin
					ticks_count_tx <= ticks_count_tx + 1'b1;
				end
				
				if (bits_count_tx == `DATA_BITS)
					o_data_tx <= 1'b1;
				
			end
			
			STOP:
			begin
				if (ticks_count_tx == `TICK_NBR-1) begin
					bits_count_tx <= bits_count_tx + 1'b1;
					ticks_count_tx <= 0;
				end
				else begin
					ticks_count_tx <= ticks_count_tx + 1'b1;
				end
				
			end
			
			
		endcase
	end
	
endmodule 