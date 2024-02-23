
module part2(input logic Clock, Reset_b, input logic [3:0] Data, input logic [1:0] Function, output logic [7:0] ALUout);
	
	logic [7:0] reg8;
	logic [3:0] B;
	assign B = ALUout[3:0];
	
	always_comb
	begin
		case (Function)
		0: reg8 = {4'b0, Data} + {4'b0, B};
		1: reg8 = {4'b0, Data} * {4'b0, B};
		2: reg8 = {4'b0, B} << Data;
		3: reg8 = ALUout;
		default: reg8 = 8'b0;
		endcase
	end	
	
	always_ff@(posedge Clock)
	begin
		if(Reset_b)
			ALUout <= 8'b0;
		else
			ALUout <= reg8;
	end
	
endmodule