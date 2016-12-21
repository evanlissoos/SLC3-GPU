//------------------------------------------------------------------------------
// Company: 		 UIUC ECE Dept.
// Engineer:		 Stephen Kempf
//
// Create Date:    17:44:03 10/08/06
// Design Name:    ECE 385 Lab 6 Given Code - Incomplete ISDU
// Module Name:    ISDU - Behavioral
//
// Comments:
//    Revised 03-22-2007
//    Spring 2007 Distribution
//    Revised 07-26-2013
//    Spring 2015 Distribution
//------------------------------------------------------------------------------

`include "SLC3_2.sv"
import SLC3_2::*;

module ISDU ( 	input	Clk, 
                        Reset,
						Run,
						Continue,
						ContinueIR,
									
				input [3:0]  Opcode, 
				input        IR_5,IR_11,BEN,
				  
				output logic 	LD_MAR,
								LD_MDR,
								LD_IR,
								LD_BEN,
								LD_CC,
								LD_REG,
								LD_PC,
									
				output logic 	GatePC,
								GateMDR,
								GateALU,
								GateMARMUX,
									
				output logic [1:0] 	PCMUX,
				output logic 		SR2MUX,
								        DRMUX,SR1MUX,

									ADDR1MUX,
				output logic [1:0] 	ADDR2MUX,
				output logic 		MARMUX,
				  
				output logic [1:0] 	ALUK,

				output logic 		LD_LED,
				  
				output logic 		Mem_CE,
									Mem_UB,
									Mem_LB,
									Mem_OE,
									Mem_WE,
				output logic [2:0] command,
				output logic [1:0] command_ready,
				input logic [1:0] command_received,
				output logic [1:0] INC,
				input logic [1:0] inc_carry
				);

    enum logic [6:0] {Halted, PauseIR1, PauseIR2, S_18, S_33_1, S_33_2, S_35, S_32, S_01, S_05, S_09, S_15, S_14, S_06, S_23, S_25_1, S_25_2, S_27, S_22, S_12, S_04, S_21, S_00, S_07, S_13_1, S_13_2, S_16_1, S_16_2, S_A, S_B, S_C, S_D, S_E, S_INC_1, S_INC_2, S_PUB}   State, Next_state;   // Internal state logic
	    
    always_ff @ (posedge Clk or posedge Reset )
    begin : Assign_Next_State
        if (Reset) 
            State <= Halted;
        else 
            State <= Next_state;
    end
   
	always_comb
    begin 
	    Next_state  = State;
	 
        unique case (State)
            Halted : 
	            if (Run) 
					Next_state = S_18;					  
            S_18 : 
                Next_state = S_33_1;
            S_33_1 : 
                Next_state = S_33_2;
            S_33_2 : 
                Next_state = S_35;
            S_35 : 
                Next_state = S_32;

            /*PauseIR1 : 
                if (~ContinueIR) 
                    Next_state = PauseIR1;
                else 
                    Next_state = PauseIR2;
            PauseIR2 : 
                if (ContinueIR) 
                    Next_state = PauseIR2;
                else 
                    Next_state = S_18;*/

            S_32 : 
				case (Opcode)
					op_ADD	:
					    Next_state = S_01;
					op_AND	:
						Next_state = S_05;
					op_NOT	:
						Next_state = S_09;
					op_BR	:
						Next_state = S_00;
					op_JMP	:
						Next_state = S_12;
					op_JSR	:
						Next_state = S_04;
					op_LDR	:
						Next_state = S_06;
					op_STR	:
						Next_state = S_07;
					op_PSE	:
						Next_state = S_13_1;
					4'b0010 :
						Next_state = S_A;
					4'b1110 :
						Next_state = S_B;
					4'b0011 :
						Next_state = S_C;
					4'b1000 :
						Next_state = S_D;
					
					default : 
					    Next_state = S_18;
				endcase


			//States that transition to 18
            S_01	: 
				Next_state = S_18;
			S_05	: 
				Next_state = S_18;
			S_09	: 
				Next_state = S_18;
			S_14	: 
				Next_state = S_18;
			S_27	: 
				Next_state = S_18;
			S_16_2	: 
				Next_state = S_18;
			S_21 	: 
				Next_state = S_18;
			S_12 	: 
				Next_state = S_18;
			S_22 	: 
				Next_state = S_18;


			S_06	:
				Next_state = S_25_1;
			S_25_1	:
				Next_state = S_25_2;
			S_25_2	:
				Next_state = S_27;
			S_07	:
				Next_state = S_23;
			S_23 	:
				Next_state = S_16_1;
			S_16_1	:
				Next_state = S_16_2;
			S_04	:
				Next_state = S_21;
			S_00 	:
				if(BEN)
					Next_state = S_22;
				else
					Next_state = S_18;

			S_13_1 :
				if(Continue)
					Next_state = S_13_2;
				else
					Next_state = S_13_1;

			S_13_2 :
				if(~Continue)
					Next_state = S_18;
				else
					Next_state = S_13_2;
			S_A :
				if(command_received == 2'b01)
					Next_state = S_INC_1;
				else
					Next_state = S_A;
			S_B :
				if(command_received == 2'b01)
					Next_state = S_18;
				else
					Next_state = S_B;
			S_C :
				if(command_received == 2'b01)
					Next_state = S_18;
				else
					Next_state = S_C;
			S_D :
				if(command_received == 2'b01)
					Next_state = S_18;
				else
					Next_state = S_D;

			S_E :
				if(command_received == 2'b10)
					Next_state = S_18;
				else
					Next_state = S_E;
			S_INC_1 :
				if(inc_carry == 2'b01)
					Next_state = S_INC_2;
				else
					Next_state = S_18;
			S_INC_2 :
				if(inc_carry == 2'b10)
					Next_state = S_PUB;
				else
					Next_state = S_18;
			S_PUB :
				if(command_received == 2'b01)
					Next_state = S_18;
				else
					Next_state = S_PUB;		
			
			default : ;

	     endcase
    end
   
    always_comb
    begin 
        //default controls signal values; within a process, these can be
        //overridden further down (in the case statement, in this case)
	    LD_MAR = 1'b0;
	    LD_MDR = 1'b0;
	    LD_IR = 1'b0;
	    LD_BEN = 1'b0;
	    LD_CC = 1'b0;
	    LD_REG = 1'b0;
	    LD_PC = 1'b0;
		 
	    GatePC = 1'b0;
	    GateMDR = 1'b0;
	    GateALU = 1'b0;
	    GateMARMUX = 1'b0;
		 
		 ALUK = 2'b00;
		 
	    PCMUX = 2'b00;
	    DRMUX = 1'b0;
	    SR1MUX = 1'b0;
	    SR2MUX = 1'b0;
	    ADDR1MUX = 1'b0;
	    ADDR2MUX = 2'b00;
	    MARMUX = 1'b0;

	    LD_LED = 1'b0;
		 
	    Mem_OE = 1'b1;
	    Mem_WE = 1'b1;
		 
		 command = 3'b111;
		 command_ready = 2'b00;
		 
		 INC = 2'b00;
		 
	    case (State)
			Halted: ;
			S_18 : 
				begin 
					GatePC = 1'b1;
					LD_MAR = 1'b1;
					PCMUX = 2'b00;
					LD_PC = 1'b1;
				end
			S_33_1 : 
				Mem_OE = 1'b0;
			S_33_2 : 
				begin 
					Mem_OE = 1'b0;
					LD_MDR = 1'b1;
                end
            S_35 : 
                begin 
					GateMDR = 1'b1;
					LD_IR = 1'b1;
                end
            //PauseIR1: ;
            //PauseIR2: ;
            S_32 : 
                LD_BEN = 1'b1;
            S_01 : 
                begin 
					SR1MUX = 1'b1;
					SR2MUX = IR_5;
					ALUK = 2'b00;
					GateALU = 1'b1;
					LD_REG = 1'b1;
					LD_CC = 1'b1;
                end

            S_05 :
            	begin
					SR1MUX = 1'b1;
            	SR2MUX = IR_5;
					ALUK = 2'b01;
					GateALU = 1'b1;
					LD_REG = 1'b1;
					LD_CC = 1'b1;
            	end

           	S_09 :
           		begin
					SR1MUX = 1'b1;
            		SR2MUX = IR_5;
					ALUK = 2'b10;
					GateALU = 1'b1;
					LD_REG = 1'b1;
            	end

            S_06 :
            	begin
            		//MAR <- BR + Off6
            		LD_MAR = 1'b1;
            		ADDR1MUX = 1'b1;
            		ADDR2MUX = 2'b01;
            		GateMARMUX = 1'b1;
            		SR1MUX = 1'b1;
						LD_CC = 1'b1;
            	end

            S_25_1 :
            	begin
            		//MDR <- M[MAR]
            		Mem_OE = 1'b0;
            	end

            S_25_2 :
            	begin
            		Mem_OE = 1'b0;
					LD_MDR = 1'b1;
				end

			S_27 :
				begin
					//DR <- MDR
					LD_REG = 1'b1;
					GateMDR = 1'b1;
					DRMUX = 1'b0;
					LD_CC = 1'b1;
				end

			S_07 :
				begin
					//MAR <- BR + Off6
					LD_MAR = 1'b1;
            		ADDR1MUX = 1'b1;
            		ADDR2MUX = 2'b01;
            		GateMARMUX = 1'b1;
            		SR1MUX = 1'b1;
				end

			S_23 :
				begin
					//MDR <- SR
					LD_MDR = 1'b1;
					GateALU = 1'b1;
					SR1MUX = 1'b0;
					ALUK = 2'b11;
				end

			////////////////////////////DO DIS//////////////////////////////////////////////////
			//STR
			S_16_1 :
				begin
					//M[MAR] <- MDR
					Mem_WE = 1'b0;
				end

			S_16_2 :
				begin
					Mem_WE = 1'b0;
				end

			//PSE
			S_13_1 : 
				LD_LED = 1'b1;
			S_13_2 : ;

			////////////////////////////END DO DIS//////////////////////////////////////////////

			S_04 :
				begin
					//R7 <- PC
					GatePC = 1'b1;
					LD_REG = 1'b1;
					DRMUX = 1'b1;
				end

			S_21 :
				begin
					//PC <- PC + off11
					ADDR2MUX = 2'b11;
					ADDR1MUX = 1'b0;
					PCMUX = 2'b10;
					LD_PC = 1'b1;
				end

			S_12 :
				begin
					//PC <- BR
					LD_PC = 1'b1;
					GateALU = 1'b1;
					PCMUX = 2'b01;
					ALUK = 2'b11;
					SR1MUX = 1'b1;
				end

			S_22 :
				begin
					//PC <- PC + Off9
					LD_PC = 1'b1;
					PCMUX = 2'b10;
					ADDR2MUX = 2'b10;
					ADDR1MUX = 1'b0;
				end
			S_A : // wpix
				begin
					command = 3'b000;
					command_ready = 2'b01;
				end
					
			S_B :
				begin
					if (IR_11 == 1'b0 && IR_5 == 0) // grsc
						command = 3'b010;
					else if (IR_11 == 1'b1) // invert
						command = 3'b001;
					else // publish
						command = 3'b110;
					command_ready = 2'b01;
				end
			S_C : // brtn
				begin
					command = 3'b011;
					command_ready = 2'b01;
				end
			S_D : // range
				begin
					command = 3'b100;
					command_ready = 2'b01;
				end
			S_E : // wait for finish
				begin
					//command = 3'b000;
					command_ready = 2'b10;
				end
			S_INC_1 :
				begin
					SR1MUX = 1'b1;
					SR2MUX = 0;
					ALUK = 2'b00;
					GateALU = 1'b1;
					LD_REG = 1'b1;
					INC = 2'b01;
				end
			S_INC_2 :
				begin
					SR1MUX = 1'b1;
					SR2MUX = 0;
					ALUK = 2'b00;
					GateALU = 1'b1;
					LD_REG = 1'b1;
					INC = 2'b10;
				end
			S_PUB :
				begin
					command = 3'b110;
					command_ready = 2'b01;
				end
			
         default : ;
           endcase
       end 

	assign Mem_CE = 1'b0;
	assign Mem_UB = 1'b0;
	assign Mem_LB = 1'b0;
	
endmodule
