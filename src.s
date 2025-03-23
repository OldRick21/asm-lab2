section .data
section .text
global _start
_start:
    jmp sort_matrix

    mov eax, 60
	mov	edi, 0
	syscall

sort_matrix:
    %ifdef SORT_DESCENDING
        jmp over_flow
    %else
        jmp err
    %endif

over_flow:
    mov	eax, 60
    mov	edi, 1
    syscall
err:
    mov	eax, 60
    mov	edi, 2
    syscall
