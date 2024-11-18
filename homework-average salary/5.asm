data segment
    ; 年份数据，每个年份占4字节
    db '1975','1976','1977','1978','1979','1980','1981','1982','1983'
    db '1984','1985','1986','1987','1988','1989','1990','1991','1992'
    db '1993','1994','1995'

    ; 总工资数据，dword类型
    dd 16,22,382,1356,2390,8000,16000,24486,50065,97479,140417,197514 
    dd 345980,590827,803530,1183000,1843000,2759000,3753000,4649000,5937000

    ; 雇员人数数据，word类型
    dw 3,7,9,13,28,38,130,220,476,778,1001,1442,2258,2793,4037,5635,8226
    dw 11542,14430,15257,17800
data ends

stack segment
    db 128 dup(0)  ; 定义128字节的栈空间
stack ends

code segment
assume cs:code, ds:data, ss:stack

extrn print_string:proc
extrn print_number:proc

start:
    ; 初始化数据段、栈段、显存段
    mov ax, data
    mov ds, ax

    mov ax, stack
    mov ss, ax
    mov sp, 128

    mov ax, 0B800h
    mov es, ax  ; 指向显存段

    ; 初始化循环变量
    mov si, 0           ; SI指向年份数据
    mov di, 84          ; DI指向总工资数据
    mov bp, 168         ; BP指向人数数据
    mov bx, 160 * 1     ; BX控制显存起始位置，行1开始
    mov cx, 21          ; CX循环21次

output_loop:
    ; 输出年份
    push si
    call print_string   ; 调用输出字符串函数
    pop si
    add si, 4           ; 移动到下一个年份
    add bx, 20

    ; 输出总工资
    mov ax, ds:[di]     ; 低16位
    mov dx, ds:[di+2]   ; 高16位
    call print_number   ; 调用输出数字函数
    add di, 4           ; 移动到下一个总工资
    add bx, 30

    ; 输出人数
    mov ax, ds:[bp]
    mov dx, 0
    call print_number   ; 调用输出数字函数
    add bp, 2           ; 移动到下一个人数
    add bx, 30

    ; 计算并输出平均工资
    mov ax, ds:[di-4]   ; 总工资低位
    mov dx, ds:[di-2]   ; 总工资高位
    div word ptr ds:[bp-2] ; 除以人数
    call print_number   ; 输出平均工资

    ; 换行
    add bx, 72

    loop output_loop    ; 循环21次

    ; 程序结束
    mov ax, 4c00h
    int 21h
code ends
end start
