#include "../io/io.h"
#include "pic_icw.h"
#include "pic.h"

void pic::send_EOI(unsigned char irq){

	if(irq >= 8)
		outb(PIC_EOI,SLAVE_PIC);

	outb(PIC_EOI,MASTER_PIC);
}

void pic::remap(int offset_master, int offset_slave){
	//Backup masks
	unsigned char mask1, mask2;
	mask1 = inb(MASTER_PIC_DATA);
	mask2 = inb(SLAVE_PIC_DATA);

	//ICW1
	outb(ICW1_INIT | ICW1_IC4, MASTER_PIC_COMMAND);
	outb(ICW1_INIT | ICW1_IC4, SLAVE_PIC_COMMAND);

	//ICW2
	outb(offset_master, MASTER_PIC_DATA);
	outb(offset_slave, SLAVE_PIC_DATA);

	//ICW3
	//x86 architecture uses the IRQ2 to connect PICs
	//So we should set bit 2 in ICW3 for master PIC
	outb(0b100, MASTER_PIC_DATA);
	//and use binary notation of IRQ number as ICW3 for slave PIC
	outb(0b010, SLAVE_PIC_DATA);

	//ICW4
	//Tell the PICs that they should work in x86 mode
	outb(ICW4_uPM, MASTER_PIC_DATA);
	outb(ICW4_uPM, SLAVE_PIC_DATA);

	//Restore masks
	outb(mask1, MASTER_PIC_DATA);
	outb(mask2, SLAVE_PIC_DATA);

	return;
}

void pic::disable(unsigned short port){\
	//Mask out all interrupts
	outb(0xff, port);
}