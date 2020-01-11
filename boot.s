%include "print_32.s"
%include "cpuid.s"

STACK_SIZE equ 16*1024

MESSAGE_ERROR_NO_MULTIBOOT2:
	db "ERR 0: The kernel have to be loaded using multiboot2", 0

MESSAGE_ERROR_NO_CPUID:
	db "ERR 1: The CPU does not support CPUID", 0

MESSAGE_ERROR_NO_LONG_MODE:
	db "ERR 2: The CPU does not support long mode", 0

MESSAGE_TEST:
	db "Hello, World!", 0


section .bss
bits 32
align 16
stack_bottom:
resb STACK_SIZE
stack_top:


section .text
bits 32

multiboot2_check:
	pusha
	cmp eax, 0x36D76289
	je .end
	mov ebx, MESSAGE_ERROR_NO_MULTIBOOT2
	call print_32_s
	jmp _start.hang
.end:
	popa
	ret

no_cpuid_error:
	mov ebx, MESSAGE_ERROR_NO_CPUID
	call print_32_s
	jmp _start.hang

no_long_mode_error:
	mov ebx, MESSAGE_ERROR_NO_LONG_MODE
	call print_32_s
	jmp _start.hang

global _start:function (_start.end - _start)
_start:
	cli
	mov esp, stack_top
	mov ebp, stack_top

	call multiboot2_check

	call cpuid_check_availability
	cmp eax, 0
	jne no_cpuid_error

	call cpuid_check_long_mode
	cmp eax, 1
	jne no_long_mode_error

	;extern kmain
	;call kmain

	;some tests
	mov ebx, MESSAGE_TEST
	call print_32_s

	mov ebx, 0xFF
	call write_bin_32_s
	call cond_newline_32
	call write_hex_32_s
.hang:
	hlt
	jmp .hang
.end: