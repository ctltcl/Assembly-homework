.model small
.stack 100h
.data
    sum dw 0          ; 存储和
    num db 0          ; 存储当前数字

.code
main proc
    mov ax, @data
    mov ds, ax

    ; 计算1到100的和
    mov cx, 100       ; 循环计数器
    xor ax, ax        ; 清零AX，作为和

sum_loop:
    add ax, cx        ; 累加当前的CX
    loop sum_loop     ; 循环直到CX为0

    ; 将结果存储到数据段
    mov sum, ax

    ; 打印和的结果
    mov ax, sum       ; 载入和到AX
    call print_num     ; 调用打印函数

    ; 程序结束
    mov ax, 4C00h
    int 21h
main endp

print_num proc
    ; 将AX中的数字转换为字符串并输出
    mov bx, 10        ; 除数为10
    xor cx, cx        ; 清零CX，用于计数

convert_loop:
    xor dx, dx        ; 清零DX
    div bx             ; AX除以10，商在AX，余数在DX
    push dx           ; 保存余数
    inc cx            ; 计数
    test ax, ax       ; 检查AX是否为0
    jnz convert_loop   ; 如果AX不为0，继续循环

print_loop:
    pop dx            ; 弹出余数
    add dl, '0'       ; 转换为字符
    mov ah, 02h       ; 功能2：打印字符
    int 21h           ; 调用中断
    loop print_loop    ; 继续打印

    ret
print_num endp
end main
