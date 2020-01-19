MULTIBOOT2_MAGIC equ 0xE85250D6
MULTIBOOT2_ARCH  equ 0x00000000 ;i386
MULTIBOOT2_HEADER_SIZE equ (multiboot2_header_start - multiboot2_header_end)
MULTIBOOT2_CHECKSUM    equ -(MULTIBOOT2_MAGIC + MULTIBOOT2_ARCH + MULTIBOOT2_HEADER_SIZE)

section .multiboot
align 8
bits 32

multiboot2_header_start:
	dd MULTIBOOT2_MAGIC
	dd MULTIBOOT2_ARCH
	dd MULTIBOOT2_HEADER_SIZE
	dd MULTIBOOT2_CHECKSUM

	;Terminate tag
	dw 0x0
	dw 0x0
	dd 0x8
multiboot2_header_end: