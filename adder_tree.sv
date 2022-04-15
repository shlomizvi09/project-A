/*------------------------------------------------------------------------------
 * File          : adder_tree.sv
 * Project       : RTL
 * Author        : epabsz
 * Creation date : Jan 19, 2022
 * Description   :
 *------------------------------------------------------------------------------*/

module adder_tree #() (CLK, line_in, line_sum_out);
	`include "Parameters.svh"
	input CLK;
	input [2*PIXEL_SIZE-1:0] line_in [LINE_SIZE-1:0];
	output [$clog2(LINE_SIZE)+2*PIXEL_SIZE-1:0] line_sum_out;
	
	logic [2*PIXEL_SIZE-1:0] temp_reg [LINE_SIZE-1:0];
	logic [$clog2(LINE_SIZE)+2*PIXEL_SIZE-1:0] temp_sum;
	
	always_ff @ (posedge CLK) begin
		temp_reg<=line_in;
	end

	always_comb begin
		temp_sum = 0;
		for (int i=0; i<LINE_SIZE; i= i+1) begin
			temp_sum = temp_sum + temp_reg[i];
		end
	end
	assign line_sum_out = temp_sum;

endmodule