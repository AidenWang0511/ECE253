`timescale 1ms / 1ms // `timescale time_unit/time_precision

module hex_decoder(input logic [3:0] c, output logic [6:0] display);
	
	logic C0,C1,C2,C3,C4,C5,C6,C7,C8,C9,CA,Cb,CC,Cd,CE,CF;
	
	assign C0 = c[3] | c[2] | c[1] | c[0];
	assign C1 = c[3] | c[2] | c[1] | ~c[0];
	assign C2 = c[3] | c[2] | ~c[1] | c[0];
	assign C3	= c[3] | c[2] | ~c[1] | ~c[0];
	
	assign C4 = c[3] | ~c[2] | c[1] | c[0];
	assign C5 = c[3] | ~c[2] | c[1] | ~c[0];
	assign C6 = c[3] | ~c[2] | ~c[1] | c[0];
	assign C7 = c[3] | ~c[2] | ~c[1] | ~c[0];
	
	assign C8 = ~c[3] | c[2] | c[1] | c[0];
	assign C9 = ~c[3] | c[2] | c[1] | ~c[0];
	assign CA = ~c[3] | c[2] | ~c[1] | c[0];
	assign Cb = ~c[3] | c[2] | ~c[1] | ~c[0];
	
	assign CC = ~c[3] | ~c[2] | c[1] | c[0];
	assign Cd = ~c[3] | ~c[2] | c[1] | ~c[0];
	assign CE = ~c[3] | ~c[2] | ~c[1] | c[0];
	assign CF = ~c[3] | ~c[2] | ~c[1] | ~c[0];
	
	assign display[0] = ~(C1 & C4 & Cb & Cd);
	assign display[1] = ~(C5 & C6 & Cb & CC & CE & CF);
	assign display[2] = ~(C2 & CC & CE & CF);
	assign display[3] = ~(C1 & C4 & C7 & CA & CF);
	assign display[4] = ~(C1 & C3 & C4 & C5 & C9 & C7);
	assign display[5] = ~(C1 & C2 & C3 & C7 & Cd);
	assign display[6] = ~(C0 & C1 & C7 & CC);

endmodule
