#include "idt.h"
#include "../gdt/gdt.h"

extern "C" void isr_divide_by_zero();
extern "C" void isr_double_fault();
extern "C" void isr_gp_fault();
extern "C" void isr_page_fault();

static idt::IDT_entry exception_entry(uintptr_t isr_ptr){
	return idt::IDT_entry {
		(uint16_t) isr_ptr,
		gdt::segments::code64, //64bit code segment selector
		0,
		0b10001110, //Present flag + 32bit interrupt gate type
		(uint16_t) (isr_ptr >> 16),
		(uint32_t) (isr_ptr >> 32),
		0
	};
}

void idt::setup_exceptions(){

	IDT[0]  = exception_entry((uintptr_t) isr_divide_by_zero);
	IDT[8]  = exception_entry((uintptr_t) isr_double_fault);
	IDT[13] = exception_entry((uintptr_t) isr_gp_fault);
	IDT[14] = exception_entry((uintptr_t) isr_page_fault);

	return;
}