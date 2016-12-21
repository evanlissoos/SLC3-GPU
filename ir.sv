module ir(
	input logic			Clk,
	input logic			LD_IR,
	input logic [15:0]	bus,
	output logic [15:0]	IR
);

	//Just a 16 bit register with load enable from the bus to be used as IR
	always_ff @(posedge Clk)
	begin
		if(LD_IR)
			IR <= bus;
		else
			IR <= IR;
	end

endmodule