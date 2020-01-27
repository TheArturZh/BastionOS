#Emulators
QEMU  = qemu-system-x86_64 -monitor stdio -cdrom
BOCHS = ~/bochs-os/bin/bochs

#GCC or G++
CXX = x86_64-elf-gcc
#NASM assembler
ASSEMBLER = nasm
LINKER    = x86_64-elf-gcc

#Compiler flags
CXXFLAGS  = -ffreestanding -O2 -mno-red-zone -fno-exceptions -fno-rtti -mcmodel=large
#Assembler flags
ASFLAGS = -f elf64 -w+orphan-labels
#Linker flags
LFLAGS  = -ffreestanding -O2 -nostdlib -lgcc -mcmodel=large

SRC_DIRS_ROOT = ./src
SRC_FILES = $(wildcard $(SRC_DIRS_ROOT)/*) \
            $(wildcard $(SRC_DIRS_ROOT)/*/*) \
            $(wildcard $(SRC_DIRS_ROOT)/*/*/*)
SRC_DIRS = $(dir $(SRC_FILES))

Objects = boot.o vga.o terminal.o kernel.o multiboot2_header.o

#<BUILD DIRECTORIES>#
#should end with "/"
BUILD_PATH = ./build/
KERNEL_BUILD_PATH = $(BUILD_PATH)kernel/

image_name = os.iso
image = $(BUILD_PATH)$(image_name)

VPATH = $(SRC_DIRS)

%.o: $(notdir %.s)
	$(ASSEMBLER) $(ASFLAGS) -o $(KERNEL_BUILD_PATH)$@ $<

%.o: $(notdir %.cpp)
	$(CXX) -c $< -o $(KERNEL_BUILD_PATH)$@ $(CXXFLAGS)

build_dir:
	mkdir $(BUILD_PATH) || true
	mkdir $(KERNEL_BUILD_PATH) || true

$(KERNEL_BUILD_PATH)kernel.bin: build_dir $(Objects)
	cd $(KERNEL_BUILD_PATH) && $(LINKER) $(LFLAGS) -n -T ../../src/kernel/linker.ld -o kernel.bin $(Objects)

$(image): $(KERNEL_BUILD_PATH)kernel.bin
	mkdir $(BUILD_PATH)image || true
	mkdir $(BUILD_PATH)image/boot || true
	cp -r ./boot/grub $(BUILD_PATH)image/boot/
	cp $(KERNEL_BUILD_PATH)kernel.bin $(BUILD_PATH)image/boot/kernel.bin
	grub-mkrescue -o $(image) $(BUILD_PATH)image

clean:
	rm -rf $(BUILD_PATH)

bochs: $(image)
	$(BOCHS)

qemu: $(image)
	$(QEMU) $(image)

run: qemu
