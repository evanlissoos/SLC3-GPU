module register_1(
	input logic			Clk,
	input logic			LD,
	input logic 		DATA_IN,
	output logic 		DATA_OUT
);

	always_ff @(posedge Clk)
	begin
		if(LD)
			DATA_OUT <= DATA_IN;
		else
			DATA_OUT <= DATA_OUT;
	end

endmodule