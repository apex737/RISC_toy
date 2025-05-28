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
	input [31:0] INSTR, 
	input [31:0] DRDATA, 
	output [29:0] IADDR, 
	output [29:0] DADDR, 
	output IREQ, DREQ, DRW, 
	output [31:0] DWDATA    
);
/////////////////////////////////////
// Declaration
/////////////////////////////////////
	// IF Stage 
	// Mux3 : PCSRC
	wire [31:0] PCAdd4_F; // PCSRC0
	wire [1:0] PCSRC; 
	wire [31:0] NextPC;
	wire PCWrite;
	wire FDWrite;
	
	// FD (Pipeline Register)
	wire [31:0] INSTR_i, PCadd4_F, INSTR_o, PCadd4_D;
	
	// ID Stage
	wire Sel1_D;
	wire [2:0] Sel2_D;
	wire [1:0] SelWB_D;
	wire [3:0] ALUOP_D;
	wire WEN_D, DRW_D, DREQ_D;
	wire Jump_D, Branch_D, Load_D, Taken_D;
	wire [31:0] DOUT0_D, DOUT1_D;
	wire [4:0] RA0_D, RA1_D;
	wire [31:0] Iext_D, Jext, zeroExt_D, shamtExt_D;
	wire signed [31:0] JPC_D; 
	
	// DE (Pipeline Register)
	wire DEFlush;
	wire [1:0] SelWB_E;
	wire WEN_E, Load_E;
	wire DRW_E, DREQ_E, Sel1_E;
	wire [2:0] Sel2_E;
  wire [3:0] ALUOP_E;
	wire [4:0] RA0_E, RA1_E, WA_E;
  wire [31:0] DOUT0_E, DOUT1_E, PCADD4_E;
	wire [31:0] JPC_E, zeroExt_E, Iext_E, shamtExt_E;
	wire Jump_E, Branch_E, Taken_E;


	// EX Stage
	// MuxSRC
	wire [31:0] SRC1, SRC2; 
	// Mux3 : FWD1, FWD2
	wire [31:0] ALUSRC1, ALUSRC2;
	wire [1:0] FW1, FW2;
	wire [31:0] ALUOUT_E;
	
	// MEM Stage
	wire WEN_M, DRW_M, DREQ_M;
	wire [1:0] SelWB_M;
	wire [4:0] WA_M;
	wire [31:0]	PCADD4_M, ALUOUT_M, DOUT0_M, LoadData_M;

	// WB Stage
	wire [1:0] SelWB_W; 
	wire WEN_W;
	wire [31:0] ALUOUT_W, LoadData_W, PCADD4_W, DOUT0_W;
	wire [31:0]	WBData; 

/////////////////////////////////////
// Assign & Instantiation
/////////////////////////////////////
// IF Stage
	assign PCAdd4_F = (IADDR + 1) << 2;
	assign PCSRC = {Jump_E, Branch_E&Taken_E}; // 00: PCAdd4_F, 01: rbData(BR_PC), 10: JPC_D
	// Mux3 (I0, I1, I2, Sel, Out)
	Mux3 muxPC (PCAdd4_F, DOUT0_E, JPC_E, PCSRC, NextPC);
		
	// PC
	PC instPC (PCWrite, CLK, RSTN, NextPC, IADDR);
	
	// IM
	IM instIM (IADDR, IREQ, INSTR);
	// FD (Pipeline Register)
	FD instFD (CLK, RSTN, FDWrite, INSTR_i, PCadd4_F, INSTR_o, PCadd4_D);
	
