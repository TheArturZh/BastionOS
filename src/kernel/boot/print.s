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
