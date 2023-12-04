#!/bin/bash
set -e

# Define the list of packages to install
packages=(
    sudo
    wget
    tini
    libmunge-dev
    libmunge2
    munge
    openmpi-bin
    lmod
    supervisor
    file
    tree
    mariadb-server
    libmariadb-dev
    openssh-server
    openssh-client
    build-essential
    tini
    gcc
    make
    python3
    python3-pip
    libmunge-dev
    libmunge2
    munge
    ruby
    ruby-dev
    rubygems
    libdbus-1-dev
)

# Update package repository
apt-get update

# Install all packages at once
apt-get install -y "${packages[@]}"

# Install FPM (Effing Package Management)
gem install --no-document fpm

# Clean up package cache and remove temporary files
apt-get clean
rm -rf /var/lib/apt/lists/*
