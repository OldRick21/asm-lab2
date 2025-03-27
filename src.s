section .data
    rows:
        db 3
    cols:
        db 5
    matrix:
        dw 12, -5, 7, 3, 0
        dw 4, 9, -2, 6, 1
        dw -1, 8, 15, 2, -3
section .text
global _start
_start:
    mov r8, -1; костыль

rowloop:
    add r8b, 1
    cmp r8b, byte [rows]
    jae _end ;jae >=
    mov r9b, 0
    jmp colloop_odd


colloop_odd:
    mov r14, 1 ;флаг отвечающий за фазу чет\нечет
    mov r12b, byte [cols] 
    sub r12b, 1
    cmp r9b, r12b
    jae pre_colloop_even

    movzx rax, r8b           ; Загружаем индекс строки в RAX
    movsx rdi, byte [cols]     
    imul rax, rdi
    imul rax, 2               ; Умножаем на размер строки (10 байт)
    movzx rbx, r9b           ; Загружаем индекс столбца в RBX
    imul rbx, 2              ; Умножаем на размер элемента (2 байта)
    mov si, word [matrix + rax + rbx]  ; Полный адрес

;
    movzx rax, r8b           
    movsx rdi, byte [cols]     
    imul rax, rdi
    imul rax, 2             
    movzx rbx, r9b          
    imul rbx, 2              
    mov cx, word [matrix + rax + rbx + 2] 

    add r9b, 2 ;add r9b, 1

    jmp cmp



pre_colloop_even:
    mov r9b, 1
    jmp colloop_even


colloop_even:
    mov r14, 0 ;флаг отвечающий за фазу чет\нечет
    mov r12b, byte [cols] 
    sub r12b, 1
    cmp r9b, r12b
    jae flag_chech

    movzx rax, r8b           ; Загружаем индекс строки в RAX
    movsx rdi, byte [cols]     
    imul rax, rdi
    imul rax, 2               ; Умножаем на размер строки (10 байт)
    movzx rbx, r9b           ; Загружаем индекс столбца в RBX
    imul rbx, 2              ; Умножаем на размер элемента (2 байта)
    mov si, word [matrix + rax + rbx]  ; Полный адрес

;
    movzx rax, r8b      
    movsx rdi, byte [cols]     
    imul rax, rdi
    imul rax, 2              
    movzx rbx, r9b          
    imul rbx, 2              
    mov cx, word [matrix + rax + rbx + 2] 

    add r9b, 2 ;add r9b, 1

    jmp cmp

flag_chech:
    cmp r13, 0
    je rowloop
    mov r13, 0
    mov r9b, 0
    jmp colloop_odd


cmp:
    %ifdef SORT_DESCENDING

        cmp si, cx

    %else

        cmp cx, si 

    %endif

    jg swap;первый больше 
    jle not_swap;меньше или равен

swap:
    mov word [matrix + rax + rbx + 2], si
    mov word [matrix + rax + rbx], cx
    cmp r14, 1 ;флаг отвечающий за фазу чет\нечет
    mov r13, 1
    je colloop_odd
    jmp colloop_even


not_swap:
    cmp r14, 1 ;флаг отвечающий за фазу чет\нечет
    je colloop_odd
    jmp colloop_even

_end:
    mov eax, 60
	mov	edi, 0
	syscall
