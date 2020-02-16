#include <stdint.h>
#include "vga.h"

const uintptr_t VGA_MEM_ADDR = 0x0b8000;

void vga::put_character(unsigned char color, unsigned char character, unsigned short pos){
	if(character == 0)
		return;

	uint16_t* pos_addr = (uint16_t*)(VGA_MEM_ADDR + pos * 2);
	pos_addr[0] = (color << 8) + character;
	return;
}

void vga::scroll(unsigned int lines){
	for(unsigned int done = 0; done < lines; done++){
		uint16_t* pos = (uint16_t*) VGA_MEM_ADDR;
		int char_to_move = VGA_WIDTH * (VGA_HEIGHT - 1);

		for (int char_ = 0; char_ < char_to_move; char_++){
			pos[char_] = pos[char_ + VGA_WIDTH];
		}

		pos += char_to_move;
	}

	return;
}