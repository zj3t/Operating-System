#!/bin/sh
PROJECT_ROOT=$(pwd)/..

BOLD='\033[0;1m'
RED='\033[0;31m'
NC='\033[0m' # No Color

print_log()
{
    msg=$1
    printf "${RED}[*]${NC} ${BOLD}${msg}${NC}\n"
}


sudo apt-get -y update

print_log "Installing multilib compiler"
sudo apt-get -y install gcc-multilib g++-multilib

print_log "Installing makeinfo "
sudo apt-get -y install makeinfo

print_log "Installing GNU Binutils Package"
url="https://fossies.org/linux/misc/binutils-2.34.tar.xz"
package="binutils-2.34"
mkdir -p $PROJECT_ROOT/src && cd $PROJECT_ROOT/src
if [ -e "$package" ]; then
    print_log "$package exists"
else
    wget $url -P $PROJECT_ROOT/src
    tar -xvf "$package.tar.xz" && cd "$package"
    ./configure && make  && sudo make install
    cd $PROJECT_ROOT
fi
unset url && unset package

sudo apt-get install textinfo

print_log "Installing GMP Package"
url="https://ftp.gnu.org/gnu/gmp/gmp-6.2.0.tar.xz"
package="gmp-6.2.0"
mkdir -p $PROJECT_ROOT/src && cd $PROJECT_ROOT/src
if [ -e "$package" ]; then
    print_log "$package exists"
else
    wget $url -P $PROJECT_ROOT/src
    tar -xvf "$package.tar.xz" && cd "$package"
    ./configure && make  && sudo make install
    cd $PROJECT_ROOT
fi
unset url && unset package

print_log "Installing MPFR Package"
url="https://ftp.gnu.org/gnu/mpfr/mpfr-4.0.2.tar.xz"
package="mpfr-4.0.2"
mkdir -p $PROJECT_ROOT/src && cd $PROJECT_ROOT/src
if [ -e "$package" ]; then
    print_log "$package exists"
else      
    wget $url -P $PROJECT_ROOT/src 
    tar -xvf "$package.tar.xz" && cd "$package"
    ./configure && make  && sudo make install
    cd $PROJECT_ROOT
fi
unset url && unset package

print_log "Installing mpc Package"
url="https://ftp.gnu.org/gnu/mpc/mpc-1.1.0.tar.gz"
package="mpc-1.1.0"
mkdir -p $PROJECT_ROOT/src && cd $PROJECT_ROOT/src
if [ -e "$package" ]; then 
    print_log "$package exists"
else      
    wget $url -P $PROJECT_ROOT/src
    tar -xzvf "$package.tar.gz" && cd "$package"
    ./configure && make  && sudo make install
    cd $PROJECT_ROOT
fi
unset url && unset package


print_log "Installing gcc Package"
sudo apt-get -y install m4
print_log "Installing m4 for gcc complie"

url="https://fossies.org/linux/misc/gcc-9.2.0.tar.xz"
package="gcc-9.2.0"

mkdir -p $PROJECT_ROOT/src && cd $PROJECT_ROOT/src
if [ -e "$package" ]; then
	print_log "$package exists"
else
	wget $url -P $PROJECT_ROOT/src/
	tar -xvf "$package.tar.xz" && cd "$package"
	./configure --disable-nls --enable-languages=c --without-hearders --disable-shared --enable-multilib --disable-bootstrap && make configure-host  && make all-gcc && make install-gcc
	cd $PROJECT_ROOT
fi
unset url && unset package


print_log "Installing nasm Package"
sudo apt-get install nasm

print_log "Installing qemu Package"
url="http://download.qemu-project.org/qemu-4.2.0.tar.xz"
package="qemu-4.2.0"
v_support=$(egrep '^flags.*(vmx|svm)' /proc/cpuinfo)
if [ -z "$v_support" ]
then
	print_log "No hardware virtualization support."
	exit 1
else
	print_log "hardware virtualization support."
	if [ $(uname -m) = i686 ]; then
		QEMU_ARCH=i386-softmmu
	else
		QEMU_ARCH=x86_64-softmmu
	fi

	QEMU_BUILD=./qemu_build
	mkdir -vp $QEMU_BUILD &&
	cd $QEMU_BUILD &&
	../configure	--prefix=/usr               \
					--sysconfdir=/etc           \
					--target-list=$QEMU_ARCH    \
					--enable-kvm				\
					--enable-vnc				\
					--enable-snappy				\
					--enable-bzip2				\
					--enable-lzo				\
					--enable-system				\
					--enable-sdl				\
					--enable-spice				\
					--enable-usb-redir			\
					--docdir=/usr/share/doc/qemu-4.2.0 &&
	unset QEMU_ARCH && unset QEMU_BUILD &&
	make && sudo make install && sudo ln -sv qemu-system-`uname -m` /usr/bin/qemu

fi
 

mkdir -p $PROJECT_ROOT/src && cd $PROJECT_ROOT/src
if [ -e "$package" ]; then
    printf "$package exists\n"
else
    wget $url -P $PROJECT_ROOT/src
    tar -xvf "$package.tar.xz" && cd "$package"
    ./configure && make  && sudo make install
    cd $PROJECT_ROOT
fi

print_log "Done!"
