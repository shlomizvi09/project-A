/*------------------------------------------------------------------------------
 * File          : correlation_cell_testbench.sv
 * Project       : RTL
 * Author        : epabsz
 * Creation date : Dec 22, 2021
 * Description   :
 *------------------------------------------------------------------------------*/

module CL_TB #() ();
	`include "Parameters.svh"
	logic CLK;
	logic [PIXEL_SIZE-1:0] I_in_line[LINE_SIZE];
	logic [PIXEL_SIZE-1:0] T_in_line[LINE_SIZE][NUM_TEMPLATES];
	logic [2*PIXEL_SIZE-1:0] I_square_out_line[LINE_SIZE];
	logic [2*PIXEL_SIZE-1:0] I_out_line[LINE_SIZE];
	logic [2*PIXEL_SIZE-1:0] T_x_I_out_lines[NUM_TEMPLATES][LINE_SIZE];
initial begin
	CLK = 0;	
	
	for (int i = 0; i<LINE_SIZE ; i++) begin
		for (int j = 0; j<10 ; j++) begin
			I_in_line[j]<= $urandom_range(0,255);
			for (int k = 0; k<10 ; k++) begin
				T_in_line[j][k]<= $urandom_range(0,255);
			end
		end
		#11;
	end
	#100 $finish;
	
end
always
begin
	#3 CLK = ~CLK;
	
end
correlation_line CL_test(.CLK(CLK), .I_in_line(I_in_line), .T_in_line(T_in_line), .I_square_out_line(I_square_out_line), .I_out_line(I_out_line), .T_x_I_out_lines_transpose(T_x_I_out_lines));

endmodule