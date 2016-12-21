module DOPE_unit	(input			buffer_select,			//Dictates output, reads from other
						 input [2:0]	op,
						 input [2:0]	offset,
						 input [7:0]	frame_buffer_0_in,
						 input [7:0]	frame_buffer_1_in,
						 input [7:0]	write_pixel_in,
						 output logic [7:0]	out_pixel,
						 output logic	frame_buffer_0_we,
						 output logic	frame_buffer_1_we);

	logic [7:0] in_pixel, invert_out, out_clamp_pixel;
	logic [3:0] red_pre_clamp, green_pre_clamp, blue_pre_clamp, avg_out, red, green, blue;

	invert 			invert0		(.*, .out_pixel(invert_out));
	add_offset		add_offset0	(.*);
	black_white		black_white0(.*);


	clamp3 clampR(.in(red), .out(out_clamp_pixel[7:5]));
	clamp3 clampG(.in(green), .out(out_clamp_pixel[4:2]));
	clamp2 clampB(.in(blue), .out(out_clamp_pixel[1:0]));

	always_comb
	begin
		if(~buffer_select)
		begin
			in_pixel = frame_buffer_1_in;
			frame_buffer_0_we = 1'b1;
			frame_buffer_1_we = 1'b0;
		end

		else
		begin
			in_pixel = frame_buffer_0_in;
			frame_buffer_0_we = 1'b0;
			frame_buffer_1_we = 1'b1;
		end


		//Need to have defaults for the clamp inputs
		red = 4'h0;
		green = 4'h0;
		blue = 4'h0;

		case(op)
			3'b000	:														//OP: Write pixel
			begin											
				out_pixel = write_pixel_in;
			end
			3'b001	:	out_pixel = invert_out;						//OP: Invert
			3'b010 :														//OP: B&W
			begin
				red = avg_out;
				green = avg_out;
				blue = avg_out;
				out_pixel = out_clamp_pixel;
			end
			3'b011 	:													//OP: Add offset
			begin
				red = red_pre_clamp;
				green = green_pre_clamp;
				blue = blue_pre_clamp;
				out_pixel = out_clamp_pixel;
			end
			default		:													//OP: Do nothing
			begin											
				out_pixel = in_pixel;
				frame_buffer_0_we = 1'b0;			//*SHOULD* Turn off both write enable signals
				frame_buffer_1_we = 1'b0;
			end
			
		endcase
	end

endmodule


module add_offset	(input [7:0] in_pixel,
					 input [2:0] offset,
					 output logic [3:0] red_pre_clamp,
					 output logic [3:0] green_pre_clamp,
					 output logic [3:0] blue_pre_clamp);
					 
	adder_3_3_bit rAdd(.A(in_pixel[7:5]), 				.B(offset), .Sum(red_pre_clamp));
	adder_3_3_bit gAdd(.A(in_pixel[4:2]), 				.B(offset), .Sum(green_pre_clamp));
	adder_3_3_bit bAdd(.A({1'b0, in_pixel[1:0]}), .B(offset), .Sum(blue_pre_clamp));

endmodule


module invert	(input [7:0] in_pixel,
				 			 output logic [7:0] out_pixel);

	assign out_pixel = ~in_pixel;

endmodule


module black_white	(input [7:0]	in_pixel,
					 			output logic [3:0]	avg_out);

	logic [4:0]	summed_pixel_vals;

	//Calculating approximated average of the colors
	adder_3_3_2_bit sum(.A(in_pixel[7:5]), .B(in_pixel[4:2]), .C(in_pixel[1:0]), .Sum(summed_pixel_vals));
	assign avg_out = summed_pixel_vals[4:1];		//Bitshift

endmodule


module clamp3	(input [3:0] in,
				 			 output logic [2:0] out);

	always_comb
	begin
		if(in[3])
			out = 3'b111;
		else
			out = in[2:0];
	end

endmodule


module clamp2	(input [3:0] in,
				 			 output logic [1:0] out);

	always_comb
	begin
		if(in[3] | in[2])
			out = 2'b11;
		else
			out = in[1:0];
	end

endmodule
