# arch-kernel-builder
Docker container to build custom arch linux kernels from source.

- `run_container.sh`: builds the docker container and runs it. Arch kernel packages will be built by the docker container and stored on the host drive in the directory `output`, which is created in the same directory as `run_container.sh`.
- `Dockerfile`: Docker file based on `archlinux/base:latest`. It prepares the environment for kernel compilation and runs `compile_kernel.sh` to compile the custom kernel.
- `compile_kernel.sh`: Modifies the kernel config to add/remove additional kernel modules for the custom kernel. It then compiles the kernel using `makepkg` and copies the kernel packages to `output`.

The current modifications to the kernel configuration enable USB serial support for which the following fields are set to true:
- CONFIG_USB_SERIAL_CONSOLE
- CONFIG_USB_SERIAL
- CONFIG_USB_SERIAL_PL2303

See: [Arch Wiki](https://wiki.archlinux.org/index.php/Kernel/Arch_Build_System#Installing) for installation details.
