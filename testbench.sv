module testbench();

timeunit 10ns;
timeprecision 1ns;

logic Clk = 0;
logic [15:0] S;
logic Reset, Run, Continue;
logic [11:0] LED;
logic [6:0] HEX0, HEX1, HEX2, HEX3;
logic [7:0] VGA_R, VGA_G, VGA_B;
logic VGA_CLK, VGA_SYNC_N, VGA_BLANK_N, VGA_VS, VGA_HS;
processor lc3(.*);

always begin : CLOCK_GENERATION
	#1 Clk = ~Clk;
end

initial begin : CLOCK_INITIALIZATION
	Clk = 0;
end

initial begin : TEST_VECTORS
Reset = 0;
Run = 1;
Continue = 1;
//S = 16'b00100101;
S = 16'h0000;
#3
Reset = 1;
#1
Run = 0;
#3 
Run = 1;


end

endmodule
