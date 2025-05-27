module MW(
	// input
	input CLK, RSTN,
	input [1:0] SelWB_M,
	input WEN_M,  
	input [31:0] ALUOUT_M, LoadData_M, PCADD4_M, DOUT0_M,
	input [4:0] WA_M,
	// output
	output reg [1:0] SelWB_W,
	output reg WEN_W,
	output reg [31:0] ALUOUT_W, LoadData_W, PCADD4_W, DOUT0_W,
	output reg [4:0] WA_W
);
always@(posedge CLK or negedge RSTN) begin
	if(~RSTN) begin
		WEN_W <= 1; SelWB_W <= 0; WA_W <= 0;
		ALUOUT_W <= 0; LoadData_W <= 0; PCADD4_W <= 0; DOUT0_W <= 0;
	end
	else begin
		SelWB_W <= SelWB_M; WEN_W <= WEN_M;
		WA_W <= WA_M; PCADD4_W <= PCADD4_M; ALUOUT_W <= ALUOUT_M;
		LoadData_W <= LoadData_M; DOUT0_W <= DOUT0_M; 
	end
end
endmodule
