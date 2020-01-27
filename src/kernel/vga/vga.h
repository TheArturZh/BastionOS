#ifndef VGA_H_
#define VGA_H_

namespace vga {

const int VGA_WIDTH = 80;
const int VGA_HEIGHT = 25;

enum class COLOR : unsigned char {
	BLACK = 0,
	BLUE = 1,
	GREEN = 2,
	CYAN = 3,
	RED = 4,
	MAGENTA = 5,
	BROWN = 6,
	LIGHT_GREY = 7,
	DARK_GREY = 8,
	LIGHT_BLUE = 9,
	LIGHT_GREEN = 10,
	LIGHT_CYAN = 11,
	LIGHT_RED = 12,
	LIGHT_MAGENTA = 13,
	LIGHT_BROWN = 14,
	WHITE = 15,
};

void put_character(unsigned char color, unsigned char character, unsigned short pos);
void scroll(unsigned int lines);
}

#endif