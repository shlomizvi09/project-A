/*------------------------------------------------------------------------------
 * File          : correlation_cell.sv
 * Project       : RTL
 * Author        : epabsz
 * Creation date : Dec 22, 2021
 * Description   :
 *------------------------------------------------------------------------------*/
module correlation_cell #() (CLK, I, T,I_out, I_square_out, T_x_I_out);
	`include "Parameters.svh"
			
	input CLK;
	input [PIXEL_SIZE-1:0] I;
	input [PIXEL_SIZE-1:0] T [NUM_TEMPLATES];
	output [2*PIXEL_SIZE-1:0] I_out;
	output [2*PIXEL_SIZE-1:0] I_square_out;
	output [2*PIXEL_SIZE-1:0] T_x_I_out [NUM_TEMPLATES];
	
	logic [PIXEL_SIZE-1:0] reg_I;
	logic [PIXEL_SIZE-1:0] reg_T [NUM_TEMPLATES];
	logic [2*PIXEL_SIZE-1:0] I_square;
	logic [2*PIXEL_SIZE-1:0] T_x_I [NUM_TEMPLATES];
	
	always_ff @ (posedge CLK) begin
		reg_I <= I;
		for (int i=0; i<NUM_TEMPLATES; i++) begin
			reg_T[i] <= T[i];	
		end
	end
	
	always_comb begin
		I_square = reg_I*reg_I;
		for (int i=0; i<NUM_TEMPLATES; i++) begin
			T_x_I[i] = reg_T[i]*reg_I;
		end
	end
	assign I_out = reg_I;
	assign I_square_out = I_square;
	assign T_x_I_out = T_x_I;

endmodule