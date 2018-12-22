//This module is a special purpose encoder which will be used in part of the ARBITER in the FIRST IN FIRST OUT mode.
//It's input is the request lines from the devices and it's output goes directly to the FIFO which processes the requests and orders it.

module ENCODER(out_e, in_e);
	output wire[7:0] out_e;
	input wire[2:0] in_e;

	assign out_d = (in_d === 3'bxxx)? 8'hff:
				   (in_d == 3'd0)? 8'b1111_1110:
				   (in_d == 3'd1)? 8'b1111_1101:
				   (in_d == 3'd2)? 8'b1111_1011:
				   (in_d == 3'd3)? 8'b1111_0111:
				   (in_d == 3'd4)? 8'b1110_1111:
				   (in_d == 3'd5)? 8'b1101_1111:
				   (in_d == 3'd6)? 8'b1011_1111:
				   (in_d == 3'd7)? 8'b0111_1111: 8'hff;

endmodule // module
