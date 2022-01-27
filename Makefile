# https://wiki.osdev.org/GNU-EFI
#
GNU_EFI_DIR=../gnu-efi

.PHONY: all
all: fat.img

fat.img: main.c
	gcc -I$(GNU_EFI_DIR)/inc -fpic -ffreestanding -fno-stack-protector -fno-stack-check -fshort-wchar -mno-red-zone -maccumulate-outgoing-args -c main.c -o main.o
	ld -shared -Bsymbolic -L$(GNU_EFI_DIR)/x86_64/lib -L$(GNU_EFI_DIR)/x86_64/gnuefi -T$(GNU_EFI_DIR)/gnuefi/elf_x86_64_efi.lds $(GNU_EFI_DIR)/x86_64/gnuefi/crt0-efi-x86_64.o main.o -o main.so -lgnuefi -lefi
	objcopy -j .text -j .sdata -j .data -j .dynamic -j .dynsym  -j .rel -j .rela -j .rel.* -j .rela.* -j .reloc --target efi-app-x86_64 --subsystem=10 main.so main.efi

	rm -f fat.img
	dd if=/dev/zero of=fat.img bs=1k count=1440 2>&1
	mformat -i fat.img -f 1440 ::
	mmd -i fat.img ::/EFI
	mmd -i fat.img ::/EFI/BOOT
	mcopy -i fat.img main.efi ::/EFI/BOOT/BOOTX64.EFI

.PHONY: run
run:
	qemu-system-x86_64 -bios /usr/share/qemu/OVMF.fd -drive file=fat.img,format=raw &


.PHONY: clean
clean:
	rm -f fat.img main.o main.so main.efi
