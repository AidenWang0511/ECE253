
module part3(A, B, Function, ALUout);
	parameter N = 4;
	input logic [N-1:0] A, B;
	input logic [1:0] Function;
	output logic [N+N-1:0] ALUout;
	
	always_comb
	begin
		case (Function)
		0: ALUout = A+B;
		1: ALUout = |({A,B});
		2: ALUout = &({A,B});
		3: ALUout = {A, B};
		default: ALUout = 0;
		endcase
	end
	
endmodule
