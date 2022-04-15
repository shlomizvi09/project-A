/*------------------------------------------------------------------------------
 * File          : template_datapath_TB.sv
 * Project       : RTL
 * Author        : epabsz
 * Creation date : Jan 23, 2022
 * Description   :
 *------------------------------------------------------------------------------*/

module template_datapath_TB #() ();
	`include "Parameters.svh"
	logic CLK;
	logic [PIXEL_SIZE-1:0] I_in_line[LINE_SIZE];
	logic [PIXEL_SIZE-1:0] T_in_line[LINE_SIZE][NUM_TEMPLATES];
	logic [$clog2(LINE_SIZE)+2*PIXEL_SIZE-1:0] I_square_out_line_sum;
	logic [$clog2(LINE_SIZE)+2*PIXEL_SIZE-1:0] I_out_line_sum;
	logic [$clog2(LINE_SIZE)+2*PIXEL_SIZE-1:0] T_x_I_out_lines_sum[NUM_TEMPLATES];
	
	initial begin
	CLK = 0;	
	
	
	for (int i = 0; i<LINE_SIZE ; i++) begin
		for (int j = 0; j<10 ; j++) begin
			I_in_line[j]<= $urandom_range(0,255);
			for (int k = 0; k<10 ; k++) begin
				T_in_line[j][k]<= $urandom_range(0,255);
			end
		end
		#10;
	end
	#100 $finish;
	
	end
	always
	begin
	#5 CLK = ~CLK;
	
	end
	template_datapath TDP_test(.CLK(CLK), .I_in_line(I_in_line), .T_in_line(T_in_line), .I_square_out_line_sum(I_square_out_line_sum), .I_out_line_sum(I_out_line_sum), .T_x_I_out_lines_sum(T_x_I_out_lines_sum));

endmodule