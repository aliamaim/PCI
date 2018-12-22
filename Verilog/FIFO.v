//This module is used in the ARBITER in the FIRST IN FIRST OUT mode, it's inputs are from the encoder (related to it) and it's output is a decoder
//It's purpose is to stack requests from the devices and give grants according to who requested first.

module FIFO(out, in, reset, priority_enable, frame, clk);
	output reg[2:0] out;
	input wire[2:0] in;
	input reset, enable, frame, clk;
	input priority_enable; //Enable this device if only the  priority protocol is disabled (logical zero)


//Read from the buffer and put on encoder when Frame = 1 & negedge clk

//Write in the buffer from the decoder when there is a request change and posedge clk
	reg[2:0] buffer[0:7];
	reg[2:0] readPtr;
	reg[2:0] writePtr;
	reg frame_assertion_flag;




	always@(negedge reset)
	begin
		readPtr <= 3'd0;
		writePtr <= 3'd0;
		frame_assertion_flag <= 1'b0;
		buffer[0] <= 3'bzzz;
		buffer[1] <= 3'bzzz;
		buffer[2] <= 3'bzzz;
		buffer[3] <= 3'bzzz;
		buffer[4] <= 3'bzzz;
		buffer[5] <= 3'bzzz;
		buffer[6] <= 3'bzzz;
		buffer[7] <= 3'bzzz;
	end
	always@(negedge clk)
	begin
		if(priority_enable == 1'b0)
		begin
			if(frame_assertion_flag == 1)
			begin
				buffer[readPtr] <= 3'bzzz;
				readPtr <= readPtr + 1;
				frame_assertion_flag <= 0;
			end	
			out = buffer[readPtr];
		end
	end

	always@(posedge clk)
	begin
		if(priority_enable == 1'b0)
		begin
			if(!(in === buffer[writePtr]))
			begin
				if(!(in === 3'bzzz))
				begin
				buffer[writePtr] = in;
				writePtr = writePtr + 1;
				end
			end
			if(frame == 0)
				frame_assertion_flag = 1;	
		end
	end
endmodule



module tb_fifo();
reg[2:0] in;
reg reset, priority_enable, clk, frame;
wire[2:0] out;
FIFO fifo1(out, in, reset, priority_enable, frame, clk);


initial
begin
	$monitor($time,, "in: %d, out: %d", in, out);
	clk <= 0;
	frame <= 1;
	reset <= 1;
	priority_enable <= 0;
	in <= 3'bzzz;
	#2
	reset <= 0;
	#2
	reset <= 1;
	#2
	in <= 3'b000;
	#2
	in <= 3'b001;
	frame <= 0;
	#2
	frame <= 1;
	in <= 3'bzzz;
	#2
	frame <= 0;
	#2
	frame <= 1;
	#2
	frame <= 1;
end

always
begin
	#1
	clk = ~clk;
end
endmodule // module
