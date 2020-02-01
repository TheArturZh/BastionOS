%include "./src/kernel/vga/print.s"

section .rodata

MESSAGE_EXCEPTION_DIV_BY_ZERO:
	db "EXCEPTION 0: Divide-by-zero error", 0
MESSAGE_EXCEPTION_DOUBLE_FAULT:
	db "EXCEPTION 8: Double Fault", 0
MESSAGE_EXCEPTION_GENERAL_PROTECTION_FAULT:
	db "EXCEPTION 13: General Protection Fault", 0
MESSAGE_EXCEPTION_PAGE_FAULT:
	db "EXCEPTION 14: Page Fault", 0

section .text
bits 64

isr_error:
	call print_64
.halt:
	hlt
	jmp .halt

global isr_divide_by_zero
isr_divide_by_zero:
	mov rbx, MESSAGE_EXCEPTION_DIV_BY_ZERO
	jmp isr_error
	iretq

global isr_double_fault
isr_double_fault:
	mov rbx, MESSAGE_EXCEPTION_DOUBLE_FAULT
	jmp isr_error
	iretq

global isr_gp_fault
isr_gp_fault:
	mov rbx, MESSAGE_EXCEPTION_GENERAL_PROTECTION_FAULT
	jmp isr_error
	iretq

global isr_page_fault
isr_page_fault:
	mov rbx, MESSAGE_EXCEPTION_PAGE_FAULT
	jmp isr_error
	iretq