#! /bin/bash

### Variables
# Name of the new kernel package
KERNEL_NAME=linux-custom
# Number of processors used for compilation of the kernel
NPROC=$(nproc)
export MAKEFLAGS="-j${NPROC}"

# Download linux kernel source
mkdir /home/worker/build
cd /home/worker/build

asp update linux
asp checkout linux

# Replace the name of pkgbase
cd /home/worker/build/linux/repos/core-x86_64/ 
sed -i -E "s/^.*(pkgbase=)linux.*$/\1${KERNEL_NAME}/g;" PKGBUILD

## Set the following fields to y in kernel config:
# CONFIG_USB_SERIAL_CONSOLE
# CONFIG_USB_SERIAL
# CONFIG_USB_SERIAL_PL2303
sed -i -E 's/^·*(CONFIG_USB_SERIAL_CONSOLE=)[mn]{1}.*$/\1y/g;' config
sed -i -E 's/^·*(CONFIG_USB_SERIAL=)[mn]{1}.*$/\1y/g;' config
sed -i -E 's/^·*(CONFIG_USB_SERIAL_PL2303=)[mn]{1}.*$/\1y/g;' config

# Generate new checksums
updpkgsums

## Import the gpg keys from validpgpkeys field in PKGBUILD
# sed command: capture everything between validpgpkeys=( and ) excluding both these patterns and remove comments.
# tr to remove everythihg thats not part of hexadecimal code and whiteline. It removes the white lines and quotation marks.
gpg --recv-keys $(cat PKGBUILD | sed -z -E 's/^.*validpgpkeys=\(([^)]+)\).*$/\1/g' | sed 's/#.*$//' | tr -d -c '[A-F0-9\n]')

# Compile kernel and copy the packages to the output folder
echo "Available CPUs for kernel compilation: ${NPROC}"
makepkg -s --noconfirm && sudo cp ./*.pkg.tar.xz /mnt/output
