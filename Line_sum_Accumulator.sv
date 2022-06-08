
module Line_sum_Accumulator #() (CLK, reset, line_sum, Acc_lines_sum);
	`include "Parameters.svh"
	input CLK;
	input reset;
	input [$clog2(LINE_SIZE)+2*PIXEL_SIZE-1:0] line_sum;
	output [$clog2(NUM_OF_LINES)+($clog2(LINE_SIZE)+2*PIXEL_SIZE)-1:0] Acc_lines_sum;
	
	logic [$clog2(NUM_OF_LINES)+($clog2(LINE_SIZE)+2*PIXEL_SIZE)-1:0] temp__line_sum = 0;
	logic [$clog2(NUM_OF_LINES)+($clog2(LINE_SIZE)+2*PIXEL_SIZE)-1:0] Acc_sum =0;
	int counter = 0;
	
	always_ff @ (posedge CLK or posedge reset) begin
		if (reset) begin
			temp__line_sum <= 0;
			counter <= 0;
		end
		else begin
			if(line_sum != "X") begin
				temp__line_sum <= temp__line_sum + line_sum;
				if (counter == 0) begin
					temp__line_sum <= line_sum;
				end
				counter <= (counter + 1) % NUM_OF_LINES;
			end
		end
	end
	
	always_comb begin
		if (counter == 0) begin
			Acc_sum = temp__line_sum;
		end
		else begin
			Acc_sum = 0;
		end
	end
	
	assign Acc_lines_sum = Acc_sum;

endmodule
