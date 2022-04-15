/*------------------------------------------------------------------------------
 * File          : correlation_line.sv
 * Project       : RTL
 * Author        : epabsz
 * Creation date : Jan 2, 2022
 * Description   :
 *------------------------------------------------------------------------------*/



module correlation_line #() (CLK, I_in_line, T_in_line, I_square_out_line, I_out_line, T_x_I_out_lines_transpose);
	`include "Parameters.svh"

	input CLK;
	input [PIXEL_SIZE-1:0] I_in_line[LINE_SIZE];
	input [PIXEL_SIZE-1:0] T_in_line[LINE_SIZE][NUM_TEMPLATES];
	output [2*PIXEL_SIZE-1:0] I_square_out_line[LINE_SIZE];
	output [2*PIXEL_SIZE-1:0] I_out_line[LINE_SIZE];
	output [2*PIXEL_SIZE-1:0] T_x_I_out_lines_transpose[NUM_TEMPLATES][LINE_SIZE];
	logic [2*PIXEL_SIZE-1:0] T_x_I_lines_transpose_temp[NUM_TEMPLATES][LINE_SIZE];
	logic [2*PIXEL_SIZE-1:0] T_x_I_lines[LINE_SIZE][NUM_TEMPLATES];
	
	always_comb begin
		for(int j=0; j<NUM_TEMPLATES;j=j+1)begin
			for(int k=0; k<LINE_SIZE;k=k+1)begin
				T_x_I_lines_transpose_temp[j][k]<=T_x_I_lines[k][j];
			end
		end
	end 
	assign T_x_I_out_lines_transpose = T_x_I_lines_transpose_temp;
	
	
	genvar i;
	
	generate
		for (i=0; i<LINE_SIZE; i=i+1)begin	
			correlation_cell u0(.CLK(CLK),.I(I_in_line[i]),.T(T_in_line[i]),.I_square_out(I_square_out_line[i]),.I_out(I_out_line[i]),.T_x_I_out(T_x_I_lines[i]));
		end
	endgenerate
	

	
	
endmodule

