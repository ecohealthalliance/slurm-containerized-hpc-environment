#!/bin/bash

# Define installation paths
PREFIX="/var/s/modules"
MODULEFILESDIR="/shared/space/modulefiles"

# Download Modules tarball
MODULES_VERSION="5.4.0"
MODULES_TARBALL="modules-${MODULES_VERSION}.tar.gz"
MODULES_URL="https://github.com/cea-hpc/modules/releases/download/v${MODULES_VERSION}/${MODULES_TARBALL}"
curl -LJO "${MODULES_URL}"

# Extract Modules tarball
tar xfz "${MODULES_TARBALL}"

# Change directory to Modules source
cd "modules-${MODULES_VERSION}"

# Configure Modules
./configure --prefix="${PREFIX}" --modulefilesdir="${MODULEFILESDIR}"

# Build and install Modules
make
make install

# Create symlinks for system-wide environment setup
ln -s "${PREFIX}/init/profile.sh" /etc/profile.d/modules.sh
ln -s "${PREFIX}/init/profile.csh" /etc/profile.d/modules.csh

# Add module path to initrc configuration file
echo "module use ${MODULEFILESDIR}" >> "${PREFIX}/init/initrc"

# Clean up
cd ..
rm -rf "modules-${MODULES_VERSION}"
rm "${MODULES_TARBALL}"

echo "Modules installed successfully to ${PREFIX}"
