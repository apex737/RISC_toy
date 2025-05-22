module decoder(
	input [31:0] INSTR,
	output [4:0] opcode, ra, rb, rc, shamt,
	output [2:0] cond,
	output shSrc,
	output [16:0] Imm17,
	output [21:0] Imm22,
	output isNOP
);
assign opcode = INSTR[31:27];
assign ra = INSTR[26:22];
assign rb = INSTR[21:17];
assign rc = INSTR[16:12];
assign shamt = INSTR[4:0];
assign shSrc = INSTR[5];
assign cond = INSTR[2:0];
assign Imm17 = INSTR[16:0];
assign Imm22 = INSTR[21:0];
assign isNOP = ~(|INSTR);
endmodule
