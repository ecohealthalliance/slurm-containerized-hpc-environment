#!/bin/bash
# Xgboost

set -e
set -x

apt update && apt install -y software-properties-common

# install nvidia toolkit
distribution=$(. /etc/os-release;echo $ID$VERSION_ID) \
   && curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add - \
   && curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list

apt install -y --allow-change-held-packages libnccl2 \
                                            libnccl-dev \
                                            cuda-nvcc-12-1 \
                                            libnvidia-compute-470 \
                                            ocl-icd-opencl-dev \
                                            clinfo
apt-mark hold libnccl2 libnccl-dev cuda-nvcc-12-1 libnvidia-compute-470 ocl-icd-opencl-dev
ln -s /usr/lib/x86_64-linux-gnu/libOpenCL.so.1 /usr/lib/libOpenCL.so

# install cmake
apt update && apt install -y build-essential libssl-dev gcc-10 g++-10
update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-10 80 --slave /usr/bin/g++ g++ /usr/bin/g++-10 --slave /usr/bin/gcov gcov /usr/bin/gcov-10
mkdir /tmp/cmake
cd /tmp/cmake
wget https://github.com/Kitware/CMake/releases/download/v3.26.3/cmake-3.26.3.tar.gz
tar -zxvf cmake-3.26.3.tar.gz
cd /tmp/cmake/cmake-3.26.3
./bootstrap
make
make install

# compile xgboost
#cd /root
#git clone --recursive https://github.com/dmlc/xgboost
#mkdir /root/xgboost/build
#cd /root/xgboost/build
#cmake .. -DUSE_CUDA=ON -DR_LIB=ON -DUSE_NCCL=ON -DNCCL_ROOT=/usr/lib/x86_64-linux-gnu
#make install -j4
