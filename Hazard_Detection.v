module Hazard_Detection(
	input [4:0] RA0_D, RA1_D, RA0_E, RA1_E, WA_E, WA_M, WA_W,
	input Load_E, WEN_M, WEN_W,
	output reg PCWrite, FDWrite, DEFlush,
	output reg [1:0] FW1, FW2
);

always@* begin
	PCWrite = 1; FDWrite = 1; DEFlush = 0;
	FW1 = 2'b00; FW2 = 2'b00;
	// For Load-Use Stall/Flush
	if(Load_E && (RA0_D == WA_E || RA1_D == WA_E)) begin
		PCWrite = 0; FDWrite = 0; DEFlush = 1;
	end
	// For Type1 Hazard
	if(WEN_M == 0) begin
		if(RA0_E == WA_M) FW1 = 2'b01;
		if(RA1_E == WA_M) FW2 = 2'b01;
	end
	// For Type2 Hazard
	if(WEN_W == 0) begin
		if(RA0_E == WA_W) FW1 = 2'b10;
		if(RA1_E == WA_W) FW2 = 2'b10;
	end
end
endmodule
