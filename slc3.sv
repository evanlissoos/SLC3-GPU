//------------------------------------------------------------------------------
// Company: 		 UIUC ECE Dept.
// Engineer:		 Stephen Kempf
//
// Create Date:    
// Design Name:    ECE 385 Lab 6 Given Code - SLC-3 top-level (External SRAM)
// Module Name:    SLC3
//
// Comments:
//    Revised 03-22-2007
//    Spring 2007 Distribution
//    Revised 07-26-2013
//    Spring 2015 Distribution
//    Revised 09-22-2015 
//------------------------------------------------------------------------------


module slc3(
	input logic [15:0] S,
	input logic	Clk, Reset, Run, Continue,
	output logic [11:0] LED,
	output logic [6:0] HEX0, HEX1, HEX2, HEX3,
	output logic CE, UB, LB, OE, WE,
	output logic [19:0] ADDR,
	inout wire [15:0] Data, //tristate buffers need to be of type wire

	output logic [7:0] VGA_R, VGA_G, VGA_B,
	output logic VGA_CLK, VGA_SYNC_N, VGA_BLANK_N, VGA_VS, VGA_HS
);

//Declaration of push button active high signals	
logic Reset_ah, Continue_ah, Run_ah;

assign Reset_ah = ~Reset;
assign Continue_ah = ~Continue;
assign Run_ah = ~Run;

// An array of 4-bit wires to connect the hex_drivers efficiently to wherever we want
// For Lab 1, they will direclty be connected to the IR register through an always_comb circuit
// For Lab 2, they will be patched into the MEM2IO module so that Memory-mapped IO can take place
logic [3:0] hex_4[3:0]; 
HexDriver hex_drivers[3:0] (hex_4, {HEX3, HEX2, HEX1, HEX0});
// This works thanks to http://stackoverflow.com/questions/1378159/verilog-can-we-have-an-array-of-custom-modules

// Internal connections
logic LD_MAR, LD_MDR, LD_IR, LD_BEN, LD_CC, LD_REG, LD_PC, LD_LED;
logic GatePC, GateMDR, GateALU, GateMARMUX;
logic SR2MUX, ADDR1MUX, MARMUX, MIO_EN;
logic BEN, DRMUX, SR1MUX;
logic [1:0] PCMUX, ADDR2MUX, ALUK;
logic [15:0] bus;
logic [15:0] offset;
logic [15:0] MDR_In;
logic [15:0] SR1_OUT, SR2_OUT, ALU;
logic [15:0] MAR, MDR, IR, PC;
logic [15:0] Data_Mem_In, Data_Mem_Out;


// Connect MAR to ADDR, which is also connected as an input into MEM2IO
//	MEM2IO will determine what gets put onto Data_CPU (which serves as a potential
//	input into MDR)
assign ADDR = {4'b0000, MAR}; //Note, our external SRAM chip is 1Mx16, but address space is only 64Kx16
assign MIO_EN = ~OE;

// Connect everything to the data path (you have to figure out this part)
datapath d0 (.*);

memory_controller mem(.*);

ir ir(.*);

pc pc(.*);

offset_calc off_calc(.*);

alu a0(.A(SR1_OUT), .B(SR2_OUT), .*);

ben_unit ben(.*);

//regfile reg0(.SR2(IR[2:0]), .SR1(IR[11:9]), .DR(IR[11:9]), .dis(IR[8:6]), .*);
register_unit reg0(.*);

// Break the tri-state bus to the ram into input/outputs 
tristate #(.N(16)) tr0(
	.Clk(Clk), .OE(~WE), .In(Data_Mem_Out), .Out(Data_Mem_In), .Data(Data)
);

// Our SRAM and I/O controller (note, this plugs into MDR/MAR)
Mem2IO memory_subsystem(
	.*, .Reset(Reset_ah), .A(ADDR), .Switches(S),
	.HEX0(hex_4[0]), .HEX1(hex_4[1]), .HEX2(hex_4[2]), .HEX3(hex_4[3]),
	.Data_CPU_In(MDR), .Data_CPU_Out(MDR_In)
);

// State machine, you need to fill in the code here as well
ISDU state_controller(
	.*, .Reset(Reset_ah), .Run(Run_ah), .Continue(Continue_ah), .ContinueIR(Continue_ah),
	.Opcode(IR[15:12]), .IR_5(IR[5]), .IR_11(IR[11]),
	.Mem_CE(CE), .Mem_UB(UB), .Mem_LB(LB), .Mem_OE(OE), .Mem_WE(WE)
);


//LED vector for PAUSE instruction
always_ff @(posedge Clk or posedge Reset_ah)
begin
	if(Reset_ah)
		LED <= 12'h000;
	else if(LD_LED)
		LED <= IR[11:0];
	else
		LED <= LED;
end

// for drawing to screen
logic [9:0] DrawXSig;
logic [9:0] DrawYSig;
logic [7:0] pixVal;
logic [15:0] R0;
logic [15:0] R1;
logic [15:0] R2;

//assign pixVal = S[7:0];

// for modifying buffer
logic [2:0] command;
logic [7:0] command_data;
logic [1:0] command_ready;
logic [1:0] command_received;

// for auto-inc
logic [1:0] INC;
logic [1:0] inc_carry;

vga_controller vgasync_instance(.Clk(Clk), .Reset(Reset_ah), .hs(VGA_HS), .vs(VGA_VS), 
										  .pixel_clk(VGA_CLK), .blank(VGA_BLANK_N), .sync(VGA_SYNC_N),
										  .DrawX(DrawXSig), .DrawY(DrawYSig));

color_mapper map(.pixel(pixVal), .Red(VGA_R), .Green(VGA_G), .Blue(VGA_B));

// TODO: frame buffer arbiter input DrawX, DrawY, command;
//                            output current pixel to draw, pix to read, ready flag
// need to pass in R0 and R1
// note: drop LSB on x and y to reduce resolution by 4x w/o fucking w/ timings

graphics_unit fucknvidia(.Clk(Clk), .Reset_ah(Reset_ah), .pixVal(pixVal), .indata(IR),
						 .command(command), .inflag(command_ready), .outflag(command_received),
						 .R0(R0), .R1(R1), .R2(R2), .DrawXSig(DrawXSig), .DrawYSig(DrawYSig));

endmodule
