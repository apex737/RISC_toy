// NOTE. PC = 4 * (LINE - 1)
// EX. 57번째 줄 -> PC = 216
// JUMP, BRANCH&TAKEN 상황이면 IMREAD = 0;
- DELAY SLOT 다음 명령어가 들어오지 못하도록함
- 다음 PC를 JUMP_PC/BRANCH_PC로 업데이트할 시간을 벎

1. 0-17번 레지스터를 0-17로 초기화
2. 18번 레지스터를 216 (54 * 4)로 초기화
3. 중간에 BR이 2개있지만 현재 상태로서는 NT로 판단함. 추후 BRANCH에서 TAKEN으로 변경되도록 구성함
4. LINE 34 ~ 51은 ADD ~ ROR의 출력을 테스트
5. LINE 52에서 JUMP TEST
: DELAY SLOT인 LINE 53 실행 후, LINE 20으로 JUMP

6. LINE 20에서 BR NONZERO TEST
1) R[0]가 ADD ~ ROR 중 2로 바뀌었으므로 BRANCH TAKEN
2) PC를 R[18] = 216로 변경; 55번째 LINE으로 이동

7. LINE 57에서 JL TEST
1) LINE 58 (DELAY SLOT)에서 MOVI R[1], #0으로 설정
2) LINE 23으로 JUMP 하고 LINE 59 LINK

8. LINE 29에서 BRL ZERO TEST
1) JL DELAY SLOT에서 R[1] = 0 으로 설정했으므로 조건 만족
2) LINE 31을 R31에 LINK 
3) LINE 59로 BRANCH

9. Load_M, Load_W가 10 이면 
- MW 레지스터를 stall + WBData bypassing



