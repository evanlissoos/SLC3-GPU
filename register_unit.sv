module register_unit (
	input logic [15:0]	bus,
	input logic [15:0]	IR,
	//input logic [2:0]	SR2,
	input logic SR1MUX,
	input logic DRMUX,
	input logic LD_REG,
	input logic Clk,
	output logic [15:0] SR1_OUT,
	output logic [15:0] SR2_OUT,
	output logic [15:0] R0,
	output logic [15:0] R1,
	output logic [15:0] R2,
	input logic [1:0] INC
);
		logic [7:0][15:0] reg_data;
		logic [7:0] reg_ld;
		logic [2:0] DR_SELECT;
		logic [2:0] SR1_SELECT;
		logic [2:0] SR2_SELECT;
		assign SR2_SELECT = IR[2:0];
		
		logic [2:0] dr, sr1;
		
		//Array of the 8 registers
		register_16 registers[7:0] (.LD(reg_ld), .Clk(Clk), .DATA_IN(bus), .DATA_OUT(reg_data));
		always_comb
			begin
			R0 = reg_data[0];
			R1 = reg_data[1];
			R2 = reg_data[2];
			//DRMUX
			unique case(DRMUX)
				1'b0 :	DR_SELECT = IR[11:9];
				1'b1 :	DR_SELECT = 111;
			endcase
			
			if (INC == 2'b00 || INC == 2'b11)
				dr = DR_SELECT;
			else if (INC == 2'b01)
				dr = 3'b000;
			else
				dr = 3'b001;
			
			//SR1MUX
			unique case(SR1MUX)
				1'b0 :	SR1_SELECT = IR[11:9];
				1'b1 :	SR1_SELECT = IR[8:6];
			endcase
			
			if (INC == 2'b00 || INC == 2'b11)
				sr1 = SR1_SELECT;
			else if (INC == 2'b01)
				sr1 = 3'b000;
			else
				sr1 = 3'b001;
			
			//SR1_OUT
			unique case(sr1)
				3'b000 :	SR1_OUT = reg_data[0];
				3'b001 :	SR1_OUT = reg_data[1];
				3'b010 :	SR1_OUT = reg_data[2];
				3'b011 :	SR1_OUT = reg_data[3];
				3'b100 :	SR1_OUT = reg_data[4];
				3'b101 :	SR1_OUT = reg_data[5];
				3'b110 :	SR1_OUT = reg_data[6];
				3'b111 :	SR1_OUT = reg_data[7];
			endcase
			//SR2_OUT
			unique case(SR2_SELECT)
				3'b000 :	SR2_OUT = reg_data[0];
				3'b001 :	SR2_OUT = reg_data[1];
				3'b010 :	SR2_OUT = reg_data[2];
				3'b011 :	SR2_OUT = reg_data[3];
				3'b100 :	SR2_OUT = reg_data[4];
				3'b101 :	SR2_OUT = reg_data[5];
				3'b110 :	SR2_OUT = reg_data[6];
				3'b111 :	SR2_OUT = reg_data[7];
			endcase
			//DR
			reg_ld = 8'h00;
			if(LD_REG)
			begin
				unique case(dr)
				3'b000 :	reg_ld[0] = 1;
				3'b001 :	reg_ld[1] = 1;
				3'b010 :	reg_ld[2] = 1;
				3'b011 :	reg_ld[3] = 1;
				3'b100 :	reg_ld[4] = 1;
				3'b101 :	reg_ld[5] = 1;
				3'b110 :	reg_ld[6] = 1;
				3'b111 :	reg_ld[7] = 1;
				endcase
			end
		end
		
endmodule
