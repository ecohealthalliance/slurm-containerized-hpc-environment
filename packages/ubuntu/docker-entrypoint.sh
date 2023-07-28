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
wget https://download.open-mpi.org/release/open-mpi/v4.1/openmpi-4.1.5.tar.gz
tar -xzf openmpi-4.1.5.tar.gz
cd openmpi-4.1.5
./configure --with-slurm --with-pmi
make
make install
cd ..
cp /usr/local/bin/* /packages

exec "$@"
