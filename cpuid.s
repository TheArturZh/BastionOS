[bits 32]

;Checks if CPUID is available
;[INPUT:] None
;[USED:]
;EBX contains the modified copy of EFLAGS
;EAX contains the copy of modified EFLAGS
;[OUTPUT:]
;EAX - will be 0 if CPUID is available
cpuid_check_availability:
	push ebx
	pushfd

	;Invert ID Flag
	pushfd
	pop ebx
	xor ebx, 1 << 21 ;invert bit 21
	push ebx

	;Try to change this bit in EFLAGS
	popfd
	pushfd
	pop eax ;get the result

	xor eax, ebx ;should be equal if CPUID is available

	popfd
	pop ebx
	ret

;Checks if long mode is available
;[INPUT:] None
;[OUTPUT:] EAX - 1 if available, 0 if not
cpuid_check_long_mode:
	pusha

	;Check if extended function is available.
	;If it isn't, the long mode is also not.
	mov eax, 0x80000000
	cpuid
	cmp eax, 0x80000001
	jb .unavailable

	mov eax, 0x80000001
	cpuid
	test edx, 1 << 29
	jz .unavailable

.available:
	popa
	mov eax, 1
	ret

.unavailable:
	popa
	mov eax, 0
	ret