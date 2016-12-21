//-------------------------------------------------------------------------
//    Color_Mapper.sv                                                    --
//    Stephen Kempf                                                      --
//    3-1-06                                                             --
//                                                                       --
//    Modified by David Kesler  07-16-2008                               --
//    Translated by Joe Meng    07-07-2013                               --
//                                                                       --
//    Fall 2014 Distribution                                             --
//                                                                       --
//    For use with ECE 385 Lab 7                                         --
//    University of Illinois ECE Department                              --
//-------------------------------------------------------------------------


module  color_mapper ( input			[7:0] pixel,
                       output logic [7:0] Red, Green, Blue );
    
	logic [2:0] raw_red, raw_green, raw_blue;
	assign raw_red   = pixel[7:5];
	assign raw_green = pixel[4:2];
	assign raw_blue  = pixel[1:0];
	 
	always_comb
	begin
		unique case (raw_red)
			3'd0: Red = 8'd0;
			3'd1: Red = 8'd36;
			3'd2: Red = 8'd73;
			3'd3: Red = 8'd109;
			3'd4: Red = 8'd146;
			3'd5: Red = 8'd182;
			3'd6: Red = 8'd220;
			3'd7: Red = 8'd255;
		endcase
		
		unique case (raw_green)
			3'd0: Green = 8'd0;
			3'd1: Green = 8'd36;
			3'd2: Green = 8'd73;
			3'd3: Green = 8'd109;
			3'd4: Green = 8'd146;
			3'd5: Green = 8'd182;
			3'd6: Green = 8'd220;
			3'd7: Green = 8'd255;
		endcase
		
		unique case (raw_blue)
			2'd0: Blue = 8'd0;
			2'd1: Blue = 8'd85;
			2'd2: Blue = 8'd170;
			2'd3: Blue = 8'd255;
		endcase
	end
		
	 
    
endmodule
