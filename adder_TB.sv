module adder_TB #() ();
	int a;
	int b;
	int res;
    int fd_in;
    int fd_out;
    int code;
    string tmp_str;

	initial begin
        fd_in = $fopen ("project-A/input.txt", "r+");
        fd_out = $fopen ("project-A/output.txt", "r+");
        while (!$feof(fd_in)) begin
            code = $fgets(tmp_str, fd_in);
            $write ("Line: %s\n", tmp_str);
            a = tmp_str.atoi();
            $write("a = %d\n", a);
            b = tmp_str.atoi();
            $write("b = %d\n", b);
            #1;
            tmp_str.itoa(res);
            $write("res = %d\n", tmp_str);
            $fwrite (fd_out, tmp_str);
            $fwrite(fd_out, "\n");
        end
        $fclose(fd_in);
        $fclose(fd_out);
    end
	adder u0(.a(a), .b(b), .c(res));

endmodule