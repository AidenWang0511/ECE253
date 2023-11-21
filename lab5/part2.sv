module RateDivider
	#(parameter CLOCK_FREQUENCY = 500) (
	input logic ClockIn,
	input logic Reset,
	input logic [1:0] Speed,
	output logic Enable
);
	logic [$clog2(CLOCK_FREQUENCY*4) + 1: 0] N, count;
	
	always_comb
	begin
		case (Speed)
			0: N <= 0;		
			1: N <= CLOCK_FREQUENCY - 1;
			2: N <= CLOCK_FREQUENCY*2 - 1;
			3: N <= CLOCK_FREQUENCY*4 - 1;
		endcase
	end
	
	always_ff @ (posedge ClockIn)
	begin
		if (Reset | ~count)
			count <= N;
		if (count)
			count <= count - 1;
	end
	assign Enable = (count == 0)? 1:0;
endmodule

module DisplayCounter (
	input logic Clock,
	input logic Reset,
	input logic EnableDC,
	output logic [3:0] CounterValue
);

	always_ff @ (posedge Clock)
	begin
		if (Reset)
			CounterValue <= 0;
		else if (EnableDC)
			CounterValue <= CounterValue + 1;
	end
	
endmodule
	
module part2
	#(parameter CLOCK_FREQUENCY = 500)(
	input logic ClockIn,
	input logic Reset,
	input logic [1:0] Speed,
	output logic [3:0] CounterValue
);
	logic EN;
	RateDivider u0 (ClockIn, Reset, Speed, EN);
	DisplayCounter u1(ClockIn, Reset, EN, CounterValue);
	
endmodule