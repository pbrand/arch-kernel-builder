#! /bin/bash
echo "Build Container."
docker build . -t "custom_kernel"

echo "Run container"
docker run -it -v $(pwd)/output:/mnt/output custom_kernel

echo "Kernel packages are stored in output"
