#ifndef GDT_H_
#define GDT_H_

namespace gdt {
	namespace segments {
		unsigned short code32 = 0x08;
		unsigned short code64 = 0x10;
		unsigned short data   = 0x18;
	}
}

#endif