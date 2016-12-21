//-------------------------------------------------------------------------
//      test_memory.vhd                                                  --
//      Stephen Kempf                                                    --
//      Summer 2005                                                      --
//                                                                       --
//      Revised 3-15-2006                                                --
//              3-22-2007                                                --
//              7-26-2013                                                --
//                                                                       --
//      For use with ECE 385 Experment 6                                 --
//      UIUC ECE Department                                              --
//-------------------------------------------------------------------------

// This memory has similar behavior to the SRAM IC on the DE2 board.  This
// file should be used for simulations only.  In simulation, this memory is
// guaranteed to work at least as well as the actual memory (that is, the
// actual memory may require more careful treatment than this test memory).

// To use, you should create a seperate top-level entity for simulation
// that connects this memory module to your computer.  You can create this
// extra entity either in the same project (temporarily setting it to be the
// top module) or in a new one, and create a new vector waveform file for it.

`include "SLC3_2.sv"
import SLC3_2::*;

module test_memory ( input 			Clk,
					 input          Reset, 
                     inout  [15:0]  I_O,
                     input  [19:0]  A,
                     input          CE,
                                    UB,
                                    LB,
                                    OE,
                                    WE );
												
   parameter size = 256; // expand memory as needed (current is 64 words)
	 
   logic [15:0] mem_array [size-1:0];
   logic [15:0] mem_out;
   logic [15:0] I_O_wire;
	 
   assign mem_out = mem_array[A[7:0]];  //ATTENTION: Size here must correspond to size of
              // memory vector above.  Current size is 64, so the slice must be 6 bits.  If size were 1024,
              // slice would have to be 10 bits.  (There are three more places below where values must stay
              // consistent as well.)
	 
   always_comb
   begin
      I_O_wire = 16'bZZZZZZZZZZZZZZZZ;

      if (~CE && ~OE && WE) begin
         if (~UB)
            I_O_wire[15:8] = mem_out[15:8];
				
         if (~LB)
            I_O_wire[7:0] = mem_out[7:0];
		end
   end
	  
   always_ff @ (posedge Clk or posedge Reset)
   begin
		if(Reset)   // Insert initial memory contents here
		begin
			//INIT
		// this program prints the value of palette[switches] to the screen
		mem_array[0 ] <= opCLR(R0);
		mem_array[1 ] <= opCLR(R1);
		mem_array[2 ] <= opCLR(R2);
		mem_array[3 ] <= opCLR(R3);
		mem_array[4 ] <= opCLR(R5);
		mem_array[5 ] <= opCLR(R6);
		mem_array[6 ] <= opLDR(R6, R6, 27);
		mem_array[7 ] <= opLDR(R4, R3, inSW);
		mem_array[8 ] <= opBR(np, 7);
		mem_array[9 ] <= 16'h2000;
		mem_array[10] <= opINC(R5);
		mem_array[11] <= opADD(R4, R5, R6);
		mem_array[12] <= opBR(n, 2);
		mem_array[13] <= opINC(R2);
		mem_array[14] <= opCLR(R5);
		mem_array[15] <= opBR(nzp, -9);
		
		mem_array[16] <=	opPUB();
		mem_array[17] <=	opPSE(12'h001);
		mem_array[18] <=  opGRSC();
		mem_array[19] <=	opPUB();
		mem_array[20] <=	opPSE(12'h002);
		mem_array[21] <=  opINVR();
		mem_array[22] <=	opPUB();
		mem_array[23] <=	opPSE(12'h003);
		mem_array[24] <=	opBRTN(2);
		mem_array[25] <=	opPUB();
		mem_array[26] <=	opPSE(12'h004);
		mem_array[27] <=  16'hFFD8;
		
		
		/*
		mem_array[0 ] <=	opCLR(R2);
		mem_array[1 ] <=	opCLR(R5);
		mem_array[2 ] <=	opADDi(R2, R2, 14);
		mem_array[3 ] <=	opADDi(R2, R2, 13);
		mem_array[4 ] <=	opLDR(R0, R2, 0);
		mem_array[5 ] <=	opLDR(R1, R2, 1);
		mem_array[6 ] <=	opWPIX(green);
		mem_array[7 ] <=  opLDR(R3, R2, 2);   //R3, R4 contain masks
		mem_array[8 ] <=  opLDR(R4, R2, 3);
		//GET SWITCH VALS AND MOD WPIX OP
		mem_array[9 ] <=  opLDR(R6, R2, -4);  //R6 contains instruction to modify
		mem_array[10] <=  opLDR(R7, R5, inSW);
		mem_array[11] <=  opAND(R6, R6, R4);
		mem_array[12] <=  opAND(R7, R7, R3);
		mem_array[13] <=  opADD(R7, R7, R6);
		mem_array[14] <=  opSTR(R7, R2, -4);
		mem_array[15] <=  opSTR(R6, R5, outHEX);
		//2D LOOP THROUGH PIXELS
		mem_array[16] <=	opDEC(R0);
		mem_array[17] <=	opBR(zp, 5);
		mem_array[18] <=	opLDR(R0, R2, 0);
		mem_array[19] <=	opDEC(R1);
		mem_array[20] <=	opBR(zp, 2);
		mem_array[21] <=	opPUB();
		mem_array[22] <=  opLDR(R1, R2, 1);
		//WRITE OP
		mem_array[23] <=	opWPIX(green);
		mem_array[24] <=	opBR(nzp, -16);
		//DATA
		mem_array[27] <=	16'd319;
		mem_array[28] <=	16'd239;
		mem_array[29] <=  16'hFF00;
		mem_array[30] <=  16'h00FF;
		*/

			
			for (integer i = 156; i <= size - 1; i = i + 1)		// Assign the rest of the memory to 0
			begin
				mem_array[i] <= 16'h0;
			end
		end
		else if (~CE && ~WE && A[15:8]==8'b00000000)
		begin
          if(~UB)
			    mem_array[A[7:0]][15:8] <= I_O[15:8];   // A(15 downto X+1): X must
																	  // be the same as above
		    if(~LB)
			    mem_array[A[7:0]][7:0] <= I_O[7:0];     // A(X downto 0): X
		end                                            // must be the same as above

   end
	  
   assign I_O = I_O_wire;
	  
endmodule