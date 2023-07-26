#!/usr/bin/env bash
set -e

# install required packages
apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
  wget \
  build-essential \
  rpm \
  curl

# build slurm debs
wget https://download.schedmd.com/slurm/slurm-${SLURM_VERSION}.tar.bz2
tar -xjf slurm-${SLURM_VERSION}.tar.bz2
cd slurm-${SLURM_VERSION}
./configure
make
make install
cd ..
cp /usr/local/bin/* /packages

# build openmpi deb
wget https://www.open-mpi.org/software/ompi/v3.0/downloads/openmpi-3.0.1.tar.gz
tar -xzf openmpi-3.0.1.tar.gz
cd openmpi-3.0.1
./configure --with-slurm --with-pmi
make
make install
cd ..
cp /usr/local/bin/* /packages

exec "$@"
