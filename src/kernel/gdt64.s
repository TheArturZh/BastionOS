%include "./src/kernel/gdt_defines.s"

section .data
align 16
gdt64:
	;NULL
	dq 0

	.code32: equ $ - gdt64
	dw 0xffffffff ;Limit
	dw 0          ;Base
	db 0          ;Base
	;Access byte
	db 0    | GDT_ACCESS_PRESENT | GDT_ACCESS_TYPE_DATA_CODE | GDT_ACCESS_EXECUTABLE | GDT_ACCESS_RW
	;Flags and limit(0x0F)
	db 0x0F | GDT_FLAG_GRANULARITY | GDT_FLAG_SIZE
	db 0          ;Base

	.code64: equ $ - gdt64
	dw 0xffffffff ;Limit
	dw 0          ;Base
	db 0          ;Base
	;Access byte
	db 0    | GDT_ACCESS_PRESENT | GDT_ACCESS_TYPE_DATA_CODE | GDT_ACCESS_EXECUTABLE | GDT_ACCESS_RW
	;Flags and limit(0x0F)
	db 0x0F | GDT_FLAG_GRANULARITY | GDT_FLAG_LONG_MODE
	db 0          ;Base

	.data: equ $ - gdt64
	dw 0xffffffff ;Limit
	dw 0          ;Base
	db 0          ;Base
	;Access byte
	db 0    | GDT_ACCESS_PRESENT | GDT_ACCESS_TYPE_DATA_CODE | GDT_ACCESS_RW
	;Flags and limit(0x0F)
	db 0x0F | GDT_FLAG_GRANULARITY
	db 0          ;Base

	.pointer:
	dw .pointer - gdt64 - 1
	dq gdt64
