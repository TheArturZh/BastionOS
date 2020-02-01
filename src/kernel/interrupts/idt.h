#ifndef IDT_WRAPPER_H_
#define IDT_WRAPPER_H_

#include <stdint.h>

namespace idt {

struct IDT_entry
{
	uint16_t offset_lower;
	uint16_t selector;
	uint8_t  IST;
	uint8_t  type_attributes;
	uint16_t offset_middle;
	uint32_t offset_high;
	uint32_t zero;
};

extern "C" IDT_entry IDT[256];
extern "C" void load_idt();

void setup_exceptions();

}

#endif