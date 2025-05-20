module muxSrc1(
	input [31:0] RD1, PCADD4_E,
	input ALUSRC1,
	output [31:0] selSrc1
);
assign selSrc1 = ALUSRC1 ? RD1 : PCADD4_E; 
endmodule
