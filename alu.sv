module alu (
	input [15:0]	A,
	input [15:0]	B,
	input [15:0]	IR,
	input [1:0]		ALUK,
	input			SR2MUX,
	input	[1:0] INC,
	output logic [1:0] inc_carry,
	output logic [15:0]	ALU
);

	logic [15:0] B_op;
	
	always_comb
	begin
		inc_carry = 2'b00;
		unique case(SR2MUX)
			1'b0 :	B_op = B;
			1'b1 :	B_op = {{11{IR[4]}}, IR[4:0]};
		endcase

		unique case(ALUK)
			//2'b00 :	ALU = A+B_op;
			2'b00 : begin
				case (INC)
				2'b00 : ALU = A+B_op;
				2'b01 : begin
					if (A + 1 >= 320)
						begin
						ALU = 0;
						inc_carry = 2'b01;
						end
					else
						ALU = A + 1;
				end
				2'b10 : begin
					if (A + 1 >= 240)
						begin
						ALU = 0;
						inc_carry = 2'b10;
					end
					else
						ALU = A + 1;
				end
				default : ALU = A+B_op;
				endcase
			end				
			2'b01 :	ALU = A&B_op;
			2'b10 :	ALU = ~A;		//NOTE: This assumes we are using the contents of A CHECK THIS
			2'b11 :	ALU = A;
		endcase
	end
	

endmodule
