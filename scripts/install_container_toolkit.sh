#!/bin/bash

set -e

curl -s -L https://nvidia.github.io/nvidia-container-runtime/gpgkey | sudo apt-key add -

distribution=$(. /etc/os-release;echo $ID$VERSION_ID) \
   && curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add - \
   && curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list

apt-get update

apt-get install -y nvidia-driver-470 \
                   nvidia-container-toolkit \
                   clinfo
apt-mark hold nvidia-driver-470 nvidia-container-toolkit

systemctl restart docker
