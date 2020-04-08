# 1. Introduction
This project is based on the book "**IT EXPERT, 64비트 멀티코어 OS 원리와 구조**" published by "hanbit media"

* Author's official github repo : [link](https://github.com/kkamagui/mint64os-examples)

# 2. Develop Environments
We developed in the following environment. We write a script to build the environment, which can be easily built using the install script located at `scripts/install_<os_name>.sh`.

1. OS
	* Ubuntu 18.04

2. Required Package
	* binutils-2.34
	* gcc-9.2.0
	* gmp-6.2.0
	* mpfr-2.4
	* mpc-1.1.0
	* qemu-4.2.0
	* and so on...


3. Dockerhub
We also distributed the [images](https://hub.docker.com/layers/koreasecurity/dev/os_dev/images/sha256-bfcea4954aaa7ec4e88852d2870996aa6a6d5f9daebb914cc3ef4b3f538daebe?context=repo) needed for the experiment to dockerhub. You can simply download the configured image using the following command:

  https://hub.docker.com/layers/koreasecurity/dev/os_dev
    



# 3. Get Docker Engine
1. install Docker
	*  $ sudo apt-get update

	*  $ sudo apt-get install  apt-transport-https ca-certificates curl gnupg-agent software-properties-common

	*  $ curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

	*  $ sudo apt-key fingerprint 0EBFCD88
    
	*  $ sudo add-apt-repository  "deb [arch=amd64] https://download.docker.com/linux/ubuntu  $(lsb_release -cs) stable"

	*  $ sudo apt-get update

	*  $ sudo apt-get install docker-ce docker-ce-cli containerd.io

2. Run Develop Environments
	*  $ docker run -it koreasecurity/dev:os_dev

# 4. Auto Build
1. python3
	*  $ sudo apt-get install python3
2. requirements
	*  $ pip3 install -r requirements.txt
3. python3 Auto_Build_Prototype.py
