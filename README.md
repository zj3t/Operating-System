# 1. Introduction
This project is based on the book "**IT EXPERT, 64비트 멀티코어 OS 원리와 구조**" published by "hanbit media"

* Author's official github repo : [link](https://github.com/kkamagui/mint64os-examples)

# 2. Develop Environments
We developed in the following environment. We created [docker images](https://hub.docker.com/layers/koreasecurity/dev/os_dev/images/sha256-bfcea4954aaa7ec4e88852d2870996aa6a6d5f9daebb914cc3ef4b3f538daebe?context=repo) that consist of the following environments. Also we have created a build script(`Auto_Build_Prototype.py`) to automatically build the source code in the environment.

1. OS(Tested)
	* Ubuntu 18.04, Ubuntu 16.04

2. Required Package
	* binutils-2.34
	* gcc-9.2.0
	* gmp-6.2.0
	* mpfr-2.4
	* mpc-1.1.0
	* qemu-4.2.0
	* and so on...


# 3. Get related package(Docker Engine, qemu)
1. install Docker

```sh
sudo apt-get update
sudo apt-get install  apt-transport-https ca-certificates curl gnupg-agent software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88
sudo add-apt-repository  "deb [arch=amd64] https://download.docker.com/linux/ubuntu  $(lsb_release -cs) stable"
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io

```

2. Run Develop Environments

```sh
docker run -it koreasecurity/dev:os_dev
```
s
3. install autobuild requirements

```sh
sudo apt-get install python3
pip3 install -r requirements.txt
```

4. install qemu

```sh
sudo apt-get install qemu
sudo ln -sv qemu-system-`uname -m` /usr/bin/qemu
```

# 4. Auto Build

```
python3 Auto_Build_Prototype.py
```

# 5. RUN OS with the built image

```
./qemu.sh
```

