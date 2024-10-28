.model small
.stack 100h

.data
    headerMsg db '9x9 Multiplication Table: $'
    newlineChar db 0Dh, 0Ah, '$'
    rowVar dw 0                  ; 外层循环变量
    colVar dw 0                  ; 内层循环变量
    productRes dw 0              ; 存储乘法结果
    numBuffer db 6 dup(0)        ; 用于数字转换

.code
START:
    ; 初始化数据段
    MOV AX, @data
    MOV DS, AX

    ; 打印表头
    LEA DX, headerMsg
    MOV AH, 09h
    INT 21h
    
    LEA DX, newlineChar
    MOV AH, 09h
    INT 21h

    ; 外层循环 (rowVar从9到1递减)
    MOV rowVar, 9
row_loop:
    CMP rowVar, 0
    JL end_prog

    ; 内层循环 (colVar从1递增至rowVar)
    MOV colVar, 1
col_loop:
    MOV AX, colVar
    CMP AX, rowVar
    JG next_row

    ; 计算 rowVar * colVar
    MOV AX, rowVar
    MOV BX, colVar
    MUL BX
    MOV productRes, AX

    ; 打印 rowVar * colVar = productRes
    MOV AX, rowVar
    CALL display_num
    MOV DL, '*'
    MOV AH, 02h
    INT 21h
    MOV AX, colVar
    CALL display_num
    MOV DL, '='
    MOV AH, 02h
    INT 21h
    MOV AX, productRes
    CALL display_num

    ; 制表符
    MOV DL, 09h
    MOV AH, 02h
    INT 21h

    INC colVar
    JMP col_loop

next_row:
    ; 打印换行符
    LEA DX, newlineChar
    MOV AH, 09h
    INT 21h

    DEC rowVar
    JMP row_loop

end_prog:
    ; 程序结束
    MOV AH, 4Ch
    INT 21h

; 子程序：将AX中的数字转换为ASCII字符并输出
display_num PROC
    PUSH AX
    PUSH CX
    PUSH DX
    PUSH SI                   ; 保存SI寄存器

    ; 初始化指针到numBuffer起始位置
    MOV SI, OFFSET numBuffer
    MOV CX, 10

conv_loop:
    XOR DX, DX                ; 清除DX
    DIV CX                    ; AX / 10，商存入AX，余数在DX
    ADD DL, '0'               ; 转换为字符
    MOV [SI], DL              ; 存入numBuffer
    INC SI                    ; 移动指针
    TEST AX, AX               ; 检查AX是否为0
    JNZ conv_loop             ; 如果AX不为0，继续

    ; 输出缓冲区中的字符，倒序输出
    DEC SI                    ; 调整指针
disp_loop:
    MOV DL, [SI]              ; 从numBuffer读取字符
    MOV AH, 02h
    INT 21h
    DEC SI                    ; 前一个字符
    CMP SI, OFFSET numBuffer-1
    JNE disp_loop             ; 如果未到起始位置，继续

    POP SI                    ; 恢复SI寄存器
    POP DX
    POP CX
    POP AX
    RET
display_num ENDP

END START
