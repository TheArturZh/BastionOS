%include "./src/kernel/init_defines.s"

section .bss
align 4096

PML4T:
	resb 4096
PDPT:
	resb 4096
PD:
	resb 4096
PT:
	resb 4096

PDPT_Lower:
	resb 4096
PD_Lower:
	resb 4096
PT_Lower:
	resb 4096

section .text
bits 32

setup_paging:
	pusha

	;Higher half (VMA 0xffffff0000000000)
	mov edx, (PML4T - KERNEL_VMA + (510 * 8)) ;Physical address of 510th entry in PML4T
	mov ebx, (PDPT - KERNEL_VMA + 3)
	mov dword [edx], ebx

	;Link PD to PDPT
	mov edx, (PDPT - KERNEL_VMA)
	mov ebx, (PD - KERNEL_VMA + 3)
	mov dword [edx], ebx

	;Link PDPT as entry 0 (VMA 0x0000000000000000)
	mov edx, (PML4T - KERNEL_VMA)
	mov ebx, (PDPT - KERNEL_VMA + 3)
	mov dword [edx], ebx

	;Map first 2MiB
	;0x83 is a PS (huge page) flag, R/W flag and P flag bits set to 1
	mov edx, (PD - KERNEL_VMA)
	mov dword [edx], (0x83)

	call map_kernel

	mov edx, (PML4T - KERNEL_VMA)
	mov cr3, edx

	popa
	ret

extern _kernel_start
extern _kernel_end

map_kernel:
	;Calculate the size of kernel
	mov eax, _kernel_end
	sub eax, _kernel_start

	;Calculate the amount of 2MiB pages
	mov edx, 0
	mov ebx, 0x200000
	div ebx
	;At this point:
	;eax is the required amount of 2MiB pages
	;edx is the remainder, will be used to calculate an amount of 4KiB pages
	;ebx and ecx are free to be used

	push edx ;"free" edx

	;Mapping with 2MiB pages
	mov edx, 0x200000
	mov ecx, 0
	mov ebx, (PD - KERNEL_VMA + 8) ; + 8 because first (0) entry is already occupied
	.huge_pages_loop:
		cmp ecx, eax
		je .hpl_end

		push edx
		or edx, 0x83
		mov dword [ebx], edx
		pop edx

		add ebx, 8
		add edx, 0x200000
		inc ecx
		jmp .huge_pages_loop
	.hpl_end:

	pop eax

	;Finally link the PT
	mov dword [ebx], (PT - KERNEL_VMA + 3)

	push edx ;save the linear address of last 2MiB page

	;Calculate the amount of 4KiB pages
	mov edx, 0
	mov ebx, 0x1000
	div ebx

	;Add an extra page if the amount of unmapped kernel space left is >0
	cmp edx, 0
	je .skip_add_extra_page
	inc eax
	.skip_add_extra_page:

	;Mapping with 4KiB pages
	mov ebx, (PT - KERNEL_VMA)
	pop edx
	or edx, 3
	mov ecx, 0
	.regular_pages_loop:
		cmp ecx,eax
		je .rpl_end

		mov dword [ebx], edx

		add ebx, 8
		add edx, 0x1000
		inc ecx
		jmp .regular_pages_loop
	.rpl_end:

	ret

section .text
bits 64

;This function removes pages with kernel from lower half,
;leaving only first 1MiB identity-mapped.
remap_lower:

	mov rax, PDPT_Lower
	;we still have to operate with physical addresses
	mov ebx, PD_Lower - KERNEL_VMA + 3
	mov dword [rax], ebx

	mov rax, PD_Lower
	mov ebx, PT_Lower - KERNEL_VMA + 3
	mov dword [rax], ebx

	mov rax, PT_Lower ;entry address
	mov edx, 3        ;physical address + P flag + R/W flag
	mov bx, 256       ;pages to map
	mov cx, 0         ;pages mapped

	.PT_fill_loop:
		cmp cx, bx
		je .PT_fill_loop_end

		mov dword [eax], edx

		add rax, 8
		add edx, 0x1000
		inc cx
		jmp .PT_fill_loop
	.PT_fill_loop_end:

	;replace first entry (replace PDPT with PDPT_Lower)
	mov rax, PML4T
	mov ebx, PDPT_Lower - KERNEL_VMA + 3
	mov dword [rax], ebx

	ret
