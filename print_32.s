[bits 32]

VID_MEM_ADDR:
	dd 0xb8000

;VGA: text, 80x25, 16 colors

CURSOR_POS_LINE: ;line*160
	dd 0

CURSOR_POS_OFFSET: ;Position of a cursor on the line
;Max 158, should be reset on 160
	dd 0

;Writes the string
;[INPUT:]
;EBX contains the base of string. String must be terminated by 0.
;[USED:]
;EDX contains the position of cursour (pointer to vga memory)
;ECX contains an offset of cursour (to save later)
;EBX contains an address of character
;[OUTPUT:]
;Graphical
write_32_s:
	pusha
	pushfd
.body:
	mov ecx, [CURSOR_POS_OFFSET]
	mov edx, [CURSOR_POS_LINE]
	add edx, ecx
	add edx, [VID_MEM_ADDR]
	mov ah, 0x07 ;Light grey on black
.loop:
	mov al, [ebx]
	cmp al, 0
	je .end

	mov [edx], ax
	add edx, 2
	add ebx, 1
	add ecx, 2

	cmp ecx, 160
	jb .loop
	add dword [CURSOR_POS_LINE], 160
	xor ecx, ecx

	jmp .loop
.end:
	mov dword [CURSOR_POS_OFFSET], ecx
	popfd
	popa
	ret

;Moves the cursor to next line & resets offset
;[INPUT:] None
;[OUTPUT:] Graphical
newline_32:
	add dword [CURSOR_POS_LINE], 160
	mov dword [CURSOR_POS_OFFSET], 0

;Moves the cursor to next line & resets offset if cursor offset is > 0
;[INPUT:] None
;[OUTPUT:] Graphical
cond_newline_32:
	pushfd
	cmp dword [CURSOR_POS_OFFSET], 0
	je .end
	call newline_32
.end:
	popfd
	ret

;Writes the string and moves cursor to next line
;[INPUT:]
;EBX contains the base of string. String must be terminated by 0.
;[OUTPUT:]
;Graphical
print_32_s:
	call write_32_s
	call cond_newline_32
	ret

;Writes the binary value contained in EBX on screen
;[INPUT:]
;EBX contains the value that should be written on screen
;[OUTPUT:]
;Graphical
write_bin_32_s:
	pusha
	pushfd

	mov ah, 0x07 ;Light grey on black
	xor ch, ch ;iteration counter

	;Put the VGA memory address in EDX
	mov edx, [CURSOR_POS_OFFSET]
	mov cl, dl
	add edx, [CURSOR_POS_LINE]
	add edx, [VID_MEM_ADDR]
.loop:
	cmp ch, 32
	je .end

	;Put character in AL
	rol ebx, 1
	mov al, bl
	and al, 1
	add al, 0x30 ;Add ASCII code of character "0"

	;Put character in VGA memory
	mov [edx], ax
	add edx, 2

	inc ch

	;Check if next line is reached
	add cl, 2
	cmp cl, 160
	jb .loop
	add dword [CURSOR_POS_LINE], 160
	xor cl, cl

	jmp .loop
.end:
	;Save cursor offset
	xor ebx, ebx
	mov bl,cl
	mov dword [CURSOR_POS_OFFSET], ebx

	popfd
	popa
	ret

;Writes decimal value contained in EBX on screen
;[INPUT:]
;EBX contains the value that should be written on screen
;[OUTPUT:]
;Graphical
write_hex_32_s:
	pusha
	pushfd

	mov ah, 0x07 ;Light grey on black
	xor ch, ch ;iteration counter

	;Put the VGA memory address in EDX
	mov edx, [CURSOR_POS_OFFSET]
	mov cl, dl
	add edx, [CURSOR_POS_LINE]
	add edx, [VID_MEM_ADDR]
.loop:
	cmp ch, 8
	je .end

	rol ebx, 4
	mov al, bl
	and al, 0x0f
	add al, 0x30 ;Add ASCII code of character "0"

	cmp al, 0x39
	jle .put_char
	add al, 7

.put_char:
	mov [edx], ax
	add edx, 2

	inc ch

	;Check if next line is reached
	add cl, 2
	cmp cl, 160
	jb .loop
	add dword [CURSOR_POS_LINE], 160
	xor cl, cl

	jmp .loop
.end:
	popfd
	popa
	ret

write_hex_buffer:
	dq 0

;Changes the cursor position
;[INPUT:]
;EAX - Line (Y)
;EBX - Offest (X)
set_cursor_pos_32:
	pusha
	pushfd

	mov [CURSOR_POS_OFFSET], ebx
	mov ebx, 160
	mul ebx
	mov [CURSOR_POS_LINE], eax

	popfd
	popa
	ret