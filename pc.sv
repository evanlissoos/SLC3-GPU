module pc (input logic [15:0] bus, offset,
			input logic [1:0] PCMUX,
			input logic LD_PC, Clk, Reset_ah,
			output logic [15:0] PC);
	
	logic [15:0] mux_val;
	
	always_ff @ (posedge Clk or posedge Reset_ah)
	begin
		if(Reset_ah)
			PC <= 16'h0000;
		else if(LD_PC)
			PC <= mux_val;
		else
			PC <= PC;
	end
	
	always_comb
	begin
		case(PCMUX)
			2'b00: mux_val = PC + 1;
			2'b01: mux_val = bus;
			2'b10: mux_val = offset;
			default: mux_val = PC;
		endcase
	end
	
endmodule