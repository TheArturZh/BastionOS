#ifndef TERMINAL_H_
#define TERMINAL_H_

class Terminal {
	private:
		unsigned short cursorX = 0;
		unsigned short cursorY = 0;
		unsigned char  bgColor = 0x0;
		unsigned char  fgColor = 0xF;

	public:
		void setCursorPos(unsigned short x, unsigned short y);
		void setBackgroundColor(unsigned char color);
		void setTextColor(unsigned char color);
		void write(const char* str);
		void scroll(int lines);
		void clear();
};

#endif