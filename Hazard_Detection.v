module Hazard_Detection(
    // For instruction in D-Stage (ID) - 현재 디코드 중인 명령어 정보
    input [4:0] RA0_D, RA1_D,     // ID 단계 명령어의 소스 레지스터 번호 (RS1, RS2에 해당)
    input RS1Used_D, RS2Used_D, // ID 단계 명령어가 RS1, RS2로 GPR을 사용하는지 여부

    // For instruction in E-Stage (EX) - 현재 실행 중인 명령어 정보
    input [4:0] RA0_E, RA1_E,     // EX 단계 명령어의 소스 레지스터 번호 (RS1, RS2에 해당)
    input [4:0] WA_E,            // EX 단계 명령어의 목적지 레지스터 번호
    input Load_E,                // EX 단계 명령어가 Load인지 여부
    input RS1Used_E, RS2Used_E, // EX 단계 명령어가 RS1, RS2로 GPR을 사용하는지 여부

    // For instruction in M-Stage (MEM) - 현재 메모리 접근 중인 명령어 정보
    input [4:0] WA_M,            // MEM 단계 명령어의 목적지 레지스터 번호
    input WEN_M,                 // MEM 단계 명령어의 레지스터 쓰기 활성화 (Active Low)

    // For instruction in W-Stage (WB) - 현재 쓰기 준비 중인 명령어 정보
    input [4:0] WA_W,            // WB 단계 명령어의 목적지 레지스터 번호
    input WEN_W,                 // WB 단계 명령어의 레지스터 쓰기 활성화 (Active Low)

    output reg PCWrite, FDWrite, DEFlush,
    output reg [1:0] FW1, FW2     // EX 단계 명령어의 ALU 입력을 위한 포워딩 제어
);

always@* begin
    PCWrite = 1; FDWrite = 1; DEFlush = 0;
    FW1 = 2'd0; FW2 = 2'd0; 
    if (Load_E && // EX 단계 명령어가 Load이고,
        ( (RS1Used_D && (RA0_D == WA_E)) ||   // ID 단계의 첫 번째 소스가 Load의 목적지와 같거나
          (RS2Used_D && (RA1_D == WA_E)) )) begin // ID 단계의 두 번째 소스가 Load의 목적지와 같을 때
        PCWrite = 0; 
        FDWrite = 0; 
        DEFlush = 1; // EX로 버블 삽입
    end

    // ALU 입력 1 (RA0_E) 포워딩 제어 - EX 단계의 명령어를 위함
    if (RS1Used_E) begin // EX 단계 명령어가 첫 번째 오퍼랜드로 GPR(RA0_E)을 사용할 때만 포워딩 고려
        if (WEN_M == 1'b0 && (RA0_E == WA_M)) FW1 = 2'd1;
        else if (WEN_W == 1'b0 && (RA0_E == WA_W)) FW1 = 2'd2;
    end

    // ALU 입력 2 (RA1_E) 포워딩 제어 - EX 단계의 명령어를 위함
    if (RS2Used_E) begin // EX 단계 명령어가 두 번째 오퍼랜드로 GPR(RA1_E)을 사용할 때만 포워딩 고려
        if (WEN_M == 1'b0 && (RA1_E == WA_M)) FW2 = 2'd1; // MEM 결과 포워딩
        else if (WEN_W == 1'b0 && (RA1_E == WA_W)) FW2 = 2'd2; // WB 결과 포워딩
    end
end
endmodule
