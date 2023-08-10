FROM espirado/slurm-eco-base:23.02


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
  slurmd \
  slurmctld \
  gcc \
  make \
  python3 \
  python3-pip \
    vim \
    git \
    supervisor \
    iputils-ping  \
    netcat \
    tini \
     netcat \
     slurmdbd\
    telnet\
    ufw \
    mariadb-client

RUN apt  update
RUN apt-get install munge libmunge2 libmunge-dev
 
 
# Install OpenMPI
RUN apt-get install -y openmpi-bin

# Install Lmod 7.7
# Install Lmod
RUN apt-get install -y lmod


ENV USE_SLURMDBD=true \
  CLUSTER_NAME=snowflake \
  CONTROL_MACHINE= \
  SLURMCTLD_PORT=6817 \
  SLURMD_PORT=6818\
  ACCOUNTING_STORAGE_HOST=database \
  ACCOUNTING_STORAGE_PORT=3306 \
  STORAGE_PASS=/var/run/munge/munge.socket.2 \
  STORAGE_USER=slurm \
  PARTITION_NAME=docker



COPY docker-entrypoint.sh /docker-entrypoint.sh

# Modify permissions
RUN chmod +x /docker-entrypoint.sh

ENTRYPOINT ["/usr/bin/tini", "--", "/docker-entrypoint.sh"]

EXPOSE 6817 6818 6819 3306 8787 