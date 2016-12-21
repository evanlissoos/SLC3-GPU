module memory_controller(
	input logic			Clk,
	input logic			LD_MAR,
	input logic			LD_MDR,
	input logic			MIO_EN,
	input logic [15:0]	bus,
	input logic [15:0]	MDR_In,
	output logic [15:0]	MDR,
	output logic [15:0]	MAR
);

		logic [15:0] mio_en_mux_out;

		//MIO.EN mux implementation (must be in comb)
		always_comb
		begin
			if(MIO_EN)
				mio_en_mux_out = MDR_In;
			else
				mio_en_mux_out = bus;
		end

		always_ff @(posedge Clk)
		begin
			
			//MAR with LD_MAR
			if(LD_MAR)
				MAR <= bus;
			else
				MAR <= MAR;


			//MDR with MIO.EN mux output
			if(LD_MDR)
				MDR <= mio_en_mux_out;
			else
				MDR <= MDR;

		end

endmodule