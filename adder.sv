module adder #() (a,b,c);
	input int a;
    input int b;
	output int c;
    
    
    always @ (a or b) begin
        c = a+b;
    end

endmodule
