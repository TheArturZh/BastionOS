%include "./src/kernel/init_defines.s"
%include "./src/kernel/interrupts/exception_handlers.s"

global IDT:data
section .bss
	align 16
	IDT:
		resb 256 * 16 ;256 entries, 16B each
	.end:

section .data
	IDT_Pointer:
		dw IDT.end - IDT - 1 ;Size
		dq IDT ;Pointer


global load_idt:function
section .text
	bits 64

	load_idt:
		lidt [IDT_Pointer - KERNEL_VMA]
	ret
