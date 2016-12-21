module dope_buffer	(input [12:0] address_work,
							 input [12:0] address_access,
							 input [7:0] write_pixel_in,
							 input [2:0] op,
							 input [2:0] offset,
							 input buffer_select_work,
							 input buffer_select_access,
							 input clk,
							 output logic [7:0] pixel_out);

	
		logic [7:0] dope_unit_out, buff_0_dope_out, buff_1_dope_out, buff_0_access_out, buff_1_access_out;
		logic we_0_dope, we_1_dope;
	
					 
		DOPE_unit dope0(.buffer_select(buffer_select_work), .op(op), .offset(offset), .write_pixel_in(write_pixel_in), .frame_buffer_0_in(buff_0_dope_out),
							 .frame_buffer_1_in(buff_1_dope_out), .out_pixel(dope_unit_out), .frame_buffer_0_we(we_0_dope), .frame_buffer_1_we(we_1_dope));

		frame_buffer_bank_320 bank0(.address_a(address_work), .address_b(address_access), .clock(clk), .data_a(dope_unit_out),
										.data_b(8'h00), .wren_a(we_0_dope), .wren_b(1'b0), .q_a(buff_0_dope_out), .q_b(buff_0_access_out));

		frame_buffer_bank_320 bank1(.address_a(address_work), .address_b(address_access), .clock(clk), .data_a(dope_unit_out),
										.data_b(8'h00), .wren_a(we_1_dope), .wren_b(1'b0), .q_a(buff_1_dope_out), .q_b(buff_1_access_out));
						
						
		always_comb
		begin
		
			if(buffer_select_access)
				pixel_out = buff_1_access_out;
			else
				pixel_out = buff_0_access_out;
				
				
		end


endmodule
