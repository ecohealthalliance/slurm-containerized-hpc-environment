#!/bin/bash

set -e
set -x


# Install dependencies
RUN apt-get update && apt-get install -y \
    wget \
    gcc \
    make \
    python3 \
    python3-pip \
    vim \
    git \
    munge \
    libmunge-dev \
    libmunge2 \
    supervisor \
    iputils-ping  \
    netcat

# Download and install SLURM
RUN wget https://download.schedmd.com/slurm/slurm-23.02.3.tar.bz2
RUN tar xjf slurm-23.02.3.tar.bz2
WORKDIR slurm-23.02.3
RUN ./configure
RUN make
RUN make install