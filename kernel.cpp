#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>

uint16_t colors = 0x0F << 8;
uint16_t* tty_buffer = (uint16_t*) 0x0b8000;

extern "C" void kmain(void){
	//another one test
	tty_buffer[0] = colors + 'X';
}