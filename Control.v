module control(
	input [4:0] opcode, rb,
	input [2:0] cond,
	input shSrc, isNOP,
	output reg WEN, MemToReg, DRW, DREQ, 
	output reg ALUSRC1, // 0: R[rb], 1: PCADD4_E
	output reg [2:0] ALUSRC2, // 0: R[rc], 1: shamt, 2: zeroExt, 3: Iext17, 4: Jext
	output reg [1:0] WDSRC, // 0: ALU_o, 1: ReadData, 2: PCADD4_W
	output reg [3:0] ALUOP
);
wire reduceRB = &rb;
// OP Encode
parameter [4:0] 
	ADD = 5'd0, ADDI = 5'd1, SUB = 5'd2, NEG = 5'd3, NOT = 5'd4, AND = 5'd5, 
	ANDI = 5'd6, OR = 5'd7, ORI = 5'd8, XOR = 5'd9, LSR = 5'd10, ASR = 5'd11, 
	SHL = 5'd12, ROR = 5'd13, MOVI = 5'd14, J = 5'd15, JL = 5'd16, BR = 5'd17,
	BRL = 5'd18, ST = 5'd19, STR = 5'd20, LD = 5'd21, LDR = 5'd22;
// ALUSRC 
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

// ALUOP
always@* begin
	case(opcode)
		ADD, ADDI, J, JL, ST, STR: ALUOP = 4'b0000;
		MOVI : ALUOP = 4'b0001;
		SUB : ALUOP = 4'b0010;
		NEG : ALUOP = 4'b0011;
		NOT : ALUOP = 4'b0100;
		AND, ANDI : ALUOP = 4'b0101;
		OR, ORI : ALUOP = 4'b0110;
		XOR : ALUOP = 4'b0111;
		LSR : ALUOP = 4'b1000;
		ASR : ALUOP = 4'b1001;
		SHL : ALUOP = 4'b1010;
		ROR : ALUOP = 4'b1011;
		BR, BRL : begin
			if(cond == 3'd1) ALUOP = 4'b1100; // Always
			else if(cond == 3'd2  | cond == 3'd3 ) ALUOP = 4'b1101; // BRZero
			else if(cond == 3'd4  | cond == 3'd5 ) ALUOP = 4'b1110; // BRSign
			else ALUOP = 4'b1111; // Never (NOP)
		end
	endcase
end
endmodule

