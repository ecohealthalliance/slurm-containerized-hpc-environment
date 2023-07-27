FROM espirado/slurm.base:23.02


# Install necessary packages
RUN apt-get update && apt-get install -y \
 sudo \
  wget \
  file \
  tree \
  mariadb-server \
  libmariadb-dev \
  openssh-server \
  openssh-client \
  build-essential \
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
    netcat \
    mariadb-client

# Install OpenMPI
RUN apt-get install -y openmpi-bin

# Install Lmod 7.7
# Install Lmod
RUN apt-get install -y lmod


ENV USE_SLURMDBD=true \
  CLUSTER_NAME=snowflake \
  CONTROL_MACHINE=controller \
  SLURMCTLD_PORT=6817 \
  SLURMD_PORT=6818 \
  ACCOUNTING_STORAGE_HOST=database \
  ACCOUNTING_STORAGE_PORT=6819 \
  PARTITION_NAME=docker



COPY docker-entrypoint.sh /docker-entrypoint.sh

ENTRYPOINT ["/usr/local/bin/tini", "--", "/docker-entrypoint.sh"]
