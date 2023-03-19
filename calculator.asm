    LJMP START
	ORG	100H
START:
    LCALL LCD_INIT
    MOV R3, #2
CALC_NUM:
    DEC R3
    LCALL WAIT_KEY
    MOV R1, A
    LCALL LCD_CLR
    MOV A, R1
    LCALL WRITE_HEX
    LCALL WAIT_KEY
    CJNE A, #15, NUM2
    MOV A, R1
    PUSH ACC
    LJMP LOOP_END
NUM2:
    MOV R2, A
    MOV A, R1
    MOV B, #10
    MUL AB
    ADD A, R2
    PUSH ACC
    MOV R1, A
    LCALL LCD_CLR
    MOV A, R1
    MOV B, #10
    DIV AB
    SWAP A
    ADD A, B
    LCALL WRITE_HEX
    LCALL WAIT_ENTER_NW
LOOP_END:
    LCALL LCD_CLR
    CJNE R3, #0, CALC_NUM
OPERATION:
    LCALL WAIT_KEY
    MOV R1, A
    LCALL LCD_CLR
    MOV A, R1
    PUSH ACC
    CJNE A, #10, NEXT_OP1
ADD:
    POP ACC
    POP ACC
    MOV R2, A
    POP ACC
    MOV R1, A
    ADD A, R2
    MOV R3, A
    MOV A, R1
    MOV B, #10
    DIV AB
    SWAP A
    ADD A, B
    LCALL WRITE_HEX
    MOV A, #'+'
    LCALL WRITE_DATA
    MOV A, R2
    MOV B, #10
    DIV AB
    SWAP A
    ADD A, B
    LCALL WRITE_HEX
    MOV A, #'='
    LCALL WRITE_DATA
    MOV B, #100
    MOV A, R3
    DIV AB
    MOV R1, B
    CJNE A, #1, ADD_RES_0
    LCALL WRITE_HEX
ADD_RES_0:
    MOV A, R1
    MOV B, #10
    DIV AB
    SWAP A
    ADD A, B
    LCALL WRITE_HEX
    LJMP STOP
NEXT_OP1:
    CJNE A, #11, NEXT_OP2
SUBTRACT:
    POP ACC
    POP ACC
    MOV R2, A
    POP ACC
    MOV R1, A
    MOV B, #10
    DIV AB
    SWAP A
    ADD A, B
    LCALL WRITE_HEX
    MOV A, #'-'
    LCALL WRITE_DATA
    MOV A, R2
    MOV B, #10
    DIV AB
    SWAP A
    ADD A, B
    LCALL WRITE_HEX
    MOV A, #'='
    LCALL WRITE_DATA
    MOV A, R1
    CLR PSW.7
    SUBB A, R2
    MOV R3, A
    JNC SUB_POS
    MOV A, #'-'
    LCALL WRITE_DATA
    MOV A, R2
    CLR PSW.7
    SUBB A, R1
SUB_POS:
    MOV B, #10
    DIV AB
    SWAP A
    ADD A, B
    LCALL WRITE_HEX
    LJMP STOP
NEXT_OP2:
    CJNE A, #12, DIVIDE
MULTIPLY:
    POP ACC
    POP ACC
    MOV R2, A
    POP ACC
    MOV R1, A
    MOV B, #10
    DIV AB
    SWAP A
    ADD A, B
    LCALL WRITE_HEX
    MOV A, #'*'
    LCALL WRITE_DATA
    MOV A, R2
    MOV B, #10
    DIV AB
    SWAP A
    ADD A, B
    LCALL WRITE_HEX
    MOV A, #'='
    LCALL WRITE_DATA
    MOV A, R1
    MOV B, R2
    MUL AB
    MOV R1, A
    MOV A, B
    LCALL WRITE_HEX
    MOV A, R1
    LCALL WRITE_HEX
    LJMP STOP
DIVIDE:
    POP ACC
    POP ACC
    MOV R2, A
    POP ACC
    MOV R1, A
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
    MOV A, #'='
    LCALL WRITE_DATA
    MOV A, R1
    MOV B, R2
    DIV AB
    MOV R3, B
    MOV B, #10
    DIV AB
    SWAP A
    ADD A, B
    LCALL WRITE_HEX
    CJNE R3, #0, DIV_REST
    LJMP STOP
DIV_REST:
    MOV A, #' '
    LCALL WRITE_DATA
    MOV A, R3
    MOV B, #10
    DIV AB
    SWAP A
    ADD A, B
    LCALL WRITE_HEX
    MOV A, #'/'
    LCALL WRITE_DATA
    MOV A, R2
    MOV B, #10
    DIV AB
    SWAP A
    ADD A, B
    LCALL WRITE_HEX
    LJMP STOP
STOP:
    LJMP STOP
    NOP   