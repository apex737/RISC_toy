module EM(
	// input
	input CLK, RSTN,
	input WEN_E, DRW_E, DREQ_E,
	input [1:0] SelWB_E,
	input [4:0] WA_E, 
	input [31:0] PCADD4_E, ALUOUT_E, DOUT0_E, // DI
	// output
	output reg WEN_M, DRW_M, DREQ_M,
	output reg [1:0] SelWB_M,
	output reg [4:0] WA_M,
	output reg [31:0] PCADD4_M, ALUOUT_M, DOUT0_M // DI
);
always@(posedge CLK or negedge RSTN) begin
	if(~RSTN) begin
		WEN_M <= 1; DREQ_M <= 1; DRW_M <= 0;  SelWB_M <= 0;
		PCADD4_M <= 0; WA_M <= 0; ALUOUT_M <= 0; DOUT0_M <= 0;
	end
	else begin
		WEN_M <= WEN_E; DRW_M <= DRW_E; DREQ_M <= DREQ_E;  
		PCADD4_M <= PCADD4_E; WA_M <= WA_E; ALUOUT_M <= ALUOUT_E; 
		DOUT0_M <= DOUT0_E; SelWB_M <= SelWB_E;
	end
end
endmodule
