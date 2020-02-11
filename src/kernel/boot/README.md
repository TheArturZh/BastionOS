**Warning:**  
Reusing functions defined in these files in other parts of project is forbidden.  
</br>
This part of a kernel prepares the machine to run a kernel in a 64-bit mode.  
**It must:**  

* Make sure that the CPU supports long-mode.
* Set up the GDT with data segment, 32bit code segment and 64bit code segment.
* Switch from GDT set up by multiboot2 loader to it's own GDT.
* Set up paging, where:
    * 1st MiB of memory is:
	   * Identity-mapped
	   * Mapped to higher half
	* Whole kernel is mapped to a higher half with the same offset as in the physical memory,  
	leaving space for mapping a 1st MiB of physical memory to higher half.
* Enable long-mode and paging.
* Jump to a 64-bit code segment and jump to higher half.
* Start execution of a higher-level kernel.
