module Hazard_Detection(
	input [4:0] RA0_D, RA1_D, RA0_E, RA1_E, WA_E, WA_M, WA_W,
	input Load_E, WEN_M, WEN_W,
	output reg PCWrite, FDWrite, DEFlush,
	output reg [1:0] FW1, FW2
);

always@* begin
	PCWrite = 1; FDWrite = 1; DEFlush = 0;
	FW1 = 2'd0; FW2 = 2'd0;
	// For Load-Use Stall/Flush
	if(Load_E && (RA0_D == WA_E || RA1_D == WA_E)) begin
		PCWrite = 0; FDWrite = 0; DEFlush = 1;
	end
	// ALUSRC1 Select
	if(WEN_M == 0 && RA0_E == WA_M) FW1 = 2'd1; 
	else if(WEN_W == 0 && RA0_E == WA_W) FW1 = 2'd2;
	// ALUSRC2 Select
	if(WEN_M == 0 && RA1_E == WA_M) FW2 = 2'd1; 
	else if(WEN_W == 0 && RA1_E == WA_W) FW2 = 2'd2;
end
endmodule
