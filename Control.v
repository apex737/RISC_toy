module control(
	input [4:0] opcode, rb,
	input shSrc,
	output WEN, MemToReg, DRW, DREQ, Jump,
	output reg [2:0] ALUSRC
);
wire reduceRB = &rb;
// ALUSRC 
parameter [4:0] 
	ADD = 5'd0, ADDI = 5'd1, SUB = 5'd2, NEG = 5'd3, NOT = 5'd4, AND = 5'd5, 
	ANDI = 5'd6, OR = 5'd7, ORI = 5'd8, XOR = 5'd9, LSR = 5'd10, ASR = 5'd11, 
	SHL = 5'd12, ROR = 5'd13, MOVI = 5'd14, J = 5'd15, JL = 5'd16, BR = 5'd17,
	BRL = 5'd18, ST = 5'd19, STR = 5'd20, LD = 5'd21, LDR = 5'd22;

always@* begin
	ALUSRC = 3'b000; // R-Type (R[rc])
	case(opcode)
		ADDI, ANDI, ORI, MOVI: 
			ALUSRC = 3'b011; 	// Iext17
		J, JL, STR, LDR: 
			ALUSRC = 3'b100; 	// Iext22
		LSR, ASR, SHL, ROR:	// shamt or R[rc]
			ALUSRC = shSrc ? 3'b001 : 3'b000; 
		ST, LD: 						// zeroExt or Iext17
			ALUSRC = reduceRB ? 3'b010 : 3'b011; 
		
	endcase
end
endmodule
