module T_FF (
	input logic Clock,
	input logic Enable,
	input logic Reset,
	output logic CounterValue
);
	always_ff @ (posedge Clock)
	begin
	if (Reset)
		CounterValue <= 0;
	else
		CounterValue <= CounterValue ^ Enable;
	end
endmodule
	

module part1 (
	input logic Clock,
	input logic Enable,
	input logic Reset,
	output logic [7:0] CounterValue
);
	logic[6:0] w;

	T_FF u0(Clock, Enable, Reset, CounterValue[0]);
	assign w[0] = CounterValue[0] & Enable;
	T_FF u1(Clock, w[0], Reset, CounterValue[1]);
	assign w[1] = CounterValue[1] & w[0];
	T_FF u2(Clock, w[1], Reset, CounterValue[2]);
	assign w[2] = CounterValue[2] & w[1];
	T_FF u3(Clock, w[2], Reset, CounterValue[3]);
	assign w[3] = CounterValue[3] & w[2];
	T_FF u4(Clock, w[3], Reset, CounterValue[4]);
	assign w[4] = CounterValue[4] & w[3];
	T_FF u5(Clock, w[4], Reset, CounterValue[5]);
	assign w[5] = CounterValue[5] & w[4];
	T_FF u6(Clock, w[5], Reset, CounterValue[6]);
	assign w[6] = CounterValue[6] & w[5];
	T_FF u7(Clock, w[6], Reset, CounterValue[7]);

endmodule

	
	
	