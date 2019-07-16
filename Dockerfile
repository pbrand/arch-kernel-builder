# Compile custom kernel which includes usb modules for the serial to usb adapter
# Based on Arch Build System: https://wiki.archlinux.org/index.php/Kernel/Arch_Build_System
FROM archlinux/base:latest

# Required packages
RUN pacman -Syu --noconfirm
RUN pacman-db-upgrade
RUN pacman --noconfirm -S asp base-devel pacman-contrib sudo vim

# Create expendable user for makepkg, which does not run as root/sudo
RUN useradd -ms /bin/bash worker

# No password prompt when using sudo
RUN echo "worker ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Switch to user
USER worker
WORKDIR /home/worker

COPY compile_kernel.sh .

ENTRYPOINT ./compile_kernel.sh

