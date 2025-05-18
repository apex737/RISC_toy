module FD(
	input CLK, RSTN, IREQ,
	input [31:0] INSTR_i, PCadd4_F,
	output [31:0] INSTR_o, PCadd4_D
);
reg [31:0] INSTR, PCadd4;
always@(posedge CLK or negedge RSTN) begin
	if(~RSTN) begin INSTR <= 0; PCadd4 <= 0; end
	else if (IREQ) begin r_reg <= INSTR_i; PCadd4 <= PCadd4_F end
end

assign INSTR_o = r_reg;
assign PCadd4_D = PCadd4;
endmodule
