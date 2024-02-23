
module part1(input logic [3:0] a, b, input logic c_in, output logic [3:0] s, c_out);
	
	FA u0(a[0], b[0], c_in, s[0], c_out[0]);
	FA u1(a[1], b[1], c_out[0], s[1], c_out[1]);
	FA u2(a[2], b[2], c_out[1], s[2], c_out[2]);
	FA u3(a[3], b[3], c_out[2], s[3], c_out[3]);
	
endmodule

module FA(input logic a, b, cin, output logic s, cout);
	
	assign s = a^b^cin;
	assign cout = (a&b)|(b&cin)|(a&cin);
	
endmodule
