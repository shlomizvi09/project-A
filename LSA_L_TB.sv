/*------------------------------------------------------------------------------
 * File          : LSA_L_TB.sv
 * Project       : RTL
 * Author        : epabsz
 * Creation date : Apr 15, 2022
 * Description   :
 *------------------------------------------------------------------------------*/

module LSA_L_TB #() ();
	`include "Parameters.svh"
	logic CLK;
	logic reset;
	int count;
	logic [$clog2(LINE_SIZE)+2*PIXEL_SIZE-1:0] I_square_out_line_sum;
	logic [$clog2(LINE_SIZE)+2*PIXEL_SIZE-1:0] I_out_line_sum;
	logic [$clog2(LINE_SIZE)+2*PIXEL_SIZE-1:0] T_x_I_out_lines_sum[NUM_TEMPLATES];
	
	logic [$clog2(NUM_OF_LINES)+($clog2(LINE_SIZE)+2*PIXEL_SIZE)-1:0] Acc_lines_sum_I_square;
	logic [$clog2(NUM_OF_LINES)+($clog2(LINE_SIZE)+2*PIXEL_SIZE)-1:0] Acc_lines_sum_I;
	logic [$clog2(NUM_OF_LINES)+($clog2(LINE_SIZE)+2*PIXEL_SIZE)-1:0] Acc_lines_sum_T_x_I_out_lines_sum[NUM_TEMPLATES];

	initial begin
		CLK = 0;
		reset = 0;
		count = 10;
		#30;
		for (int i = 0; i<count ; i++) begin
			if (i==2) begin
				reset<=1;
				#1
			    reset<=0;
			end
			I_square_out_line_sum <= $urandom_range(0,255);
			I_out_line_sum <= $urandom_range(0,255);
			for (int j = 0; j < NUM_TEMPLATES; j++) begin
				T_x_I_out_lines_sum[j] <= $urandom_range(0,255);
			end
			#20;
			
		end
		#100 $finish;
	end
	always
	begin
		#10 CLK = ~CLK;
		
		
	end
	Line_Sum_Accumulators_Line Line_sum_Accumulators_test(.CLK(CLK), .reset(reset), .I_square_out_line_sum(I_square_out_line_sum), .I_out_line_sum(I_out_line_sum), .T_x_I_out_lines_sum(T_x_I_out_lines_sum),.Acc_lines_sum_I_square(Acc_lines_sum_I_square) ,.Acc_lines_sum_I(Acc_lines_sum_I), .Acc_lines_sum_T_x_I_out_lines_sum(Acc_lines_sum_T_x_I_out_lines_sum));

	endmodule