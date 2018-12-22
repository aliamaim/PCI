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
