[CPU x64]

STACK_SIZE equ 16 * 1024

%include "print_32.s"
%include "cpuid.s"
%include "init_paging.s"
%include "init_defines.s"
%include "gdt64.s"

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
	mov ebx, (MESSAGE_ERROR_NO_MULTIBOOT2 - KERNEL_VMA)
	call print_32
	jmp _start.hang
.end:
	popa
	ret

no_cpuid_error:
	mov ebx, (MESSAGE_ERROR_NO_CPUID - KERNEL_VMA)
	call print_32
	jmp _start.hang

no_long_mode_error:
	mov ebx, (MESSAGE_ERROR_NO_LONG_MODE - KERNEL_VMA)
	call print_32
	jmp _start.hang

enable_lm:
	;Enable PAE
	mov eax, cr4
	or eax, 1 << 5
	mov cr4, eax

	;Set the LM-bit
	mov ecx, 0xC0000080
	rdmsr
	or eax, 1 << 8
	or eax, 101b
	wrmsr

	;Enable paging
	mov eax, cr0
	or eax, 1 << 31
	mov cr0, eax

	ret

global _start:function (_start.end - _start)
_start:
	cli
	mov esp, (stack_top - KERNEL_VMA)
	mov ebp, esp

	call multiboot2_check

	call cpuid_check_availability
	cmp eax, 0
	jne no_cpuid_error

	call cpuid_check_long_mode
	cmp eax, 1
	jne no_long_mode_error

	call setup_paging

	lgdt [gdt64.pointer - KERNEL_VMA]

	;IA-32
	call enable_lm
	;IA-32e.

	;Now in order to leave compatibily mode
	;we need to jump into segment with L flag set in descriptor
	jmp gdt64.code:(enter64 - KERNEL_VMA)
.hang:
	hlt
	jmp .hang
.end:


section .text
bits 64

enter64:
	cli

	;set segment registers to data descriptor
	mov ax, gdt64.data
	mov ds, ax
	mov es, ax
	mov fs, ax
	mov gs, ax
	mov ss, ax

	extern kmain
	call kmain
.hang:
	hlt
	jmp .hang