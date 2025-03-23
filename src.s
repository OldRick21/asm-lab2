section .data
    ; res = ((a + b)^2 - (c - d)^2) / (a + e^3 - c)
    res dq 0
    a  dd 214748000         ; 32-битное знаковое число
    b  dw 3200         ; 16-битное знаковое число
    c  dd 214748001         ; 32-битное знаковое число
    d  dw 3201         ; 16-битное знаковое число
    e  dd 300          ; 32-битное знаковое число

section .text
global _start

_start:

    mov r12d, dword [e]

    ; Вычисление e^2
    mov eax, r12d
    imul r12d
    mov	esi, eax ;кладем младшую часть от умножения в esi
	sal	rdx, 32  ;передвигаем старшие 32 бита в младшие 32 
	or	rsi, rdx 

    mov rax, rsi
    imul r12d
    jo over_flow
    mov	esi, eax ;кладем младшую часть от умножения в esi
	sal	rdx, 32  ;передвигаем старшие 32 бита в младшие 32 
	or	rsi, rdx 

    movsx r12, r12d
    mov r12, rsi

    ;Вычисление (a + e^3 - c)
    movsx r8, dword [a]
	movsx r10, dword [c]
    sub r8, r10
    jo over_flow
    add r12, r8
    jo over_flow

    ;Проверка на 0
    mov rbx, rdx
    or	rbx, rax
    test rbx, rbx 
	jz	err

    mov r8d, dword [a]
	movsx r9d, word [b]
	mov r10d, dword [c]
	movsx r11d, word [d]

    ; Вычисление (a + b)
    add r8d, r9d
    jo over_flow

    ; Вычисление (c - d)
    sub r10d, r11d
    jo over_flow

    ; Вычисление (a - b)^2
    mov eax, r8d
    imul r8d
    mov	esi, eax ;кладем младшую часть от умножения в esi
	sal	rdx, 32  ;передвигаем старшие 32 бита в младшие 32 
	or	rsi, rdx 
    movsx r9, r9d
    mov r9, rsi

    ; Вычисление (c - d)^2
    mov eax, r10d
    imul r10d
    mov	esi, eax ;кладем младшую часть от умножения в esi
	sal	rdx, 32  ;передвигаем старшие 32 бита в младшие 32 
	or	rsi, rdx 
    movsx r11, r11d
    mov r11, rsi

    ; Вычисоение (a + b)^2 - (c - d)^2
    sub r9, r11
    jo over_flow

    ;Вычисление (a + b)^2 - (c - d)^2 / (a + e^3 - c)
    mov rax, r9
    cqo
    idiv r12

    mov [res], rax

    mov eax, 60
	mov	edi, 0
	syscall

over_flow:
    mov	eax, 60
    mov	edi, 2
    syscall
err:
    mov	eax, 60
    mov	edi, 1
    syscall