// ID Stage
	// INSTR Decode
	wire [4:0] opcode = INSTR_o[31:27];
	wire ra = INSTR_o[26:22];
	wire rb = INSTR_o[21:17];
	wire rc = INSTR_o[16:12];
	wire shSrc = INSTR_o[5];
	wire shamt = INSTR_o[4:0];
	wire cond = INSTR_o[2:0];
	wire Imm17 = INSTR_o[16:0];
	wire Imm22 = INSTR_o[21:0];
	// Control Unit	
	Control InstCtrl(
		// Input 
		opcode, rb, shSrc, 
		// Output
		Sel1_D, Sel2_D, SelWB_D, 
		ALUOP_D, WEN_D, DRW_D, DREQ_D, Jump_D, 
		Branch_D, Load_D
	);
	
	// REGISTER FILE FOR GENRAL PURPOSE REGISTERS
	assign RA0_D = DRW_D ? ra : rb;
	assign RA1_D = DRW_D ? rb : rc;
	REGFILE    #(.AW(5), .ENTRY(32))    RegFile (
								.CLK    (CLK),
								.RSTN   (RSTN),
								.WEN    (WEN_W),
								.WA     (WA_W),
								.DI     (WBData),
								.RA0    (RA0_D),
								.RA1    (RA1_D),
								.DOUT0  (DOUT0_D),
								.DOUT1  (DOUT1_D)
	);
	
	// BranchTaken
	BranchTaken InstBR(DOUT1_D, cond, Taken_D);
	
	// SignExt
	SignExt SE(Imm17, Imm22, shamt, Iext_D, Jext, zeroExt_D, shamtExt_D);
	assign JPC_D = $signed(Jext) + $signed(PCadd4_D);

// DE (Pipeline Register)
	DE InstDE(
		// Input
		CLK, RSTN, DEFlush, 
		SelWB_D, WEN_D, Load_D, Jump_D, Branch_D, 
		Taken_D, DRW_D, DREQ_D, Sel1_D, Sel2_D, ALUOP_D, RA0_D, RA1_D, WA_D,
		DOUT0_D, DOUT1_D, PCadd4_D, JPC_D, zeroExt_D, Iext_D, shamtExt_D,
		// Output
		SelWB_E, WEN_E, Load_E, Jump_E, Branch_E, Taken_E, DRW_E, DREQ_E,  
		Sel1_E, Sel2_E, ALUOP_E, RA0_E, RA1_E, WA_E, DOUT0_E, DOUT1_E, PCADD4_E,
		JPC_E, zeroExt_E, Iext_E, shamtExt_E
	);
	
// EX Stage
	// MuxSRC1
	assign SRC1 = Sel1_E ? DOUT0_E : Iext_E;
	// MuxSRC2
	MuxSrc2 InstMuxSrc2(
		Sel2_E, DOUT1_E, Iext_E, shamtExt_E, zeroExt_E, JPC_E, SRC2
	);
	
	Mux3 muxFWD1(SRC1, ALUOUT_M, WBData, FW1, ALUSRC1);
	Mux3 muxFWD2(SRC2, ALUOUT_M, WBData, FW2, ALUSRC2);

	// ALU
	ALU InstALU(ALUOP_E, ALUSRC1, ALUSRC2, ALUOUT_E);

	// EM (Pipeline Register)
	EM InstEM(
		// Input
		CLK, RSTN, WEN_E, DRW_E, DREQ_E, SelWB_E, WA_E, 
		PCADD4_E, ALUOUT_E, DOUT0_E,
		// Output
		WEN_M, DRW_M, DREQ_M, SelWB_M, WA_M,
		PCADD4_M, ALUOUT_M, DOUT0_M
	);
	
// MEM Stage
	SRAM InstRAM(
		.CLK(CLK),
		.CSN(DREQ_M), 
		.A(ALUOUT_M),
		.WEN(DRW_M),
		.DI(DOUT0_M),
		.DOUT(LoadData_M)
	);

// MW (Pipeline Register)
	MW InstMW(
		// Input
		CLK, RSTN, SelWB_M, WEN_M, ALUOUT_M, LoadData_M, 
		PCADD4_M, WA_M,
		// Output
		SelWB_W, WEN_W, ALUOUT_W, LoadData_W, 
		PCADD4_W, WA_W
	);

// WB Stage
	// Mux3 (I0, I1, I2, Sel, Out)
	Mux3 muxWB (ALUOUT_W, LoadData_W, PCADD4_W, SelWB_W, WBData);
	
// Hazard Detection & Forward	
	Hazard_Detection InstHD(
		// Input
		RA0_D, RA1_D, RA0_E, RA1_E, WA_E, WA_M, WA_W,
		Load_E, WEN_M, WEN_W, 
		// Output
		PCWrite, FDWrite, DEFlush, FW1, FW2
	);
	
endmodule
