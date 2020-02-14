%ifndef KERNEL_VMA

;Kernel is located at KERNEL_VMA + KERNEL_LMA
%define KERNEL_VMA 0xffffff0000000000
%define KERNEL_LMA 0x1000000
;Right after the ISA memory hole

%endif