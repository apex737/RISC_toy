module FD(
	input CLK, RSTN, FDWrite, Flush,
	input [31:0] INSTR_i, PCadd4_F,
	output [31:0] INSTR_o, PCadd4_D
);
reg [31:0] INSTR, PCadd4;
wire enable = FDWrite & (|INSTR_i);
always@(posedge CLK or negedge RSTN) begin
	if(~RSTN|Flush) begin INSTR <= 0; PCadd4 <= 0; end
	else if (enable) begin 
		INSTR <= INSTR_i; 
		PCadd4 <= PCadd4_F;
	end
end
assign INSTR_o = INSTR;
assign PCadd4_D = PCadd4;
endmodule
