module control(
	input [4:0] opcode, rb,
	input shSrc, isNOP,
	output reg WEN, MemToReg, DRW, DREQ, 
	output ALUSRC1, // 0: R[rb], 1: PCADD4_E
	output reg [2:0] ALUSRC2,
	output reg [1:0] WDSRC // 00: ALU_o, 01: ReadData, 10: PCADD4_W
);
wire reduceRB = &rb;
// ALUSRC 
parameter [4:0] 
	ADD = 5'd0, ADDI = 5'd1, SUB = 5'd2, NEG = 5'd3, NOT = 5'd4, AND = 5'd5, 
	ANDI = 5'd6, OR = 5'd7, ORI = 5'd8, XOR = 5'd9, LSR = 5'd10, ASR = 5'd11, 
	SHL = 5'd12, ROR = 5'd13, MOVI = 5'd14, J = 5'd15, JL = 5'd16, BR = 5'd17,
	BRL = 5'd18, ST = 5'd19, STR = 5'd20, LD = 5'd21, LDR = 5'd22;

always@* begin
	if(isNOP) begin
		WDSRC = 2'b00; ALUSRC2 = 3'b000; 
		{WEN, MemToReg, DRW, DREQ, ALUSRC1} = 5'b10000;
	end
	else begin
		WDSRC = 2'b00; ALUSRC2 = 3'b000;  // R-Type (R[rc])
		{WEN, MemToReg, DRW, DREQ, ALUSRC1} = 5'b00000; // WEN : ACTIVE LOW
		case(opcode)
			ADDI, ANDI, ORI, MOVI: begin
				WDSRC = 2'b00; ALUSRC2 = 3'b011; 	// Iext17
				{WEN, MemToReg, DRW, DREQ, ALUSRC1} = 5'b00000;
			end
			J: begin
				WDSRC = 2'b10; ALUSRC2 = 3'b100; 	// Iext22
				{WEN, MemToReg, DRW, DREQ, ALUSRC1} = 5'b10001;
			end
			JL: begin
				WDSRC = 2'b10; ALUSRC2 = 3'b100; 	// Iext22
				{WEN, MemToReg, DRW, DREQ, ALUSRC1} = 5'b00001;
			end
			STR: begin
				WDSRC = 2'b00; ALUSRC2 = 3'b100; 	// Iext22
				{WEN, MemToReg, DRW, DREQ, ALUSRC1} = 5'b10111; // M[currentPC + signExt(imm22)] = R[ra];
			end
			LDR: begin
				WDSRC = 2'b01; ALUSRC2 = 3'b100; 	// Iext22
				{WEN, MemToReg, DRW, DREQ, ALUSRC1} = 5'b01011; // R[ra] = M[currentPC + signExt(imm22)];
			end
			LSR, ASR, SHL, ROR:	begin // shamt or R[rc]
				WDSRC = 2'b00;
				ALUSRC2 = shSrc ? 3'b000 : 3'b001; 
				{WEN, MemToReg, DRW, DREQ, ALUSRC1} = 5'b00000;
			end
			ST: begin						// zeroExt or Iext17
				WDSRC = 2'b00;
				ALUSRC2 = reduceRB ? 3'b010 : 3'b011; 
				{WEN, MemToReg, DRW, DREQ, ALUSRC1} = 5'b10110;
			end
			LD: begin						// zeroExt or Iext17
				WDSRC = 2'b01;
				ALUSRC2 = reduceRB ? 3'b010 : 3'b011; 
				{WEN, MemToReg, DRW, DREQ, ALUSRC1} = 5'b01010;
			end
		endcase
	end
	
end
endmodule
