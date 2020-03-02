BootLoader:
	make -C BootLoader

Kernel32:
	make -C Kernel32

Disk.img: BootLoader/BootLoader.bin Kernel32/Kernel32.bin
	cat $^ > Disk.img
clean:
	make -C BootLoader clean
	make -C Kernel32. clean
	rm -f Disk.img	
