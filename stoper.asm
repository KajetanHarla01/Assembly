ALARM EQU P1.5
;********* Ustawienie TIMERÓW *********
;TIMER 0
T0_G EQU 0 ;GATE
T0_C EQU 0 ;COUNTER/-TIMER
T0_M EQU 1 ;MODE (0..3)
TIM0 EQU T0_M+T0_C*4+T0_G*8
;TIMER 1
T1_G EQU 0 ;GATE
T1_C EQU 0 ;COUNTER/-TIMER
T1_M EQU 1 ;MODE (0..3)
TIM1 EQU T1_M+T1_C*4+T1_G*8
TMOD_SET EQU TIM0+TIM1*16

TH0_SET EQU 256-36
TL0_SET EQU 0
TH1_SET EQU 256-180
TL1_SET EQU 0
;**************************************
    LJMP START
;********* Przerwanie Timer 0 *********
    ORG 0BH
    MOV TH0, #TH0_SET
    LCALL INC_TIME
    LCALL SHOW_TIME
    RETI
;**************************************
;********* Przerwanie Timer 1 *********
    ORG 1BH
    MOV TH1, #TH1_SET
	CJNE R6, #0, NO_CLR_ALARM
	SETB ALARM
NO_CLR_ALARM:
	DEC R6
    DJNZ R7, NO_10SEC
    CLR ALARM
    MOV R7, #200
	MOV R6, #10
NO_10SEC:
    RETI
;**************************************
    ORG 100H
START:
    LCALL LCD_CLR
    SETB ALARM
    MOV TMOD, #TMOD_SET
    MOV TH0, #TH0_SET
    MOV TL0, #TL0_SET
    MOV TH1, #TH1_SET
    MOV TL1, #TL1_SET
    SETB EA
    SETB ET0
    SETB ET1
    MOV R1, #0
    MOV R2, #0
    MOV R7, #200
	MOV R6, #10
    SETB TR0
    SETB TR1
MAIN_LOOP:
    LCALL WAIT_ENTER_NW
    CLR TR0
    CLR TR1
    LCALL WAIT_ENTER_NW
    SETB TR0
    SETB TR1
    SJMP MAIN_LOOP
    SJMP $ 
INC_TIME:
    INC R2
    CJNE R2, #100, END_INC_TIME
    INC R1
    MOV R2, #0
    CJNE R1, #100, END_INC_TIME
    MOV R1, #0
END_INC_TIME:
    RET
    NOP
SHOW_TIME:
    LCALL LCD_CLR
    MOV A, R1
    MOV B, #10
    DIV AB
    SWAP A
    ADD A, B
    LCALL WRITE_HEX
    MOV A, #','
    LCALL WRITE_DATA
    MOV A, R2
    MOV B, #10
    DIV AB
    SWAP A
    ADD A, B
    LCALL WRITE_HEX 
    RET 
    NOP
STOP:
    LJMP STOP
    NOP