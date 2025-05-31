module Hazard_Detection(
    input [4:0] RA0_D, RA1_D, RA0_E, RA1_E,   
    input RS1Used_D, RS2Used_D, RS1Used_E, RS2Used_E, 
    input [4:0] WA_E, WA_M, WA_W,     
    input Load_E, Load_M,               
    input WEN_M, WEN_W,                
    output PCWrite, IMRead, FDWrite, DEFlush,
    output [1:0] FW1, FW2    
);


assign PCWrite = 1;
assign	IMRead = 1;
assign	FDWrite = 1;
assign	DEFlush = 0;
assign	FW1 = 0;
assign	FW2 = 0;


/* always@* begin
    PCWrite = 1; IMRead = 1; FDWrite = 1; DEFlush = 0; // IMRead : IM Select Negative
    FW1 = 2'd0; FW2 = 2'd0; stall = 0;
		if (Load_E && 
        ( (RS1Used_D && (RA0_D == WA_E)) ||   
          (RS2Used_D && (RA1_D == WA_E)) )) begin 
        stall = 1'b1;
    end
		if (Load_M && 
             ( (RS1Used_D && (RA0_D == WA_M)) || 
               (RS2Used_D && (RA1_D == WA_M)) )) begin 
        stall = 1'b1;
    end
		
    // Select ALUSRC1
    if (RS1Used_E) begin
        if (WEN_M == 1'b0 && (RA0_E == WA_M)) FW1 = 2'd1; // Type1 Bypassing
        else if (WEN_W == 1'b0 && (RA0_E == WA_W)) FW1 = 2'd2; // Type2 Bypassing
    end

    // Select ALUSRC2
    if (RS2Used_E) begin 
        if (WEN_M == 1'b0 && (RA1_E == WA_M)) FW2 = 2'd1;  // Type1 Bypassing
        else if (WEN_W == 1'b0 && (RA1_E == WA_W)) FW2 = 2'd2;   // Type2 Bypassing
    end
		
		// WB - ID Overlap
		if (RS1Used_D && WEN_W == 1'b0 && (RA0_D == WA_W)) stall = 1'b1;
		if (RS2Used_D && WEN_W == 1'b0 && (RA1_D == WA_W)) stall = 1'b1;
		
		if (stall) begin
        PCWrite = 0;    
        IMRead    = 0;    
        FDWrite = 0;    
        DEFlush = 1;    
    end
	end
*/
endmodule
