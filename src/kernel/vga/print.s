	;; This function is currently used for exception ISRs
	;; just because i'm lazy to write them in C++

%ifndef PRINT_ASM_
%define PRINT_ASM_

VID_MEM equ 0xb8000

section .text
bits 64

;; rbx is the pointer to the string
print_64:
	push rax
	push rbx
	push rcx
	push rdx

	mov rdx, VID_MEM
	mov ah, 0x07

.loop:
	mov al, [rbx]

	cmp al, 0
	je .end

	mov [rdx], ax

	add rdx, 2
	add rbx, 1

	jmp .loop
.end:
	pop rdx
	pop rcx
	pop rbx
	pop rax

	ret
%endif
	
