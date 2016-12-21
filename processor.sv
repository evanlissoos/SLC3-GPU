module processor(input logic [15:0] S,
					  input logic Reset, Run, Continue, Clk,
					  output logic [11:0] LED,
					  output logic [6:0] HEX0, HEX1, HEX2, HEX3,
					  output logic [7:0] VGA_R, VGA_G, VGA_B,
					  output logic VGA_CLK, VGA_SYNC_N, VGA_BLANK_N, VGA_VS, VGA_HS);

logic CE, UB, LB, OE, WE;
logic [19:0] ADDR;
wire [15:0] Data;

slc3 proc(.*);
test_memory mem(.*, .A(ADDR), .I_O(Data));

endmodule