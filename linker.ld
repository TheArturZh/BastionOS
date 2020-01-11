OUTPUT_FORMAT("elf64-x86-64")

KERNEL_LMA = 0x0000000000100000; /* 1MiB */
KERNEL_VMA = 0xffff800000000000 + KERNEL_LMA; /* Higher Half */

ENTRY (_start)

SECTIONS
{
	. = KERNEL_LMA;
    kernel_start = .;

	.multiboot :
	{
		*(.multiboot2_header)
	}

	.text :
	{
		*(.text)
	}

    .rodata :
    {
        *(.rodata)
    }

    .data :
    {
        *(.data)
    }

    .bss :
    {
        *(COMMON)
        *(.bss)
    }

    kernel_end = .;

    /DISCARD/ :
    {
        *(.comment)
        *(.eh_frame)
    }
}