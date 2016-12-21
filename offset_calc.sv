module offset_calc(
	input logic			ADDR1MUX,
	input logic [1:0]	ADDR2MUX,
	input logic [15:0]	IR,
	input logic [15:0]	PC,
	input logic [15:0]	SR1_OUT,
	output logic [15:0] offset
);

		logic [15:0] ADDR2MUX_out;
		logic [15:0] ADDR1MUX_out;

		always_comb
		begin
			//ADDR2MUX implementation, concatonations implement sign extensions
			unique case (ADDR2MUX)
				2'b00 :	ADDR2MUX_out = 16'h0000;
				2'b01 :	ADDR2MUX_out = {{10{IR[5]}},IR[5:0]};
				2'b10 :	ADDR2MUX_out = {{7{IR[8]}},IR[8:0]};
				2'b11 :	ADDR2MUX_out = {{5{IR[10]}},IR[10:0]};
			endcase

			//ADDR1MUX implementation
			unique case (ADDR1MUX)
				1'b0 :	ADDR1MUX_out = PC;
				1'b1 :	ADDR1MUX_out = SR1_OUT;
			endcase

			//Adds the output of the two muxes together to get a new possible PC value
			offset = ADDR1MUX_out + ADDR2MUX_out;
		end

endmodule