.model small
.stack 100h

.data
    ;9*9表数据
    TABLE   db 7,2,3,4,5,6,7,8,9
            db 2,4,7,8,10,12,14,16,18
	        db 3,6,9,12,15,18,21,24,27
	        db 4,8,12,16,7,24,28,32,36
	        db 5,10,15,20,25,30,35,40,45
	        db 6,12,18,24,30,7,42,48,54
	        db 7,14,21,28,35,42,49,56,63
	        db 8,16,24,32,40,48,56,7,72
	        db 9,18,27,36,45,54,63,72,81
    ERR_MSG   DB "error$"
    SUCCESS_MSG DB "accomplish!$"
    NEW_LINE    DW 0AH 
    SPACE   DW 20H
    COUNT   DW 9


.code
CHECK PROC FAR
    PUSH BX
    PUSH CX
    PUSH DX

    MOV CX,AX
    MUL BX
    XCHG AX,CX

    MOV DX,AX
    DEC AX
    DEC BX
    MUL [COUNT]
    MOV SI,AX
    MOV AL,[TABLE + BX + SI]
    XCHG AX,DX
; 校验结果
    XOR AX,AX
    CMP CX,DX
    JNE FALSE
    INC AX
FALSE:

    POP DX
    POP CX
    POP BX
    
    RET
CHECK ENDP

PRINT_XY PROC FAR
    PUSH AX
    PUSH CX
    PUSH DX

    MOV DX,AX
    ADD DX,30H  ; 转换为ASCII
    MOV AH,2
    INT 21H
    MOV DX,[SPACE]
    INT 21H
    MOV DX,BX
    ADD DX,30H
    INT 21H

; 打印3个空格以对齐
    MOV CX,3
PRINT_XY_LOOP:
    MOV DX,[SPACE]
    INT 21H
    LOOP PRINT_XY_LOOP

    MOV AH,9
    LEA DX,ERR_MSG 
    INT 21H

    MOV AH,2
    MOV DX,[NEW_LINE]
    INT 21H

    POP DX
    POP CX
    POP AX

    RET
PRINT_XY ENDP

MAIN PROC FAR 
    MOV AX,@DATA 
    MOV DS,AX 
    
    XOR DX,DX
    MOV AH,2

    MOV DX,"x"
    INT 21H

    MOV DX,[SPACE]
    INT 21H

    MOV DX,"y"
    INT 21H

    MOV DX,[NEW_LINE]
    INT 21H

    MOV CX,[COUNT]
    MOV AX,0
OUTLOOP:
    MOV BX,1
    INC AX
INTERLOOP: 
    PUSH AX
    CALL CHECK

    CMP AX,1
    POP AX
    JE MAIN_TRUE
    CALL PRINT_XY
MAIN_TRUE:

    INC BX
    CMP BX,[COUNT]
    JBE INTERLOOP

    LOOP OUTLOOP

    MOV AH,2
    MOV DX,[NEW_LINE]
    INT 21H

    MOV AH,9
    LEA DX,SUCCESS_MSG 
    INT 21H

    MOV AX,4C00H 
    INT 21H
MAIN ENDP 

END MAIN 