module muxSrc2(
	input [31:0] RD2, zeroExt, Iext, Jext,
	input [4:0] shamt,
	input [2:0] ALUSRC2,
	output reg [31:0] selSrc2
);
always@* begin
	case(ALUSRC2)
		3'b001: selSrc2 = Iext;
		3'b010: selSrc2 = zeroExt;
		3'b010: selSrc2 = Jext;
		3'b100: selSrc2 = RD2;
		default: selSrc2 = RD2;
	endcase
end
endmodule
