#ifndef PIC_H_
#define PIC_H_

#define MASTER_PIC 0x20
#define SLAVE_PIC  0xA0

#define MASTER_PIC_COMMAND MASTER_PIC
#define MASTER_PIC_DATA    (MASTER_PIC+1)

#define SLAVE_PIC_COMMAND  SLAVE_PIC
#define SLAVE_PIC_DATA     (SLAVE_PIC+1)

#define PIC_EOI 0x20


namespace pic {

void send_EOI(unsigned char irq);

void remap(int offset_master, int offset_slave);

void disable(unsigned short port);
}

#endif