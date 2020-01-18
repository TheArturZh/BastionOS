%include "gdt_defines.s"

section .rodata
align 16
gdt64:
	;NULL
    dq 0

	.code: equ $ - gdt64
	dw 0xffffffff ;Limit
    dw 0          ;Base
	db 0          ;Also base
	;Access byte
	db 0    | GDT_ACCESS_PRESENT | GDT_ACCESS_DESC_TYPE_DATA | GDT_ACCESS_EXECUTABLE | GDT_ACCESS_RW
	;Flags and limit(0x0F)
	db 0x0F | GDT_FLAG_GRANULARITY | GDT_FLAG_LONG_MODE
	db 0          ;Base again

	.data: equ $ - gdt64
	dw 0xffffffff ;Limit
    dw 0          ;Base
	db 0          ;Also base
	;Access byte
	db 0    | GDT_ACCESS_PRESENT | GDT_ACCESS_DESC_TYPE_DATA | GDT_ACCESS_RW
	;Flags and limit(0x0F)
	db 0x0F
	db 0          ;Base again

    .pointer:
    dw .pointer - gdt64 - 1
    dq gdt64