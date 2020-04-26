#!/bin/bash

# Setup tool on Linux
PARENT_DIR="`pwd`"
echo "$PARENT_DIR"

mkdir -p "${PARENT_DIR}/esp32"
WORK_DIR="${PARENT_DIR}/esp32"

#install prerequisites on debian/ubuntu
sudo apt-get install -y git wget libncurses-dev flex bison gperf python python-pip python-setuptools python-serial python-click python-cryptography python-future python-pyparsing python-pyelftools cmake ninja-build ccache libffi-dev libssl-dev

# compile the toolchain from source
sudo apt-get install -y gawk gperf grep gettext libncurses-dev python python-dev automake bison flex texinfo help2man libtool libtool-bin make

# goto working dir
cd "${WORK_DIR}"
echo "..........................Jumps to ${WORK_DIR}"

# Download crosstool-NG and build it:
git clone https://github.com/espressif/crosstool-NG.git
cd crosstool-NG
git checkout xtensa-1.22.x
git submodule update --init
./bootstrap && ./configure --enable-local && make

# Build the toolchain:
echo "..........................Build toolchain"
./ct-ng xtensa-esp32-elf
./ct-ng build
chmod -R u+w builds/xtensa-esp32-elf

# use this if do not want to compile compiler
# wget http://www.neilkolban.com/esp32/downloads/xtensa-esp32-elf.tar.gz
# sudo tar --extract --directory /opt --ungzip --file xtensa-esp32-elf.tar.gz

#Add toolchains to path
echo "..........................Export the toolchains to PATH"
export PATH="$WORK_DIR/crosstool-NG/builds/xtensa-esp32-elf/bin:$PATH"
printenv PATH
#clone the source code of esp-idf
cd "${WORK_DIR}"
git clone --recursive https://github.com/espressif/esp-idf.git

# install python 3
sudo apt-get install -y python3 python3-pip python3-setuptools

#Making Python 3 the default interpreter is possible by running:
sudo update-alternatives --install /usr/bin/python python /usr/bin/python3 10

#setup the tools
cd "${WORK_DIR}/esp-idf"
./install.sh

#Setup environment
#Note the space between the leading dot and the path!
cd "${WORK_DIR}/esp-idf"
echo ".......... `pwd`"
source export.sh
