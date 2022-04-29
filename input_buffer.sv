/*------------------------------------------------------------------------------
 * File          : input_buffer.sv
 * Project       : RTL
 * Author        : epabsz
 * Creation date : Apr 29, 2022
 * Description   :
 *------------------------------------------------------------------------------*/



module input_buffer #() (CLK, I_in_line, T_in_line, I_out_line, T_out_line);
	`include "Parameters.svh"

	input CLK;
	input [PIXEL_SIZE-1:0] I_in_line[LINE_SIZE];
	input [PIXEL_SIZE-1:0] T_in_line[LINE_SIZE][NUM_TEMPLATES];
	output [PIXEL_SIZE-1:0] I_out_line[LINE_SIZE];
	output [PIXEL_SIZE-1:0] T_out_line[LINE_SIZE][NUM_TEMPLATES];
	
	logic [PIXEL_SIZE-1:0] I_in_line_reg[LINE_SIZE];
	logic [PIXEL_SIZE-1:0] T_in_line_regs[LINE_SIZE][NUM_TEMPLATES];

	always_ff @ (posedge CLK) begin
		I_in_line_reg <= I_in_line;
		T_in_line_regs <= T_in_line;
	end
	
	assign I_out_line = I_in_line_reg;
	assign T_out_line = T_in_line_regs;
	
endmodule

