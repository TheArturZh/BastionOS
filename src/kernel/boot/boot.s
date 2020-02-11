[CPU x64]

STACK_SIZE equ 16 * 1024

%include "./src/kernel/boot/print.s"
%include "./src/kernel/boot/cpuid.s"
%include "./src/kernel/boot/init_paging.s"
%include "./src/kernel/init_defines.s"
%include "./src/kernel/boot/gdt64_init.s"

MESSAGE_ERROR_NO_MULTIBOOT2:
	db "ERR 0: The kernel have to be loaded using multiboot2", 0

MESSAGE_ERROR_NO_CPUID:
	db "ERR 1: The CPU does not support CPUID", 0

MESSAGE_ERROR_NO_LONG_MODE:
	db "ERR 2: The CPU does not support long mode", 0


section .bss
bits 32
align 16
stack_bottom:
resb STACK_SIZE
stack_top:


section .text
bits 32

;This function checks if this kernel was loaded using multiboot2.
multiboot2_check:
	pusha
	cmp eax, 0x36D76289
	je .end

	mov ebx, (MESSAGE_ERROR_NO_MULTIBOOT2 - KERNEL_VMA)
	jmp error_out
.end:
	popa
	ret

no_cpuid_error:
	mov ebx, (MESSAGE_ERROR_NO_CPUID - KERNEL_VMA)
	jmp error_out
no_long_mode_error:
	mov ebx, (MESSAGE_ERROR_NO_LONG_MODE - KERNEL_VMA)
error_out:
	call print_32
	jmp _start.hang

enable_lm:
	;Enable PAE
	mov eax, cr4
	or eax, 1 << 5
	mov cr4, eax

	;Enable long mode
	mov ecx, 0xC0000080
	rdmsr
	or eax, 1 << 8
	wrmsr

	ret

enable_paging:
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

	lgdt [gdt64.pointer - KERNEL_VMA]

	;GDT flush
	mov ax, gdt64.data
	mov ds, ax
	mov es, ax
	mov fs, ax
	mov gs, ax
	mov ss, ax
	jmp gdt64.code32:(.cs_jmp - KERNEL_VMA)
	.cs_jmp:

	call setup_paging

	call enable_lm

	call enable_paging

	jmp gdt64.code64:(enter64 - KERNEL_VMA)
.hang:
	;Should not happen
	hlt
	jmp .hang
.end:


section .text
bits 64

enter64:
	;We are still in lower half,
	;so we need an absolute jump to higher half
	mov rax, .jump_to_higher_half
	jmp rax
	.jump_to_higher_half:

	;Remove kernel from lower half
	call remap_lower

	extern kmain
	call kmain
.hang:
	cli
	hlt
	jmp .hang
