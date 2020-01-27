#include <stddef.h>
#include "vga.h"
#include "terminal.h"

unsigned char convert_color(unsigned char bgColor, unsigned char fgColor){
	return (char) (bgColor << 4) + fgColor;
}

size_t strlen(const char* str){
	size_t len = 0;
	while (str[len])
		len++;

	return len;
}



void Terminal::setCursorPos(unsigned short x, unsigned short y) {
	cursorX = x;
	cursorY = y;
}

void Terminal::setBackgroundColor(unsigned char color){
	bgColor = color;
}

void Terminal::setTextColor(unsigned char color){
	fgColor = color;
}

void Terminal::write(const char* str){
	unsigned char color = convert_color(bgColor, fgColor);
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

		unsigned char colors = convert_color(bgColor,fgColor);
		unsigned short last_line_pos = (vga::VGA_HEIGHT - 1) * vga::VGA_WIDTH;
		for (int character = 0; character < vga::VGA_WIDTH; character++){
			vga::put_character(colors, ' ', last_line_pos + character);
		}
	}
}

void Terminal::clear(){
	unsigned char colors = convert_color(bgColor,fgColor);
	unsigned int total_characters = vga::VGA_HEIGHT * vga::VGA_WIDTH;

	for (unsigned int pos = 0; pos < total_characters; pos++){
		vga::put_character(colors, ' ', pos);
	}

	return;
}