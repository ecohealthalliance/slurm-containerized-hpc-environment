# Use the specified base image
FROM ghcr.io/ecohealthalliance/reservoir:gpu

# Set noninteractive environment to avoid prompts from apt-get
ENV DEBIAN_FRONTEND=noninteractive



# Set environment variables for building SLURM
ENV SLURM_VERSION=23.11.6 \
  MUNGE_UID=981 \
  SLURM_UID=982 \
  WORKER_UID=1234\
  ANSIBLE_UID=1111



COPY scripts/create_users_and_groups.sh /create_users_and_groups.sh
COPY scripts/install_system_tools.sh /install_system_tools.sh 
RUN chmod +x /create_users_and_groups.sh /install_system_tools.sh && \
    /create_users_and_groups.sh && \
    /install_system_tools.sh

# Minimize the number of layers and clean up in the same RUN statement to reduce image size
RUN apt-get update && apt-get install -y \
    build-essential \
    wget \
    bzip2 \
    gcc \
    make \
    libpam0g-dev \
    munge \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*





# Download, unpack, compile, and install SLURM, then clean up in a single RUN to reduce image size
RUN wget -qO- https://download.schedmd.com/slurm/slurm-${SLURM_VERSION}.tar.bz2 | tar xvj && \
    cd slurm-${SLURM_VERSION} && \
    ./configure --prefix=/usr --sysconfdir=/etc/slurm --enable-pam --with-pam_dir=/lib/x86_64-linux-gnu/security/ --without-shared-libslurm  --with-munge && \
    make && make contrib && make install && \
    cd / && rm -rf /slurm-${SLURM_VERSION}


    # Copy scripts and make them executable in a single RUN statement to reduce layers


# Expose necessary ports for SLURM and other services
EXPOSE 22 3306 6817 6818 6819 8787

# Define default command
CMD ["bash"]
