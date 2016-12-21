module ATI_Dankeon_420(input [15:0] write_x,			//Creds to Ben for the dankest module name verilog has ever seen
							  input [15:0] write_y,
							  input [15:0] access_x,
							  input [15:0] access_y,
							  input [12:0] address_work,
							  input [2:0] op,
							  input [2:0] offset,
							  input [7:0] write_pixel_in,
							  input buffer_select_work,
							  input buffer_select_access,
							  input clk,
							  output logic [7:0] read_pixel_out);

	logic [16:0] address_write;
	logic [16:0] address_access;
	logic [12:0] address_work_out;
	logic [15:0][7:0] pixel_access;
	logic [15:0][2:0] op_out;
	//logic buffer_select_work_out;

	//320x240
	
	always_comb
	begin

		address_write = write_x + (write_y * 240);		//@TODO: Can make this multiplication into a lookup table
		address_access = access_x + (access_y * 240);

		if(((~op[0]) & (~op[1]) & (~op[2])))		//If write OP, we need to only write to the correct unit
		begin
			op_out[0] = 3'b111;	op_out[1] = 3'b111;	op_out[2] = 3'b111;	op_out[3] = 3'b111;
			op_out[4] = 3'b111;	op_out[5] = 3'b111;	op_out[6] = 3'b111;	op_out[7] = 3'b111;
			op_out[8] = 3'b111;	op_out[9] = 3'b111;	op_out[10] = 3'b111;	op_out[11] = 3'b111;
			op_out[12] = 3'b111;	op_out[13] = 3'b111;	op_out[14] = 3'b111;	op_out[15] = 3'b111;

			op_out[address_write[3:0]] = 3'b000;

			address_work_out = address_write[16:4];
			//buffer_select_work_out = buffer_select_access;
		end
		else
		begin
			op_out[0] = op;	op_out[1] = op;	op_out[2] = op;	op_out[3] = op;
			op_out[4] = op;	op_out[5] = op;	op_out[6] = op;	op_out[7] = op;
			op_out[8] = op;	op_out[9] = op;	op_out[10] = op;	op_out[11] = op;
			op_out[12] = op;	op_out[13] = op;	op_out[14] = op;	op_out[15] = op;

			address_work_out = address_work;
			//buffer_select_work_out = buffer_select_work;
		end

		read_pixel_out = pixel_access[address_access[3:0]];

	end

	//Use least sig 4 bits to address the array of DOPE modules
	dope_buffer dank[15:0](.clk(clk), .address_work(address_work_out), .address_access(address_access[16:4]), .write_pixel_in(write_pixel_in),
								  .op(op_out), .offset(offset), .buffer_select_work(buffer_select_work), .buffer_select_access(buffer_select_access),
								  .pixel_out(pixel_access));

endmodule
