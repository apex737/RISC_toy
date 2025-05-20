module DE(
	// input 
	input [1:0] WDSRC_D,
	input WEN_D, MemToReg_D, DRW_D, DREQ_D, 
	input [31:0] Jext_D, zeroExt_D, Iext_D,
	input ALUSRC1_D,
	input [2:0] ALUSRC2_D, cond_D,
	input [4:0] opcode_D, shamt_D,
	input [31:0] RD1_D, RD2_D, PCADD4_D,
	// output
	output [1:0] WDSRC_E,
	output WEN_E, MemToReg_E, DRW_E, DREQ_E, 
	output [31:0] Jext_E, zeroExt_E, Iext_E,
	output ALUSRC1_E,
	output [2:0] ALUSRC2_E, cond_E,
	output [4:0] opcode_E, shamt_E,
	output [31:0] RD1_D, RD2_E, PCADD4_E,
);
endmodule
