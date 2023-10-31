
module part3(input logic clock, reset, ParallelLoadn, RotateRight, ASRight, 
					input logic [3:0] Data_IN, output logic [3:0] Q);
	logic C0;
	assign C0 = (Q[3] & ASRight) | (~ASRight & Q[0]);
	sub u0 (clock, reset, ParallelLoadn, RotateRight, Data_IN[0], Q[3], Q[1], Q[0]);
	sub u1 (clock, reset, ParallelLoadn, RotateRight, Data_IN[1], Q[0], Q[2], Q[1]);
	sub u2 (clock, reset, ParallelLoadn, RotateRight, Data_IN[2], Q[1], Q[3], Q[2]);
	sub u3 (clock, reset, ParallelLoadn, RotateRight, Data_IN[3], Q[2], C0, Q[3]);

endmodule

module sub (input logic clock, reset, loadn, LoadLeft, D, right, left, output logic Q);
				
	logic C0, D_in;
	assign C0 = (LoadLeft & left) | (~LoadLeft & right);
	assign D_in = (C0 & loadn) | (~loadn & D);
	
	always_ff@(posedge clock)
	begin
		if(reset) 
			Q <= 0;
		else 
			Q <= D_in;
	end
	
endmodule 