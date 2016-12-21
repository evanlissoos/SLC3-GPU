module register_16(
	input logic			Clk,
	input logic			LD,
	input logic [15:0]	DATA_IN,
	output logic [15:0]	DATA_OUT
);

	always_ff @(posedge Clk)
	begin
		if(LD)
			DATA_OUT <= DATA_IN;
		else
			DATA_OUT <= DATA_OUT;
	end

endmodule