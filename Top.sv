/*------------------------------------------------------------------------------
 * File          : Top.sv
 * Project       : RTL
 * Author        : epabsz
 * Creation date : Apr 29, 2022
 * Description   :
 *------------------------------------------------------------------------------*/

module Top#() (CLK, reset, I_in_line, T_in_line, Acc_lines_sum_I_square, Acc_lines_sum_I, 
				Acc_lines_sum_T_x_I_out_top);
				
	`include "Parameters.svh"
	input CLK;
	input reset;
	input [PIXEL_SIZE-1:0] I_in_line[LINE_SIZE];
	input [PIXEL_SIZE-1:0] T_in_line[LINE_SIZE][NUM_TEMPLATES];
	
	output [$clog2(NUM_OF_LINES)+($clog2(LINE_SIZE)+2*PIXEL_SIZE)-1:0] Acc_lines_sum_I_square;
	output [$clog2(NUM_OF_LINES)+($clog2(LINE_SIZE)+2*PIXEL_SIZE)-1:0] Acc_lines_sum_I;
	output [$clog2(NUM_OF_LINES)+($clog2(LINE_SIZE)+2*PIXEL_SIZE)-1:0] Acc_lines_sum_T_x_I_out_top[NUM_TEMPLATES];
	
	//Input Buffer output | Template Datapath input
	logic [PIXEL_SIZE-1:0] I_out_line_buffer[LINE_SIZE];
	logic [PIXEL_SIZE-1:0] T_out_line_buffer[LINE_SIZE][NUM_TEMPLATES];	
	
	// Template Datapath output | LineSum Accumulator input
	logic [$clog2(LINE_SIZE)+2*PIXEL_SIZE-1:0] I_square_out_line_sum_DP;
	logic [$clog2(LINE_SIZE)+2*PIXEL_SIZE-1:0] I_out_line_sum_DP;
	logic [$clog2(LINE_SIZE)+2*PIXEL_SIZE-1:0] T_x_I_out_lines_sum_DP[NUM_TEMPLATES];
	
	// Top output
	logic [$clog2(NUM_OF_LINES)+($clog2(LINE_SIZE)+2*PIXEL_SIZE)-1:0] Acc_lines_sum_I_square_tmp;
	logic [$clog2(NUM_OF_LINES)+($clog2(LINE_SIZE)+2*PIXEL_SIZE)-1:0] Acc_lines_sum_I_tmp;
	logic [$clog2(NUM_OF_LINES)+($clog2(LINE_SIZE)+2*PIXEL_SIZE)-1:0] Acc_lines_sum_T_x_I_out_lines_sum_tmp[NUM_TEMPLATES];
	
	input_buffer b1 (.CLK(CLK), .I_in_line(I_in_line), .T_in_line(T_in_line), .I_out_line(I_out_line_buffer),
						.T_out_line(T_out_line_buffer));
	
	
	template_datapath td1(.CLK(CLK), .I_in_line(I_out_line_buffer), .T_in_line(T_out_line_buffer),
	.I_square_out_line_sum(I_square_out_line_sum_DP),.I_out_line_sum(I_out_line_sum_DP)
	, .T_x_I_out_lines_sum(T_x_I_out_lines_sum_DP));


	Line_Sum_Accumulators_Line lsa1(.CLK(CLK), .reset(reset), .I_square_out_line_sum(I_square_out_line_sum_DP)
	, .I_out_line_sum(I_out_line_sum_DP), .T_x_I_out_lines_sum(T_x_I_out_lines_sum_DP), 
	.Acc_lines_sum_I_square(Acc_lines_sum_I_square_tmp),.Acc_lines_sum_I(Acc_lines_sum_I_tmp),
	.Acc_lines_sum_T_x_I_out_lines_sum(Acc_lines_sum_T_x_I_out_lines_sum_tmp));
	
	assign Acc_lines_sum_I_square = Acc_lines_sum_I_square_tmp;
	assign Acc_lines_sum_I = Acc_lines_sum_I_tmp;
	assign Acc_lines_sum_T_x_I_out_top = Acc_lines_sum_T_x_I_out_lines_sum_tmp;
	
endmodule
	