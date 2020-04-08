#!/usr/bin/env python3
# -*- coding: utf-8 -*- 

## Contributors to development
# Sang-Hoon Choi, csh0052@gmail.com
# Sung-Kyung Kim, jotun9935@gmail.com
#
import docker
import subprocess,shutil
from termcolor import colored
import os

def status_check(data):
    status = data['State']['Status']
    if status == 'exited':
        print(colored("[INFO] DEV_OS start", "yellow"))
        subprocess.check_output('docker start DEV_OS', shell=True)


def source_copy(src):
    try:
        source_dir=get_dir+'/root/'
        cmd = 'cp -R ' + os.getcwd() + ' ' + str(source_dir)
        subprocess.check_output(cmd, shell=True)
        print(colored("[INFO] Source Copy From .Operating-System", "yellow"))

    except Exception as e:
        print(colored(e, "red"))
        print(colored("ERROR","yellow"))

def copy_img(src):
    try:
        shutil.copyfile(src+'Disk.img','Disk.img')
        print(colored("[INFO] Completed", "yellow"))
        print(colored("U can try: qemu-system-x86_64 -m 64 -drive format=raw,file=Disk.img,index=0,if=floppy", "yellow"))

    except:
        print(colored("ERROR","yellow"))


def get_log(log_file):
    log_f=open(log_file,'r')
    log=''
    while(True):
        buf=str(log_f.read(1024))

        if buf == '':
            log_f.close()
            break
        log+=buf
    print(colored(log,"yellow"))

dev_container_name="DEV_OS"
cli = docker.Client(base_url='unix://var/run/docker.sock')

try: #개발환경 체크
    data=cli.inspect_container(dev_container_name)
    status_check(data)


except:
    subprocess.check_output('docker run -td --name DEV_OS koreasecurity/dev:os_dev',shell=True) #컨테이너 스탑


option=input("1. Make, 2. ?? , 3..").strip() #향후 확장용

if str(option) is '1':
    os.system('rm Disk.img')
    data = cli.inspect_container(dev_container_name)
    get_dir = data['GraphDriver']['Data']['MergedDir']
    source_copy(get_dir)
    subprocess.check_output('docker exec -td '+str(dev_container_name)+' /bin/bash -c \"make -C /root/Operating-System > /root/Operating-System/make.log\"', shell=True)  # 컨테이너 스탑

    src_dir= str(get_dir + '/root/Operating-System/')
    get_log(src_dir+'make.log')
    copy_img(src_dir)
