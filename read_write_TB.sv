module read_write_TB #() ();
	logic a;
	logic b;
	logic res;

	initial begin
        for (int i=0; i< 5; i++) begin
            a=1;
            b=0;
            $write("res = %d\n", res);
            #5;
        end
    end
    adder u0(.a(a), .b(b), .c(res));
endmodule