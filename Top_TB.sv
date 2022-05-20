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
	int fd_image;
	int fd_template;
    int code_image;
    string tmp_str_image;
	int code_template;
    string tmp_str_template;
	
	initial begin
		fd_image = $fopen ("project-A/Project Tests/I_input.txt", "r+");
		fd_template = $fopen ("project-A/Project Tests/T_input.txt", "r+");
		CLK = 0;	
		reset = 0;
		CLK_counter = 0;
		while (!$feof(fd_image)) begin
			for (int j = 0; j<LINE_SIZE; j++) begin
				code_image = $fgets(tmp_str_image, fd_image);
				I_in_line[j] = tmp_str_image.atoi();
				code_template = $fgets(tmp_str_template, fd_template);
				T_in_line[j][0] = tmp_str_template.atoi();
			end
			#2;
			CLK_counter++;
		end
		$fclose(fd_image);
        $fclose(fd_template);
	end
	always begin
		#1 CLK = ~CLK;
		if (Acc_lines_sum_I != 0) begin
			$display("A = %d\nC = %d\nE = %d", Acc_lines_sum_T_x_I_out_top[0], Acc_lines_sum_I, Acc_lines_sum_I_square);
			$finish;
		end
	end
	

	
	
	Top u0(.CLK(CLK),.reset(reset), .I_in_line(I_in_line), .T_in_line(T_in_line),
			.Acc_lines_sum_I_square(Acc_lines_sum_I_square), .Acc_lines_sum_I(Acc_lines_sum_I), 
			.Acc_lines_sum_T_x_I_out_top(Acc_lines_sum_T_x_I_out_top));

endmodule