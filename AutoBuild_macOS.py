##
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

dev_container_name="DEV_OS"
img_name="koreasecurity/dev"
img_tag="os_dev"
output_img="Disk.img"
output_log="make.log"
container_project_root="/root/Operating-System"

def status_check(data):
    status = data['State']['Status']
    if status == 'exited':
        print(colored("[INFO] DEV_OS start", "yellow"))
        subprocess.check_output('docker start DEV_OS', shell=True)


def get_container_name(name):
    cmd = "docker ps -a | grep "+ name +" | awk {'print $1'}"
    task = subprocess.Popen(cmd, shell=True, stdout=subprocess.PIPE)
    data = task.stdout.read().decode("utf-8").split('\n')[0]
    
    print(colored("[INFO] container id : {}".format(data), "red"))
    return data

cli = docker.Client(base_url='unix://var/run/docker.sock')

try: #개발환경 체크
    data=cli.inspect_container(dev_container_name)
    status_check(data)


except:
    subprocess.check_output('docker run -td --name {} {}:{}'.format(dev_container_name, img_name, img_tag),shell=True) #컨테이너 스탑

container_name = get_container_name(img_tag)
os.system('rm {}'.format(output_img))
data = cli.inspect_container(dev_container_name)

cmd = 'docker cp {} {}:/root'.format(os.getcwd(), container_name)
print(colored("[INFO] run command : {}".format(cmd), "yellow"))
os.system(cmd)

cmd = 'docker exec -td {} /bin/bash -c \"make clean {}\"'.format(dev_container_name, container_project_root)
print(colored("[INFO] run command : {}".format(cmd), "yellow"))

subprocess.check_output(cmd, shell=True)
cmd = 'docker exec -td {} /bin/bash -c \"make -C {} > {}/{}\"'.format(dev_container_name, container_project_root, container_project_root, output_log)
print(colored("[INFO] run command : {}".format(cmd), "yellow"))
subprocess.check_output(cmd, shell=True)  # 컨테이너 스탑

cmd = 'docker cp {}:/root/Operating-System/make.log .'.format(container_name)
print(colored("[INFO] run command : {}".format(cmd), "yellow"))
os.system(cmd)

cmd = 'docker cp {}:/root/Operating-System/Disk.img .'.format(container_name)
print(colored("[INFO] run command : {}".format(cmd), "yellow"))
os.system(cmd)

print(colored("[INFO] Build Done. U can try: ", "red"))
print("qemu -drive format=raw,file=./Disk.img,index=0,if=floppy")

