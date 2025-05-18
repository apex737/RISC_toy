module FD(
	input CLK, RSTN, FDWrite,
	input [31:0] INSTR_i, PCadd4_F,
	output reg [31:0] INSTR_o, PCadd4_D
);
reg [31:0] INSTR, PCadd4;
wire enable = FDWrite & (|INSTR_i);
always@(posedge CLK or negedge RSTN) begin
	if(~RSTN) begin INSTR <= 0; PCadd4 <= 0; end
	else if (enable) begin 
		INSTR_o <= INSTR_i; 
		PCadd4_D <= PCadd4_F;
	end
end
endmodule
