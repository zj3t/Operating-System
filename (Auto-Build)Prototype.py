#!/usr/bin/env python3
# -*- coding: utf-8 -*- 

## Contributors to development
# Sang-Hoon Choi, csh0052@gmail.com
#
import docker
import subprocess,shutil
import os

def copy_img(src):
    try:
        shutil.copyfile(src+'Disk.img','Disk.img')
        print("[Completed] Disk copy\n\n")
        print("U can try: qemu-system-x86_64 -m 64 -drive format=raw,file=Disk.img,index=0,if=floppy")
    except:
        print("ERROR")
def get_log(log_file):
    log_f=open(log_file,'r')
    log=''
    while(True):
        buf=str(log_f.read(1024))

        if buf == '':
            log_f.close()
            break
        log+=buf
    print(log)

dev_container_name="DEV_OS"
cli = docker.Client(base_url='unix://var/run/docker.sock')

try: #개발환경 체크
    data=cli.inspect_container(dev_container_name)
except:
    subprocess.check_output('docker run -td -v '+ os.getcwd() +':/root/Operating-System --name DEV_OS koreasecurity/dev:os_dev',shell=True) #컨테이너 스탑

option=str(input("1. Make, 2. ?? , 3..")).strip() #향후 확장용

if str(option) is '1':
    subprocess.check_output('docker exec -td '+str(dev_container_name)+' /bin/bash -c \"make -C /root/Operating-System > /root/Operating-System/make.log\"', shell=True)  # 컨테이너 스탑
    data = cli.inspect_container(dev_container_name)
    get_dir = data['GraphDriver']['Data']['MergedDir']
    src_dir= str(get_dir + '/root/Operating-System/')
    get_log(src_dir+'make.log')
    copy_img(src_dir)


