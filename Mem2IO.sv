//-------------------------------------------------------------------------
//      Mem2IO.vhd                                                       --
//      Stephen Kempf                                                    --
//                                                                       --
//      Revised 03-15-2006                                               --
//              03-22-2007                                               --
//              07-26-2013                                               --
//              03-04-2014                                               --
//                                                                       --
//      For use with ECE 385 Experiment 6                                --
//      UIUC ECE Department                                              --
//-------------------------------------------------------------------------


module  Mem2IO ( 	input Clk, Reset,
					input [19:0]  A, 
					input CE, UB, LB, OE, WE,
					input [15:0]  Switches,
					input [15:0] Data_CPU_In, Data_Mem_In,
					output logic [15:0] Data_CPU_Out, Data_Mem_Out,
					output [3:0]  HEX0, HEX1, HEX2, HEX3 );

	logic [15:0] hex_data;
   
	// You can either use the always block to assign Data_CPU using a signal
	always_comb
    begin 
        Data_CPU_Out = 16'd0;
        if (WE  && ~OE) 
			if (A[15:0] == 16'hFFFF) 
				Data_CPU_Out = Switches;
			else 
				Data_CPU_Out = Data_Mem_In;
    end

	assign Data_Mem_Out = ~WE ? Data_CPU_In : 16'd0;
   
	always_ff @ (posedge Clk or posedge Reset ) begin 
		if (Reset) 
			hex_data <= 16'd0;
		else 
			if ( ~WE & (A[15:0] == 16'hFFFF) ) 
				hex_data <= Data_CPU_In;
    end
       
	assign HEX0 = hex_data[3:0];
	assign HEX1 = hex_data[7:4];
	assign HEX2 = hex_data[11:8];
	assign HEX3 = hex_data[15:12];

endmodule
