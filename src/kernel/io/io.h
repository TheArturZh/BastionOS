#ifndef IO_H_
#define IO_H_

inline void outb(unsigned char value, unsigned short port){
	asm volatile( "out %1, %0" : : "a"(value), "Nd"(port) );
}

inline unsigned char inb(unsigned short port){
	unsigned char result;
	asm volatile( "in %0, %1" : "=a"(result) : "Nd"(port) );
	return result;
}

#endif