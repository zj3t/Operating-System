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


  sudo apt install -y update
  sudo apt install -y curl

  print_log "Installing qemu Package"
  url="http://download.qemu-project.org/qemu-4.2.0.tar.xz"
  package="qemu-4.2.0"
  v_support=$(egrep '^flags.*(vmx|svm)' /proc/cpuinfo)
  if [ -z "$v_support" ]
  then
    print_log "No hardware virtualization support."
    exit 1
  else
    print_log "Hardware virtualization support."
    if [ $(uname -m) = i686 ]; then
      QEMU_ARCH=i386-softmmu
    else
      QEMU_ARCH=x86_64-softmmu
    fi

    QEMU_BUILD=./qemu_build
    mkdir -vp $QEMU_BUILD &&
    cd $QEMU_BUILD &&
    wget -N ${url}
    tar xvJf ${package}.tar.xz
    #Belows are required additional packages for qemu.(https://wiki.qemu.org/Hosts/Linux)
    sudo apt install -y git libglib2.0-dev libfdt-dev libpixman-1-dev zlib1g-dev liblzo2-dev

# Belows are recommended additional packages for qemu.(https://wiki.qemu.org/Hosts/Linux)
    sudo apt install -y git-email
    sudo apt install -y libaio-dev libbluetooth-dev libbrlapi-dev libbz2-dev
    sudo apt install -y libcap-dev libcap-ng-dev libcurl4-gnutls-dev libgtk-3-dev
    sudo apt install -y libibverbs-dev libjpeg8-dev libncurses5-dev libnuma-dev
    sudo apt install -y librbd-dev librdmacm-dev
    sudo apt install -y libsasl2-dev libsdl1.2-dev libseccomp-dev libsnappy-dev libssh2-1-dev
    sudo apt install -y libvde-dev libvdeplug-dev libvte-2.90-dev libxen-dev liblzo2-dev
    sudo apt install -y valgrind xfslibs-dev
    sudo apt install -y libnfs-dev libiscsi-dev
    cd ${package}
    ./configure	--prefix=/usr               \
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

  print_log "Installing Docker Pacakge from https://github.com/docker/docker-install"
  curl -fsSL https://get.docker.com -o get-docker.sh
  sh get-docker.sh

  print_log "Installing Requirments"
  sudo apt install -y python3
  sudo apt install -y python3-pip
  sudo pip3 install -r ${PROJECT_ROOT}/requirements.txt

  print_log "Running Development Environment(Docker)"
  docker run -it -d koreasecurity/dev:os_dev

  unset package && unset path && unset v_support

  print_log "Done!"
