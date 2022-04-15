/*------------------------------------------------------------------------------
 * File          : template_datapath.sv
 * Project       : RTL
 * Author        : epabsz
 * Creation date : Jan 23, 2022
 * Description   :
 *------------------------------------------------------------------------------*/
parameter PIXEL_SIZE = 8;
parameter NUM_TEMPLATES = 2;
parameter LINE_SIZE = 5;
parameter NUM_OF_LINES = 5;

module template_datapath #() (CLK, I_in_line, T_in_line, I_square_out_line_sum,
								I_out_line_sum, T_x_I_out_lines_sum);
	input CLK;
	input [PIXEL_SIZE-1:0] I_in_line[LINE_SIZE];
	input [PIXEL_SIZE-1:0] T_in_line[LINE_SIZE][NUM_TEMPLATES];
	
	logic [2*PIXEL_SIZE-1:0] I_square_out_line[LINE_SIZE];
	logic [2*PIXEL_SIZE-1:0] I_out_line[LINE_SIZE];
	logic [2*PIXEL_SIZE-1:0] T_x_I_out_lines_transpose[NUM_TEMPLATES][LINE_SIZE];
	
	output [$clog2(LINE_SIZE)+2*PIXEL_SIZE-1:0] I_square_out_line_sum;
	output [$clog2(LINE_SIZE)+2*PIXEL_SIZE-1:0] I_out_line_sum;
	output [$clog2(LINE_SIZE)+2*PIXEL_SIZE-1:0] T_x_I_out_lines_sum[NUM_TEMPLATES];
	
	correlation_line cl (.CLK(CLK), .I_in_line(I_in_line), .T_in_line(T_in_line), .I_square_out_line(I_square_out_line),
							.I_out_line(I_out_line), .T_x_I_out_lines_transpose(T_x_I_out_lines_transpose));
	
	adder_tree at1(.CLK(CLK), .line_in(I_square_out_line), .line_sum_out(I_square_out_line_sum));
	adder_tree at2(.CLK(CLK), .line_in(I_out_line), .line_sum_out(I_out_line_sum));

	genvar i;
	generate
		for (i=0; i<NUM_TEMPLATES; i=i+1) begin	
			adder_tree u0(.CLK(CLK), .line_in(T_x_I_out_lines_transpose[i]), .line_sum_out(T_x_I_out_lines_sum[i]));
		end
	endgenerate

endmodule