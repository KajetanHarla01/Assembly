LED EQU P1.7
;********* Ustawienie TIMERów *********
;TIMER 0
T0_G EQU 0            ;GATE
T0_C EQU 0            ;COUNTER/-TIMER
T0_M EQU 1            ;MODE (0..3)
TIM0 EQU T0_M+T0_C*4+T0_G*8
;TIMER 1
T1_G EQU 0            ;GATE
T1_C EQU 0            ;COUNTER/-TIMER
T1_M EQU 0            ;MODE (0..3)
TIM1 EQU T1_M+T1_C*4+T1_G*8

TMOD_SET EQU TIM0+TIM1*16

TH0_SET EQU 256-36
TL0_SET EQU 0
;**************************************
	LJMP START
	ORG 100H
START:
	LCALL LCD_INIT
	SETB LED
	LCALL GET_NUMBER
	MOV R1, A
	LCALL GET_NUMBER
    MOV R2, A
    LCALL GET_NUMBER
    MOV R3, A
    LCALL GET_NUMBER
    MOV R4, A
    LCALL GET_NUMBER
    MOV R5, A
	DEC R3
	MOV R6, #0
    MOV R0, #0
	MOV TMOD,#TMOD_SET
    MOV TH0,#TH0_SET
    MOV TL0,#TL0_SET
    SETB TR0
LOOP:
    INC R3
    MOV R7,#100
    CJNE R3, #60, SHOW_TIME
    INC R2
    MOV R3, #0
    CJNE R2, #60, SHOW_TIME
    INC R1
    MOV R2, #0
    CJNE R1, #24, SHOW_TIME
    MOV R1, #0
SHOW_TIME:
    LCALL LCD_CLR
    MOV A, R1
    MOV B, #10
    DIV AB
    SWAP A
    ADD A, B
    LCALL WRITE_HEX
    MOV A, #':'
    LCALL WRITE_DATA
    MOV A, R2
    MOV B, #10
    DIV AB
    SWAP A
    ADD A, B
    LCALL WRITE_HEX
    MOV A, #':'
    LCALL WRITE_DATA
    MOV A, R3
    MOV B, #10
    DIV AB
    SWAP A
    ADD A, B
    LCALL WRITE_HEX
    CJNE R6, #0, ALARM_TIME_DEC
	SETB LED
	LJMP CHECK_TIME
ALARM_TIME_DEC:
	DEC R6
CHECK_TIME:
    CLR PSW.7
    MOV A, R1
    SUBB A, R4
    CJNE A, #0, TIME_N10
    CLR PSW.7
    MOV A, R2
    SUBB A, R5
    CJNE A, #0, MIN_NOT_EQUAL
    CJNE R0, #0, TIME_N10
    MOV R0, #1
	MOV R6, #2
    CLR LED
    LJMP TIME_N10
MIN_NOT_EQUAL:
    MOV R0, #0
TIME_N10:
    JNB TF0,$
    MOV TH0,#TH0_SET
    CLR TF0
    DJNZ R7,TIME_N10
    SJMP LOOP
GET_NUMBER:
    LCALL WAIT_KEY
    MOV R6, A
    LCALL LCD_CLR
    MOV A, R6
    LCALL WRITE_HEX
    LCALL WAIT_KEY
    CJNE A, #15, NUM2
    MOV A, R6
    LJMP LOOP_END
NUM2:
    MOV R7, A
    MOV A, R6
    MOV B, #10
    MUL AB
    ADD A, R7
    MOV R6, A
    LCALL LCD_CLR
    MOV A, R6
    MOV B, #10
    DIV AB
    SWAP A
    ADD A, B
    LCALL WRITE_HEX
    LCALL WAIT_ENTER_NW
LOOP_END:
    LCALL LCD_CLR
    MOV A, R6
    RET
STOP:
	LJMP STOP
	NOP	