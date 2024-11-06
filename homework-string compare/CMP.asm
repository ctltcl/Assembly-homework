.MODEL SMALL
.DATA
STRBUF DB 'ASASAASASSASSAASASAS'  ; 要查找的字符串
COUNT EQU $-STRBUF                ; 字符串长度
STRING DB 'AS'                    ; 要查找的字符组合 "AS"
MESSG DB "THE NUMBER OF 'AS' IS: " ; 提示信息
NUM DB ?                          ; 结果存放的位置
DB 0AH, 0DH, '$'                  ; 换行符和字符串结束符

.CODE
MAIN PROC
    MOV AX, @DATA                 ; 初始化数据段
    MOV DS, AX
    MOV ES, AX

    ; 初始化寄存器
    MOV SI, OFFSET STRBUF         ; SI 指向 STRBUF 的起始地址
    MOV CX, COUNT                 ; CX 存储字符串的总长度
    MOV BX, 0                     ; BX 存储找到 "AS" 的次数

SEARCH_LOOP:
    MOV DX, CX                    ; 保存剩余长度
    CMP CX, 2                     ; 判断是否剩余至少两个字符
    JL END_SEARCH                 ; 如果不足两个字符，跳转到结束

    ; 比较 STRBUF 中当前的两个字符是否为 "AS"
    PUSH CX                       ; 保存 CX 和 SI
    PUSH SI

    MOV CX, 2                     ; 设置比较长度为 2 字节
    MOV DI, OFFSET STRING         ; DI 指向 STRING 的起始地址
    REPE CMPSB                    ; 比较 STRING 和 STRBUF 的当前字符
    JNE NO_MATCH                  ; 如果不匹配，跳转到 NO_MATCH

    ; 如果匹配，增加计数器
    INC BX                        ; 计数加一

NO_MATCH:
    POP SI                        ; 恢复 SI 和 CX
    POP CX
    INC SI                        ; SI 指针移动到下一个字符位置
    DEC CX                        ; 剩余长度减一

    JMP SEARCH_LOOP               ; 继续循环

END_SEARCH:
    ; 显示结果
    ADD BL, '0'                   ; 将计数值转化为 ASCII 码
    MOV NUM, BL                   ; 将结果存入 NUM 中
    MOV DX, OFFSET MESSG          ; 指向提示信息
    MOV AH, 09H                   ; DOS 功能调用，显示字符串
    INT 21H

    ; 程序结束
    MOV AH, 4CH
    INT 21H
MAIN ENDP
END MAIN
