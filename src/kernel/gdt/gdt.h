#ifndef GDT_H_
#define GDT_H_

namespace gdt {
	namespace segments {
		const unsigned short code32 = 0x08;
		const unsigned short code64 = 0x10;
		const unsigned short data   = 0x18;
	}
}

#endif