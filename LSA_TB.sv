/*------------------------------------------------------------------------------
 * File          : LSA_TB.sv
 * Project       : RTL
 * Author        : epabsz
 * Creation date : Mar 27, 2022
 * Description   :
 *------------------------------------------------------------------------------*/

module LSA_TB #() ();
	`include "Parameters.svh"
	logic CLK;
	logic reset;
	logic [$clog2(LINE_SIZE)+2*PIXEL_SIZE-1:0] line_sum;
	logic [$clog2(NUM_OF_LINES)+($clog2(LINE_SIZE)+2*PIXEL_SIZE)-1:0] Acc_lines_sum;

	initial begin
		CLK = 0;
		reset = 0;
		
		for (int i = 0; i<3 * NUM_OF_LINES ; i++) begin
			line_sum <= $urandom_range(0,255);
			//if (i==4) begin
			//	reset<=1;
			//	#1
			 //   reset<=0;
			//end
			#20;
			
		end
		#400 $finish;
	end
	always
	begin
		#10 CLK = ~CLK;
		
		
	end
	Line_sum_Accumulator Line_sum_Accumulator_test(.CLK(CLK), .line_sum(line_sum),.reset(reset), .Acc_lines_sum(Acc_lines_sum));

	endmodule