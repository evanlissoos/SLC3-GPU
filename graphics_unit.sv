module graphics_unit(
	input logic Clk, Reset_ah,
	input logic [15:0] indata,
	input logic [2:0] command,
	input logic [1:0] inflag,
	input logic [15:0] R0, R1, R2,
	input logic [9:0] DrawXSig, DrawYSig,
	output logic [7:0] pixVal,
	output logic [1:0] outflag
);

logic [15:0] write_x, write_y, access_x, access_y;
logic [2:0] op, offset;
logic [7:0] write_pixel_in;
logic buffer_select_work, buffer_select_access, clk;
logic [7:0] read_pixel_out;
logic cond;

assign clk = Clk;
assign offset = indata[2:0];
//assign write_pixel_in = indata;
assign pixVal = read_pixel_out;
assign access_x = {7'b0, DrawXSig[9:1]};
assign access_y = {7'b0, DrawYSig[9:1]};
assign write_x = R0;
assign write_y = R1;



enum logic [2:0] {start, check_op, do_op_image, do_op_pixel, done} state, next_state;
  logic [12:0] counter;
  //logic [2:0] op;
  logic count;

ATI_Dankeon_420 gpu(.*, .address_work(counter));

always_ff @ (posedge Clk or posedge Reset_ah) begin
    if (Reset_ah)
      state <= start;
    else
      state <= next_state;
end

always_ff @ (posedge Clk) begin
    if(count)
      counter <= counter + 1;
    else
      counter <= 13'b0;
end

always_comb begin
	 cond = (counter >= 13'd4799);
    op = 3'b111;  //Do nothing by default
    count = 1'b0;
    outflag = 2'b00;
    case(state)
      start : begin
        if(inflag == 2'b01)
          next_state = check_op;
        else
          next_state = start;
      end
      check_op  : begin
        //outflag = 2'b01;
        if((command[1] | command[0]) & ~command[2])
          next_state = do_op_image;
        else
          next_state = do_op_pixel;
      end
      do_op_pixel : begin
        //outflag = 2'b01;
        op = command;
        next_state = done;
      end
      do_op_image : begin
        //outflag = 2'b01;
        op = command;
        count = 1'b1;
        if(cond)
          next_state = done;
        else
          next_state = do_op_image;
      end
      done  : begin
        outflag = 2'b01;
        next_state = start;
      end
    endcase
  end
logic buffer,buf_switch;
assign buf_switch = command[2] & command[1] & ~command[0];
assign buffer_select_work = buffer;
assign buffer_select_access = ~buffer;
always_ff @ (posedge buf_switch or posedge Reset_ah) begin
    if(Reset_ah)
      buffer <= 1'b0;
    else if(buf_switch)
      buffer <= ~buffer;
end

// select pixel write value (palette, imm, or R2)
always_comb begin
	if (indata[11] == 1'b1) // imm
		write_pixel_in = indata[7:0];
	else if (indata[7] == 1'b1)
		write_pixel_in = R2[7:0];
	else
		begin
		unique case (R2[2:0])
			3'b000 : write_pixel_in = 8'b11100000;
			3'b001 : write_pixel_in = 8'b00011100;
			3'b010 : write_pixel_in = 8'b00000011;
			3'b011 : write_pixel_in = 8'b00000000;
			3'b100 : write_pixel_in = 8'b11111111;
			3'b101 : write_pixel_in = 8'b11111100;
			3'b110 : write_pixel_in = 8'b11100011;
			3'b111 : write_pixel_in = 8'b00011111;
		endcase
		end
end
endmodule
 
 