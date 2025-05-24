module BranchTaken(
	input [31:0] DOUT1_D,
	input [2:0] cond,
	output reg Taken
);
always@* begin
	case(cond)
		1: Taken = 1;
		2: if(DOUT1_D==0) Taken = 1;
		3: if(DOUT1_D!=0) Taken = 1;
		4: if(~DOUT1_D[31]) Taken = 1;
		5: if(DOUT1_D[31]) Taken = 1;
		default Taken = 0;
	endcase
end
endmodule
