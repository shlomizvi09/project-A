/*------------------------------------------------------------------------------
 * File          : correlation_cell_testbench.sv
 * Project       : RTL
 * Author        : epabsz
 * Creation date : Dec 22, 2021
 * Description   :
 *------------------------------------------------------------------------------*/
module correlation_cell_testbench #() ();
	`include "Parameters.svh"
	logic [PIXEL_SIZE-1:0] I;
	logic [PIXEL_SIZE-1:0] T [NUM_TEMPLATES];
	logic [2*PIXEL_SIZE-1:0] I_square_out;
	logic [2*PIXEL_SIZE-1:0] T_x_I_out [NUM_TEMPLATES];
	logic CLK;
initial begin
	CLK = 0;	
	
	for (int i = 0; i<10 ; i++) begin
		I <= $urandom_range(0,255);
		for (int j = 0; j<10 ; j++) begin
			T[j] <= $urandom_range(0,255);
		end
		#11;
	end
	#100 $finish;
	
end
always
begin
	#3 CLK = ~CLK;
	
	
end
correlation_cell correlation_cell_test(.CLK(CLK), .I(I), .T(T), .I_square_out(I_square_out), .T_x_I_out(T_x_I_out));

endmodule