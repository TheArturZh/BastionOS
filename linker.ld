OUTPUT_FORMAT("elf64-x86-64")

KERNEL_LMA = 0x0000000000100000; /* 1MiB */
KERNEL_VMA = 0xffffff0000000000 + KERNEL_LMA; /* Higher Half */
VOFF = 0xffffff0000000000;

ENTRY (_start)

SECTIONS
{
	. = KERNEL_VMA;
    _kernel_start = .;

	.multiboot : AT(ADDR(.multiboot) - VOFF)
	{
		*(.multiboot2_header)
	}

	.text : AT(ADDR(.text) - VOFF)
	{
		*(.text)
	}

    .rodata : AT(ADDR(.rodata) - VOFF)
    {
        *(.rodata)
    }

    .data : AT(ADDR(.data) - VOFF)
    {
        *(.data)
    }

    .bss : AT(ADDR(.bss) - VOFF)
    {
        *(COMMON)
        *(.bss)
    }

    _kernel_end = .;

    /DISCARD/ :
    {
        *(.comment)
        *(.eh_frame)
    }
}