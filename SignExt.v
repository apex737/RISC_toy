module signExt(
	input [16:0] Imm17,
	input [21:0] Imm22,
	output [31:0] Iext17, Iext22, zeroExt
);
assign zeroExt = {15'b0, Imm17};
assign Iext17 = {{15{1'b1}}, Imm17};
assign Iext22 = {{10{1'b1}}, Imm22};
endmodule
