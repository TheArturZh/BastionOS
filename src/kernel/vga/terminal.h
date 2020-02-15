#ifndef TERMINAL_H_
#define TERMINAL_H_

class Terminal {
	private:
		unsigned short cursorX = 0;
		unsigned short cursorY = 0;
		unsigned char color = 0x0F;

	public:
		void setCursorPos(unsigned short x, unsigned short y);
		void setBackgroundColor(vga::COLOR color);
		void setTextColor(vga::COLOR color);
		void write(const char* str);
		void scroll(int lines);
		void clear();
};

#endif