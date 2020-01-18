%include "init_defines.s"

section .bss
bits 32
align 4096

PML4T:
	resb 4096
PDPT:
	resb 4096
PD:            ;for huge pages allocated for kernel space
	resb 4096
PT:            ;should be linked to PD,
               ;used if remaining unmapped kernel space is <2MiB (NYI)
	resb 4096

extern _kernel_start
extern _kernel_end

section .text
bits 32

setup_paging:
	pusha

	;Linking tables together
	mov edx, (PML4T - KERNEL_VMA + (510 * 8)) ;Phys address of 510th entry in PML4T.
	                                              ;It gives 512 GiB of memory for kernel space.
											      ;511th entry is for recursive paging.
	mov ebx, (PDPT - KERNEL_VMA + 3)
	mov dword [edx], ebx

	mov edx, (PML4T - KERNEL_VMA) ;mirror
	mov dword [edx], ebx

	mov edx, (PDPT - KERNEL_VMA)
	mov ebx, (PD - KERNEL_VMA + 3)
	mov dword [edx], ebx

	mov edx, (PML4T - KERNEL_VMA)
	mov cr3, edx

	;temporary solution
	;Map first 4MiB to hihger half
	mov edx, (PD - KERNEL_VMA)
	;0x83 is a D (huge page) flag, R/W flag and P flag bits set to 1
	mov dword [edx], (0x00000000 + 0x83)
	add edx, 8
	mov dword [edx], (0x00200000 + 0x83)

	popa
	ret