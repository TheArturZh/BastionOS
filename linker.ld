OUTPUT_FORMAT("elf64-x86-64")

KERNEL_LMA      = 0x0000000000100000; /* 1MiB */
HIGHER_HALF_LOC = 0xffffff0000000000;
KERNEL_VMA      = HIGHER_HALF_LOC + KERNEL_LMA; /* Higher Half */

ENTRY (_start)

SECTIONS
{
	. = KERNEL_VMA;
	_kernel_start = . - KERNEL_VMA;

	.multiboot : AT(ADDR(.multiboot) - HIGHER_HALF_LOC)
	{
		*(.multiboot2_header)
	}

	.text : AT(ADDR(.text) - HIGHER_HALF_LOC)
	{
		*(.text)
	}

	.rodata : AT(ADDR(.rodata) - HIGHER_HALF_LOC)
	{
		*(.rodata)
	}

	.data : AT(ADDR(.data) - HIGHER_HALF_LOC)
	{
		*(.data)
	}

	.bss : AT(ADDR(.bss) - HIGHER_HALF_LOC)
	{
		*(COMMON)
		*(.bss)
	}

	_kernel_end = . - KERNEL_VMA;

	/DISCARD/ :
	{
		*(.comment)
		*(.eh_frame)
	}
}