%ifndef ASM_PRINT
%define ASM_PRINT

VID_MEM equ 0xb8000

section .text
bits 32

;ebx is the pointer to the string
print_32:
	pusha
	mov edx, VID_MEM
	mov ah, 0x07
.loop:
	mov al, [ebx]

	cmp al, 0
	je .end

	mov [edx], ax

	add edx, 2
	add ebx, 1

	jmp .loop
.end:
	popa
	ret

section .text
bits 64

;rbx is the pointer to the string
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
