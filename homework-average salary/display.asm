data segment
    ; 如果有需要的数据，可以在这里定义
data ends

code segment
assume cs:code, ds:data

; 输出字符串函数
; 输入：SI = 字符串地址
; 输出：无
public print_string
print_string proc
    mov cx, 4          ; 每次固定输出4个字符
print_string_loop:
    mov al, [si]       ; 取字符
    mov ah, 02h        ; 颜色属性：绿色
    mov es:[bx], ax    ; 写入显存
    inc si             ; 指向下一个字符
    add bx, 2          ; 显存指针移动
    loop print_string_loop
    ret
print_string endp

; 输出32位数字函数
; 输入：AX = 数字低16位, DX = 数字高16位
; 输出：无
public print_number
print_number proc
    push ax
    push bx
    push cx
    push dx
    push si

    mov cx, 10         ; 基数10
    mov si, bx         ; 保存显存指针
    mov bx, 0          ; 清零BX用于保存结果
print_number_div:
    xor dx, dx         ; 高位清零
    div cx             ; DX:AX / CX
    push dx            ; 保存余数
    inc bx             ; 位数计数
    cmp ax, 0          ; 检查是否结束
    jne print_number_div

    ; 输出数字
    mov cx, bx         ; CX记录位数
print_number_output:
    pop dx             ; 取余数
    add dl, '0'        ; 转换为ASCII码
    mov dh, 02h        ; 颜色属性：绿色
    mov es:[si], dx    ; 写入显存
    add si, 2          ; 显存指针移动
    loop print_number_output

    mov bx, si         ; 恢复显存指针
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret
print_number endp

code ends
end
