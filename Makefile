#Emulators
QEMU  = qemu-system-x86_64 -d cpu_reset -monitor stdio -cdrom
BOCHS = ~/bochs-os/bin/bochs

#GCC or G++
CPP_COMP  = x86_64-elf-gcc
#NASM assembler
ASSEMBLER = nasm
LINKER    = x86_64-elf-gcc

#Compiler flags
CFLAGS  = -ffreestanding -O2 -mno-red-zone -fno-exceptions -fno-rtti
#Assembler flags
ASFLAGS = -f elf64 -w+orphan-labels
#Linker flags
LFLAGS  = -ffreestanding -O2 -nostdlib -lgcc

#should end with "/"
BUILD_PATH = ./build/

Objects = boot.o multiboot2_header.o kernel.o
image_name = os.iso

%.o: %.s
	$(ASSEMBLER) $(ASFLAGS) -o $(BUILD_PATH)$@ $<

%.o: %.cpp
	$(CPP_COMP) -c $< -o $(BUILD_PATH)$@ $(CFLAGS)

build_dir:
	mkdir $(BUILD_PATH) || true

kernel.bin: build_dir $(Objects)
	cd $(BUILD_PATH) && $(LINKER) $(LFLAGS) -n -T ../linker.ld -o $@ $(Objects)

image: kernel.bin
	cp -r ./image $(BUILD_PATH)image
	mv $(BUILD_PATH)kernel.bin $(BUILD_PATH)image/boot/kernel.bin
	grub-mkrescue -o $(BUILD_PATH)$(image_name) $(BUILD_PATH)image

clean:
	rm -rf $(BUILD_PATH)

bochs:
	$(BOCHS)

qemu:
	$(QEMU) $(BUILD_PATH)$(image_name)

run: image qemu
