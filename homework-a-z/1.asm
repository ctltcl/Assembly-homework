STKSEG SEGMENT STACK 
    DW 32 DUP(0)
STKSEG ENDS

DATASEG SEGMENT
    A DB 'a'          ; 使用单引号表示字符
    MSG DB "Hello World$"
DATASEG ENDS

CODESEG SEGMENT
    ASSUME CS:CODESEG, DS:DATASEG
START:
    MOV AX, DATASEG
    MOV DS, AX

    MOV AH, 2
    MOV BX, 0          ; 行计数器

OUTER_LOOP:
    MOV CX, 13         ; 每行输出 13 个字符

INNER_LOOP:
    MOV DL, [A]       ; 从 A 中读取字符到 DL
    INT 21H           ; 输出字符
    INC A             ; 增加 A 的值

    INC BX             ; 增加行计数器
    LOOP INNER_LOOP    ; 循环输出 13 个字符

    ; 换行
    MOV DL, 13        ; Carriage return
    INT 21H
    MOV DL, 10        ; Line feed
    INT 21H

    MOV BX, 0         ; 重置行计数器

    ; 检查是否输出完 26 个字符
    CMP A, 'Z' + 1    ; 检查是否达到 'Z' + 1
    JB OUTER_LOOP     ; 如果还未输出到 'Z'，则继续外层循环

    MOV AX, 4C00H
    INT 21H

CODESEG ENDS
END START
