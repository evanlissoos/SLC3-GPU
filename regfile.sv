module regfile (input logic LD_REG, Clk, Reset,
					 input logic DRMUX, SR1MUX,
					 input logic [2:0] DR, SR1, SR2, dis,
					 input logic [15:0] bus,
					 output logic [15:0] SR1_OUT, SR2_OUT);
	
	logic [7:0] [15:0] registers;
	logic [2:0] dr_select, sr1_select;
	
	//IR[8:6]

	always_comb
	begin
		dr_select = DR;
		if(DRMUX)
			dr_select = 3'b111;
		
		sr1_select = SR1;
		if(SR1MUX)
			sr1_select = dis;
			
		SR1_OUT = registers[sr1_select];
		SR2_OUT = registers[SR2];
		
		if(Reset)
		begin
			SR1_OUT = 16'h0000;
			SR2_OUT = 16'h0000;
		end
	end
	
	
	always_ff @ (posedge Clk)
	begin		
		if(Reset)
		begin
			for(int i = 0; i < 8; i++)
			begin
				registers[i] <= 16'h0000;
			end

		end
		else
		begin
			if(LD_REG)
			begin
				registers[dr_select] <= bus;
			end
		end
	end
endmodule
				