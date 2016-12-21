module adder_3_3_bit (input   logic[2:0]     A,
                      input   logic[2:0]     B,
                      output  logic[3:0]     Sum);     //Sum is an extra bit wide and contains the carry out bit

		logic	[1:0] carry_int;

		full_adder   bit0(.A(A[0]), .B(B[0]), .Cin(1'b0), .S(Sum[0]), .Cout(carry_int[0]));
    carry_select bit1(.A(A[1]), .B(B[1]), .CI(carry_int[0]), .Sum(Sum[1]), .CO(carry_int[1]));
    carry_select bit2(.A(A[2]), .B(B[2]), .CI(carry_int[1]), .Sum(Sum[2]), .CO(Sum[3]));

endmodule


module adder_4_4_bit (input   logic[3:0]     A,
                      input   logic[3:0]     B,
                      output  logic[4:0]     Sum);     //Sum is an extra bit wide and contains the carry out bit

		logic	[2:0] carry_int;

		full_adder   bit0(.A(A[0]), .B(B[0]), .Cin(1'b0), .S(Sum[0]), .Cout(carry_int[0]));
    carry_select bit1(.A(A[1]), .B(B[1]), .CI(carry_int[0]), .Sum(Sum[1]), .CO(carry_int[1]));
    carry_select bit2(.A(A[2]), .B(B[2]), .CI(carry_int[1]), .Sum(Sum[2]), .CO(carry_int[2]));
    carry_select bit3(.A(A[3]), .B(B[3]), .CI(carry_int[2]), .Sum(Sum[3]), .CO(Sum[4]));

endmodule


module adder_3_3_2_bit (input   logic[2:0]     A,
                        input   logic[2:0]     B,
                        input   logic[1:0]     C,
                        output  logic[4:0]     Sum);     //Sum is an extra 2 bits wide and contains the carry out bit

    logic[3:0] sum_3_3;

		adder_3_3_bit  A_B(.A(A), .B(B), .Sum(sum_3_3));

    adder_4_4_bit  AB_C(.A(sum_3_3), .B({2'b00, C}), .Sum(Sum));

endmodule


module carry_select (input   logic   A,
                      input   logic   B,
                      input   logic	  CI,
                      output  logic   Sum,
                      output  logic   CO);

  	logic Cout_0, Cout_1, Sum_0, Sum_1;

  	//Adder for if Cin is 0
  	full_adder	adder0_0(.A(A), .B(B), .Cin(1'b0), .S(Sum_0), .Cout(Cout_0));

  	//Adder for if Cin is 1
  	full_adder	adder0_1(.A(A), .B(B), .Cin(1'b1), .S(Sum_1), .Cout(Cout_1));

  	always_comb
  	begin
  		unique case(CI)
  			1'b1:	begin
  				CO = Cout_1;
  				Sum = Sum_1;
  			end

  			1'b0: begin
  				CO = Cout_0;
  				Sum = Sum_0;
  			end
			
			default: begin
				CO = Cout_0;
  				Sum = Sum_0;
			end
  		endcase
  	end

endmodule


module full_adder		(input	logic   A,
										 input	logic   B,
										 input	logic   Cin,
										 output	logic   S,
										 output	logic   Cout);

		assign S = A^B^Cin;
		assign Cout = (A&B)|(B&Cin)|(A&Cin);

endmodule
