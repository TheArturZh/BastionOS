section .rodata
align 16
gdt64:
	;NULL
    dq 0
	.code: equ $ - gdt64
    dq 0x0020980000000000
    .pointer:
    dw .pointer - gdt64 - 1
    dq gdt64