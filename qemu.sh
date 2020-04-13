#!/bin/bash

qemu-system-x86_64 -m 64 -drive format=raw,file=Disk.img,index=0,if=floppy -device floppy,drive-type=144
