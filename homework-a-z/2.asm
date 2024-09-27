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
    MOV CX, 26
    MOV AH, 2
    MOV BX, 0          ; 行计数器

L:
    MOV DL, [A]       ; 从 A 中读取字符到 DL
    INT 21H           ; 输出字符
    INC A             ; 增加 A 的值

    INC BX             ; 增加行计数器
    CMP BX, 13        ; 检查是否已输出 13 个字符
    JGE NEWLINE       ; 如果是，跳转到换行

    LOOP L            ; 否则继续循环

NEWLINE:
    MOV DL, 13        ; Carriage return
    INT 21H
    MOV DL, 10        ; Line feed
    INT 21H
    MOV BX, 0         ; 重置行计数器
    LOOP L            ; 继续输出剩余的字符

    MOV AX, 4C00H
    INT 21H

CODESEG ENDS
END START
