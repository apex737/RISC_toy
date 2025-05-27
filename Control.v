module Control(
	input [4:0] opcode, rb,
	input shSrc, 
	output reg Sel1_D, // 0: R[rb], 1: Iext
	output reg [2:0] Sel2_D, // 0: R[rc], 1: shamt, 2: zeroExt, 3: Iext, 4: JPC
	output reg [1:0] SelWB_D, // 0: ALUOUT, 1: LoadData, 2: PCADD4_W
	output reg [3:0] ALUOP_D,
	output WEN_D, DRW_D, DREQ_D, 
	output Jump_D, Branch_D, Store, Load_D
);
wire reduceRB = &rb;
// OP Encode
parameter [4:0] 
	ADD = 5'd0, ADDI = 5'd1, SUB = 5'd2, NEG = 5'd3, NOT = 5'd4, AND = 5'd5, 
	ANDI = 5'd6, OR = 5'd7, ORI = 5'd8, XOR = 5'd9, LSR = 5'd10, ASR = 5'd11, 
	SHL = 5'd12, ROR = 5'd13, MOVI = 5'd14, J = 5'd15, JL = 5'd16, BR = 5'd17,
	BRL = 5'd18, ST = 5'd19, STR = 5'd20, LD = 5'd21, LDR = 5'd22;

// Sel1_D, Sel2_D
always@* begin
	{Sel1_D, Sel2_D} = {1'b0, 3'd0};
	case(opcode)
		ADDI, ORI, ANDI : {Sel1_D, Sel2_D} = {1'b0, 3'd1};
		LSR, ASR, SHL, ROR : begin
			Sel1_D = 1'b0;
			Sel2_D = shSrc ? 3'd0 : 3'd2;
		end
		MOVI : {Sel1_D, Sel2_D} = {1'b0, 3'd2};
		ST : {Sel1_D, Sel2_D} = reduceRB ? {1'b0, 3'd3} : {1'b1, 3'd0};
		STR : {Sel1_D, Sel2_D} = {1'b0, 3'd4};
		LD : {Sel1_D, Sel2_D} = reduceRB ? {1'b0, 3'd3} : {1'b0, 3'd1};
		LDR : {Sel1_D, Sel2_D} = {1'b0, 3'd4};
	endcase
end

// ALUOP_D
always@* begin
	case(opcode)
		J, JL, BR, BRL: ALUOP_D = 4'd0; // NOP
		ADD, ADDI : ALUOP_D = 4'd1;
		SUB : ALUOP_D = 4'd2;
		NEG : ALUOP_D = 4'd3;
		NOT : ALUOP_D = 4'd4;
		AND, ANDI : ALUOP_D = 4'd5;
		OR, ORI : ALUOP_D = 4'd6;
		XOR : ALUOP_D = 4'd7;
		LSR : ALUOP_D = 4'd8;
		ASR : ALUOP_D = 4'd9;
		SHL : ALUOP_D = 4'd10;
		ROR : ALUOP_D = 4'd11;
		MOVI : ALUOP_D = 4'd12; // Buffer SRC2
		ST : ALUOP_D = reduceRB ? 4'd12 : 4'd1;
		STR : ALUOP_D = 4'd12;
		LD : ALUOP_D = reduceRB ? 4'd12 : 4'd1;
		LDR : ALUOP_D = 4'd12;
		default: ALUOP_D = 4'd0; // NOP
	endcase
end

// SelWB
always@* begin
	case(opcode)
		LD, LDR : SelWB_D = 2'b01;
		JL, BRL : SelWB_D = 2'b10;
		default : SelWB_D = 2'b00;
	endcase
end

// Ctrl Signal
reg [2:0] Ctrl;
assign {WEN_D, DRW_D, DREQ_D} = Ctrl; // WEN_D : Active Low
always@* begin
	Ctrl = 3'b001; // RegWrite, No MemAccess
	case(opcode)
		J, JL, BR, BRL: Ctrl = 3'b101; // No RegWrite, No MemAccess
		ST, STR: Ctrl = 3'b110;
		LD, LDR: Ctrl = 3'b000;
	endcase
end

assign Jump_D = (opcode == J | opcode == JL);
assign Branch_D = (opcode == BR | opcode == BRL);
assign Store = DRW_D & (~DREQ_D);
assign Load_D = (~DRW_D) & (~DREQ_D);
endmodule

