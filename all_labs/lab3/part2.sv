
module adder4(input logic [3:0] a, b, input logic c_in, output logic [3:0] s, c_out);
	
	FA1 u0(a[0], b[0], c_in, s[0], c_out[0]);
	FA1 u1(a[1], b[1], c_out[0], s[1], c_out[1]);
	FA1 u2(a[2], b[2], c_out[1], s[2], c_out[2]);
	FA1 u3(a[3], b[3], c_out[2], s[3], c_out[3]);
	
endmodule

module FA1(input logic a, b, cin, output logic s, cout);
	
	assign s = a^b^cin;
	assign cout = (a&b)|(b&cin)|(a&cin);
	
endmodule

module part2(input logic [3:0] A, B, input logic [1:0] Function, output logic [7:0] ALUout);
	
	logic [3:0] connection1, connection2;
	
	adder4 u4(.a(A), .b(B), .c_in(0), .s(connection1[3:0]), .c_out(connection2[3:0]));
	
	always_comb
	begin
		case (Function)
		0: ALUout = {3'b000, connection2[3], connection1};
		1: ALUout = {7'b0000000, |({A,B})};
		2: ALUout = {7'b0000000, &({A,B})};
		3: ALUout = {A, B};
		default: ALUout = 8'b00000000;
		endcase
	end
	
endmodule
