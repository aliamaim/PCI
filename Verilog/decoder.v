//This is a special purpose decoder which will be used in the ARBITER in the FIRST IN FIRST OUT mode.
//It's inputs comes from the FIFO (who to give the grant) and it's output is driving the grants coming out from the ARBITER.

module DECODER(out_d, in_d);
	output wire[2:0] out_d;
	input wire[7:0] in_d;

	assign out_d = (in_d === 8'bxxxx_xxxx)? 3'bzzz: 
				   (in_d == 8'b1111_1110)? 3'd0:
				   (in_d == 8'b1111_1101)? 3'd1:
				   (in_d == 8'b1111_1011)? 3'd2:
				   (in_d == 8'b1111_0111)? 3'd3:
				   (in_d == 8'b1110_1111)? 3'd4:
				   (in_d == 8'b1101_1111)? 3'd5:
				   (in_d == 8'b1011_1111)? 3'd6:
				   (in_d == 8'b0111_1111)? 3'd7: 3'bzzz;
endmodule



module tb_decoder();
	reg[7:0] in_d;
	wire[2:0] out_d;

	initial	begin
		$monitor("in:%b, out_d:%d", in_d, out_d);
		#1
		in_d = 8'b1111_1110;
		#1
		in_d = 8'b1111_1101;
		#1
		in_d = 8'b1111_1011;
		#1
		in_d = 8'b1111_0111;
		#1
		in_d = 8'b1110_1111;
		#1
		in_d = 8'b1101_1111;
		#1
		in_d = 8'b1011_1111;
		#1
		in_d = 8'b0111_1111;

	end
	DECODER dec1(out_d, out_d);
endmodule
