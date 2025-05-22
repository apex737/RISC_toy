module DE(
	// input 
	input CLK, RSTN, DEWrite,
	input [1:0] WDSRC_D,
	input WEN_D, MemToReg_D, DRW_D, DREQ_D, 
	input ALUSRC1_D,
	input [2:0] ALUSRC2_D, 
	input [3:0] ALUOP_D,
	input [4:0] shamt_D,
	input [31:0] RD1_D, RD2_D, DA_D, PCADD4_D,
	input [31:0] Jext_D, zeroExt_D, Iext_D,
	// output
	output reg [1:0] WDSRC_E,
	output reg WEN_E, MemToReg_E, DRW_E, DREQ_E, 
	output reg ALUSRC1_E,
	output reg [2:0] ALUSRC2_E, 
	output reg [3:0] ALUOP_E,
	output reg [4:0] shamt_E,
	output reg [31:0] RD1_E, RD2_E, DA_E, PCADD4_E,
	output reg [31:0] Jext_E, zeroExt_E, Iext_E
);
always@(posedge CLK or negedge RSTN) begin
	if(~RSTN) begin
		WDSRC_E <= 0; WEN_E <= 0; MemToReg_E <= 0; DRW_E <= 0; DREQ_E <= 0; 
		ALUSRC1_E <= 0; ALUSRC2_E <= 0; ALUOP_E <= 0; shamt_E <= 0;
		RD1_E <= 0; RD2_E <= 0; DA_E <= 0; PCADD4_E <= 0; Jext_E <= 0; zeroExt_E <= 0; Iext_E <= 0;
	end
	else if(DEWrite) begin
		WDSRC_E <= WDSRC_D; WEN_E <= WEN_D; MemToReg_E <= MemToReg_D; DRW_E <= DRW_D; DREQ_E <= DREQ_D;
		ALUSRC1_E <= ALUSRC1_D; ALUSRC2_E <= ALUSRC2_D; ALUOP_E <= ALUOP_D; shamt_E <= shamt_D;
		RD1_E <= RD1_D; RD2_E <= RD2_D; DA_E <= DA_D; PCADD4_E <= PCADD4_D;
		Jext_E <= Jext_D; zeroExt_E <= zeroExt_D; Iext_E <= Iext_D;
	end
end
endmodule
