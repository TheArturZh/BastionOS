#include <stddef.h>
#include "vga.h"
#include "terminal.h"

//TODO: It isn't supposed to be here, should be moved
static size_t strlen(const char* str){
	size_t len = 0;
	while (str[len])
		len++;

	return len;
}



void Terminal::setCursorPos(unsigned short x, unsigned short y) {
	cursorX = x;
	cursorY = y;
}

void Terminal::setBackgroundColor(vga::COLOR bg_color){
	color = color & 0x0F;
	color += (char)bg_color << 4;
}

void Terminal::setTextColor(vga::COLOR fg_color){
	color = color & 0xF0;
	color += (char)fg_color;
}

void Terminal::write(const char* str){
	size_t len = strlen(str);
	for(size_t i = 0; i < len; i++){
		if(str[i] == '\n'){
			if(cursorY >= 35){
				scroll(1);
			}else{
				cursorY++;
			}
			cursorX = 0;
		}else{
			vga::put_character(color, str[i], cursorX + cursorY * 80);
			cursorX++;
			if(cursorX >= 80){
				if(cursorY >= 35){
					scroll(1);
				}else{
					cursorY++;
				}
				cursorX = 0;
			}
		}
	}

	return;
}

void Terminal::scroll(int lines){
	for(int done = 0; done < lines; done++){
		vga::scroll(1);
		unsigned short last_line_pos = (vga::VGA_HEIGHT - 1) * vga::VGA_WIDTH;
		for (int character = 0; character < vga::VGA_WIDTH; character++){
			vga::put_character(color, ' ', last_line_pos + character);
		}
	}
}

void Terminal::clear(){
	unsigned int total_characters = vga::VGA_HEIGHT * vga::VGA_WIDTH;

	for (unsigned int pos = 0; pos < total_characters; pos++){
		vga::put_character(color, ' ', pos);
	}

	return;
}