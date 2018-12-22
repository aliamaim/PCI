//This module is in the ARBITER in the PRIORITY mode, it's inputs are the requests from the devices and it's output is the grants to the devices

module priority_arbiter(GNT, REQ, frame, priority_enable, reset, clk);
	output reg[7:0] GNT; //GNT[0] represents Device A, GNT[1] represents Device B and so on...
	input wire[7:0] REQ;  //REQ[0] represents Device A, REQ[1] represents Device B and so on...
	input frame; //Monitor the frame 
	input reset, clk;
	input priority_enable; //Enable the priority protocol if this line is set to logical 1 only.


	reg[7:0] REQ_MEM; //Because we don't wanna give the grant(write operation) at the posedge of the clk, so we have to wait for the negedge to grant


	always@(negedge reset)
	begin
		GNT <= 8'b1111_1111;
		REQ_MEM <= 8'b1111_1111; 
	end
	/*
	At each posedge clk read the requests and store it in REQ_MEM
	*/
	always@(posedge clk)
	begin
		if(priority_enable == 1'b1)
		begin
			REQ_MEM <= REQ;
		end
	end
	/*
	At each clk negedge check if a request is asserted according the priority from the highest to the lowest (REQ_MEM[0] --> REQ_MEM[7] AKA Device A --> Device H)
	if the request is asserted give the device grant
	*/
	always@(negedge clk)
	begin
		if(priority_enable == 1'b1)
		begin
			if(REQ_MEM[0] == 1'b0)
				GNT[0] <= 1'b0;
			else if(REQ_MEM[1] == 1'b0)
				GNT[1] <= 1'b0;
			else if(REQ_MEM[2] == 1'b0)
				GNT[2] <= 1'b0;
			else if(REQ_MEM[3] == 1'b0)
				GNT[3] <= 1'b0;
			else if(REQ_MEM[4] == 1'b0)
				GNT[4] <= 1'b0;
			else if(REQ_MEM[5] == 1'b0)
				GNT[5] <= 1'b0;
			else if(REQ_MEM[6] == 1'b0)
				GNT[6] <= 1'b0;
			else if(REQ_MEM[7] == 1'b0)
				GNT[7] <= 1'b0;
			else
				GNT <= 8'b1111_1111;
 		end
	end
	/*
	When the frame goes down that means that the current highest priority device just took the bus,
	so we will raise it's grant since it doesn't need it anymore (it has control over the bus).
	That's done so that the grant is given to the next device (according to priority)
	*/
	always@(negedge frame)
	begin
		if(priority_enable == 1'b1)
		begin
			if(GNT[0] == 1'b0)
				GNT[0] <= 1'b1;
			else if(GNT[1] == 1'b0)
				GNT[1] <= 1'b1;
			else if(GNT[2] == 1'b0)
				GNT[2] <= 1'b1;
			else if(GNT[3] == 1'b0)
				GNT[3] <= 1'b1;
			else if(GNT[4] == 1'b0)
				GNT[4] <= 1'b1;
			else if(GNT[5] == 1'b0)
				GNT[5] <= 1'b1;
			else if(GNT[6] == 1'b0)
				GNT[6] <= 1'b1;
			else if(GNT[7] == 1'b0)
				GNT[7] <= 1'b1;
			else
				GNT <= 8'b1111_1111;
		end
	end
endmodule



module tb_priority_arbiter();
	wire[7:0] GNT;
	reg[7:0] REQ;
	reg frame, priority_enable, reset, clk;
	priority_arbiter pri_arbi(GNT, REQ, frame, priority_enable, reset, clk);


	initial
	begin
		$monitor("REQ: %b  FRAME: %b  GNT: %b", REQ, frame, GNT);
		priority_enable <= 1;
		reset <= 1;
		clk <= 0;
		#2
		frame <= 1;
		REQ <= 8'b1111_1111;
		#2
		REQ <= 8'b1111_1000;
		#4
		frame <= 1'b0;
		REQ <= 8'b1111_1001;
		#2
		frame <= 1'b1;
		#2
		frame <= 1'b0;
		REQ <= 8'b1111_1011;
		#2
		frame <= 1'b1;
		#2
		frame <= 1'b0;
		REQ <= 8'b1111_1111;
		#2
		frame <= 1'b1;


	end

	always
	begin
		#1	
		clk <= ~clk;
	end
endmodule // module

