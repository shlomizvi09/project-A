/*------------------------------------------------------------------------------
 * File          : correlation_cell_testbench.sv
 * Project       : RTL
 * Author        : epabsz
 * Creation date : Dec 22, 2021
 * Description   :
 *------------------------------------------------------------------------------*/


module adder_tree_TB #() ();
	`include "Parameters.svh"
	logic CLK;
	logic [2*PIXEL_SIZE-1:0] I_in_line[LINE_SIZE-1:0];
	logic [$clog2(LINE_SIZE)+2*PIXEL_SIZE-1:0] line_sum_out;
initial begin
	CLK = 0;	
	
	for (int j = 0; j<5 ; j++) begin
		for (int i = 0; i<LINE_SIZE ; i++) begin
			I_in_line[i]<= $urandom_range(0,65000);
		end
		#10;
	end
	#100 $finish;
	
end
always
begin
	#3 CLK = ~CLK;
	
end
adder_tree at_test(.CLK(CLK), .line_in(I_in_line), .line_sum_out(line_sum_out));

endmodule