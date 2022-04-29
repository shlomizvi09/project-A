/*------------------------------------------------------------------------------
 * File          : Top_TB.sv
 * Project       : RTL
 * Author        : epabsz
 * Creation date : Apr 29, 2022
 * Description   :
 *------------------------------------------------------------------------------*/

module Top_TB #() ();
	`include "Parameters.svh"
	
	logic CLK;
	logic reset;
	logic [PIXEL_SIZE-1:0] I_in_line[LINE_SIZE];
	logic [PIXEL_SIZE-1:0] T_in_line[LINE_SIZE][NUM_TEMPLATES];
	
	logic [$clog2(NUM_OF_LINES)+($clog2(LINE_SIZE)+2*PIXEL_SIZE)-1:0] Acc_lines_sum_I_square;
	logic [$clog2(NUM_OF_LINES)+($clog2(LINE_SIZE)+2*PIXEL_SIZE)-1:0] Acc_lines_sum_I;
	logic [$clog2(NUM_OF_LINES)+($clog2(LINE_SIZE)+2*PIXEL_SIZE)-1:0] Acc_lines_sum_T_x_I_out_top[NUM_TEMPLATES];
	
	int CLK_counter;
	
	initial begin
		CLK = 0;	
		reset = 0;
		CLK_counter = 0;
		for (int i = 0; i<10;i++) begin
			for (int j = 0; j<LINE_SIZE; j++) begin
				I_in_line[j] <= $urandom_range(0,255);
				for (int k = 0; k<NUM_TEMPLATES; k++) begin
					T_in_line[j][k] <= $urandom_range(0,255);
				end
			end
			#6;
			CLK_counter++;
		end
		#300 $finish;
		
	end
	always begin
		#3 CLK = ~CLK;
	end
	
	always @(posedge CLK) begin
		if((CLK_counter-3) % 5 == 0) begin
			reset = 1;
			#1;
			reset = 0;
		end
	end
	
	
	Top u0(.CLK(CLK),.reset(reset), .I_in_line(I_in_line), .T_in_line(T_in_line),
			.Acc_lines_sum_I_square(Acc_lines_sum_I_square), .Acc_lines_sum_I(Acc_lines_sum_I), 
			.Acc_lines_sum_T_x_I_out_top(Acc_lines_sum_T_x_I_out_top));

endmodule