module decoder(
	input [31:0] INSTR,
	output [4:0] opcode, ra, rb, rc, shamt,
	output [2:0] cond,
	output shSrc,
	output [16:0] Imm17,
	output [21:0] Imm22,
	output isNOP
);
wire opcode = INSTR[31:27];
wire ra = INSTR[26:22];
wire rb = INSTR[21:17];
wire rc = INSTR[16:12];
wire shamt = INSTR[4:0];
wire shSrc = INSTR[5];
wire Imm17 = INSTR[16:0];
wire Imm22 = INSTR[21:0];
wire isNOP = ~(|INSTR);
endmodule
