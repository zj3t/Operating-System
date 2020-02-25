# 1. Introduction
This project is based on the book "**IT EXPERT, 64비트 멀티코어 OS 원리와 구조**" published by "hanbit media"

* Author's official github repo : [link](https://github.com/kkamagui/mint64os-examples)

# 2. Develop Environments
We developed in the following environment. We write a script to build the environment, which can be easily built using the install script located at `scripts/install_<os_name>.sh`.

1. OS
	* Ubuntu 16.04.6 LTS(xenial)

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

    $ docker run -it koreasecurity/dev:os_dev
