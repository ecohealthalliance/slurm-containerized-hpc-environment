#!/bin/bash
set -e

# Update package list and install essential packages
apt-get update && apt-get install -y \
  sudo \
  wget \
  file \
  tree \
  mariadb-server \
  libmariadb-dev \
  openssh-server \
  openssh-client \
  build-essential \
  tini \
  gcc \
  make \
  python3 \
  python3-pip \
  libmunge-dev \
  libmunge2 \
  munge \
  ruby \
  ruby-dev \
  rubygems \
  libdbus-1-dev

# Install FPM (Effing Package Management)
gem install --no-document fpm

# Clean up package cache and remove temporary files
apt-get clean && rm -rf /var/lib/apt/lists/*
