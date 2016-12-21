module  temp_mem (
					input CE, UB, LB, OE, WE,
					input [15:0] Data_CPU_In, Data_Mem_In,
					output logic [15:0] Data_CPU_Out, Data_Mem_Out);
	
	always_comb
	begin 
       Data_CPU_Out = 16'd0;
       if (WE  && ~OE)
			Data_CPU_Out = Data_Mem_In;
    end
	
	assign Data_Mem_Out = ~WE ? Data_CPU_In : 16'd0;
	
endmodule
