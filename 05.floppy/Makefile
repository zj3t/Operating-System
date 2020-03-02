BootLoader:
	make -C BootLoader

Kernel32:
	make -C Kernel32

Disk.img:
	cat BootLoader/BootLoader.bin Kernel32/VirtualOS.bin > Disk.img
clean:
	make -C BootLoader clean
	make -C Kernel32. clean
	rm -f Disk.img	
