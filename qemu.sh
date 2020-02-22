#!/bin/bash

qemu -L . -m 64 -fda ./Disk.img -localtime -M pc
