/*------------------------------------------------------------------------------
 * File          : Line_Sum_Accumulators_Line.sv
 * Project       : RTL
 * Author        : epabsz
 * Creation date : Apr 15, 2022
 * Description   :
 *------------------------------------------------------------------------------*/



module Line_Sum_Accumulators_Line #() (CLK, reset, I_square_out_line_sum, I_out_line_sum, T_x_I_out_lines_sum, Acc_lines_sum_I_square,
										Acc_lines_sum_I, Acc_lines_sum_T_x_I_out_lines_sum);
	`include "Parameters.svh"

	input CLK;
	input reset;
	input [$clog2(LINE_SIZE)+2*PIXEL_SIZE-1:0] I_square_out_line_sum;
	input [$clog2(LINE_SIZE)+2*PIXEL_SIZE-1:0] I_out_line_sum;
	input [$clog2(LINE_SIZE)+2*PIXEL_SIZE-1:0] T_x_I_out_lines_sum[NUM_TEMPLATES];
	
	output [$clog2(NUM_OF_LINES)+($clog2(LINE_SIZE)+2*PIXEL_SIZE)-1:0] Acc_lines_sum_I_square;
	output [$clog2(NUM_OF_LINES)+($clog2(LINE_SIZE)+2*PIXEL_SIZE)-1:0] Acc_lines_sum_I;
	output [$clog2(NUM_OF_LINES)+($clog2(LINE_SIZE)+2*PIXEL_SIZE)-1:0] Acc_lines_sum_T_x_I_out_lines_sum[NUM_TEMPLATES];

	logic [$clog2(NUM_OF_LINES)+($clog2(LINE_SIZE)+2*PIXEL_SIZE)-1:0] sum_I_square;
	logic [$clog2(NUM_OF_LINES)+($clog2(LINE_SIZE)+2*PIXEL_SIZE)-1:0] sum_I;
	logic [$clog2(NUM_OF_LINES)+($clog2(LINE_SIZE)+2*PIXEL_SIZE)-1:0] sum_T_x_I_out_lines_sum[NUM_TEMPLATES];
	
	Line_sum_Accumulator u0(.CLK(CLK), .reset(reset), .line_sum(I_square_out_line_sum), .Acc_lines_sum(sum_I_square));
	Line_sum_Accumulator u1(.CLK(CLK), .reset(reset), .line_sum(I_out_line_sum), .Acc_lines_sum(sum_I));

	genvar i;
	
	generate
		for (i=0; i<NUM_TEMPLATES; i=i+1)begin	
			Line_sum_Accumulator u2(.CLK(CLK), .reset(reset), .line_sum(T_x_I_out_lines_sum[i]), .Acc_lines_sum(sum_T_x_I_out_lines_sum[i]));
		end
	endgenerate
	
	assign Acc_lines_sum_I_square = sum_I_square;
	assign Acc_lines_sum_I = sum_I;
	assign Acc_lines_sum_T_x_I_out_lines_sum = sum_T_x_I_out_lines_sum;

endmodule

