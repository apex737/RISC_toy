/*****************************************
    
    Team XX : 
        2024000000    Kim Mina
        2024000001    Lee Minho
*****************************************/


// You are able to add additional modules and instantiate in RISC_TOY.

////////////////////////////////////
//  TOP MODULE
////////////////////////////////////
module RISC_TOY (
	input CLK, RSTN,
	input [31:0] INSTR, // ID
	input [31:0] DRDATA, // MEM
	output [29:0] IADDR, // IF 
	output [29:0] DADDR, // MEM
	output IREQ, DREQ, DRW, // MEM  
	output [31:0] DWDATA    // MEM
);

// IF Stage
	// Mux3 (I0, I1, I2, Sel, Out)
	// Mux3 : PCSRC
		wire [31:0] PCAdd4_F = (IADDR + 1) << 2; // PCSRC0
		wire [31:0] rbData; // PCSRC1
		wire [31:0] Jext, PCAdd4_D;
		wire [31:0] JPC_D = Jext + PCAdd4_D; // PCSRC2
		wire Jump, Branch, Taken;
		wire [1:0] PCSRC = {Jump, Branch&Taken}; // 00: PC+4, 01: rbData(BR_PC), 10: JPC_D
		wire [31:0] NextPC;
		Mux3 muxPC (PCAdd4_F, rbData, JPC_D, PCSRC, NextPC);
		
// FD (Pipeline Register)
	
	
	
// ID Stage
	// INSTR Decode
	wire [4:0] opcode = INSTR[31:27];
	wire ra = INSTR[26:22];
	wire rb = INSTR[21:17];
	wire rc = INSTR[16:12];
	wire shSrc = INSTR[5];
	wire shamt = INSTR[4:0];
	wire cond = INSTR[2:0];
	wire Imm17 = INSTR[16:0];
	wire Imm22 = INSTR[21:0];
	
	// REGISTER FILE FOR GENRAL PURPOSE REGISTERS
	wire Store, Sel1_E;
	wire [31:0] DOUT0_E, DOUT1_E;
	wire [4:0] RA0 = Store ? ra : rb;
	wire [4:0] RA1 = Store ? rb : rc;
	REGFILE    #(.AW(5), .ENTRY(32))    RegFile (
								.CLK    (CLK),
								.RSTN   (RSTN),
								.WEN    (WEN_W),
								.WA     (WA_W),
								.DI     (WBData),
								.RA0    (RA0),
								.RA1    (RA1),
								.DOUT0  (DOUT0),
								.DOUT1  (DOUT1)
	);
		
// DE (Pipeline Register)



	
// EX Stage
	// MuxSRC1
	wire [31:0] SRC1 = Sel1_E ? DOUT0_E : Iext_E;
	
	// MuxSRC2
	
	// ALU
	
	// Mux3 : FWD1, FWD2
	wire [31:0] SRC2, ALUSRC1, ALUSRC2;
	wire [1:0] FW1, FW2;
	Mux3 muxFWD1(SRC1, ALUOUT_M, WBData, FW1, ALUSRC1);
	Mux3 muxFWD2(SRC2, ALUOUT_M, WBData, FW2, ALUSRC2);



// EM (Pipeline Register)



// MEM Stage




// MW (Pipeline Register)




// WB Stage
	// Mux3 : WBSRC
	wire [31:0] ALUOUT_W, LoadData_W, PCADD4_W // MW Output
	wire [31:0]	WBData; 
	wire [1:0] SelWB_W;
	Mux3 muxWB (ALUOUT_W, LoadData_W, PCADD4_W, SelWB_W, WBData);
	
// Hazard Detection & Forward	

	

endmodule
