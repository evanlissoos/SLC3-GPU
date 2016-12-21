module ben_unit(
	input logic			Clk,
	input logic			LD_CC,
	input logic			LD_BEN,
	input logic [15:0]	bus,
	input logic [15:0]	IR,
	output logic		BEN
);

		logic [2:0] NZP_IN;
		logic [2:0] NZP_OUT;
		logic 		BEN_NEW;

		register_3 NZP_reg(.LD(LD_CC),  .DATA_IN(NZP_IN),  .DATA_OUT(NZP_OUT), .Clk(Clk));
		register_1 BEN_reg(.LD(LD_BEN), .DATA_IN(BEN_NEW), .DATA_OUT(BEN),	   .Clk(Clk));

		
		always_comb
		begin
		//NZP logic
			//Negative flag is just the most significant bit
			NZP_IN[2] = bus[15];

			//Positive flag is just the inverse of the most significat bit
			//NZP_IN[0] = ~bus[15];

			//Zero flag only if bus is all zero
			if(bus == 16'h0000)
			begin
				NZP_IN[1] = 1;
				NZP_IN[0] = 0;
			end
			else
			begin
				NZP_IN[1] = 0;
				NZP_IN[0] = ~bus[15];
			end


		//BEN Logic
			BEN_NEW = (NZP_OUT[2] & IR[11]) | (NZP_OUT[1] & IR[10]) | (NZP_OUT[0] & IR[9]);
		end

endmodule