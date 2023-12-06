#!/usr/bin/env bash
set -e

# Download, compile, and install SLURM
wget https://download.schedmd.com/slurm/slurm-23.02.4.tar.bz2
tar xvjf slurm-23.02.4.tar.bz2
rm slurm-23.02.4.tar.bz2
cd slurm-23.02.4
./configure --prefix=/tmp/slurm-build --sysconfdir=/etc/slurm --enable-pam --with-pam_dir=/lib/x86_64-linux-gnu/security/ --without-shared-libslurm  --with-munge
make
make contrib
make install
cd /

# Package SLURM into a .deb file and install it
fpm -s dir -t deb -v 1.0 -n slurm-23.02.4 --prefix=/usr -C /tmp/slurm-build .
dpkg -i slurm-23.02.4_1.0_amd64.deb

# Clean up
apt-get clean
rm -rf /var/lib/apt/lists/* /tmp/slurm-build
