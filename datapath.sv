module datapath(
	input logic GateMARMUX,
	input logic GatePC,
	input logic GateMDR,
	input logic GateALU,
	input logic [15:0] PC,
	input logic [15:0] MDR,
	input logic [15:0] offset,
	input logic [15:0] ALU,
	output logic [15:0] bus
);

	always_comb
	begin
		bus = 16'bxxxxxxxxxxxxxxxx;
		
		if(GateMARMUX)
			bus = offset;
		else if(GatePC)
			bus = PC;
		else if(GateMDR)
			bus = MDR;
		else if(GateALU)
			bus = ALU;
	end


endmodule