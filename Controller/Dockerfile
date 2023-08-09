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
  CONTROL_MACHINE=controller \
  SLURMCTLD_PORT=6817 \
  SLURMD_PORT=6818 \
  ACCOUNTING_STORAGE_HOST=database.local.dev\
  ACCOUNTING_STORAGE_PORT=3306 \
  PARTITION_NAME=docker \
  STORAGE_PASS=password \
  STORAGE_USER=slurm



COPY docker-entrypoint.sh /docker-entrypoint.sh

# Modify permissions
RUN chmod +x /docker-entrypoint.sh

ENTRYPOINT ["/usr/bin/tini", "--", "/docker-entrypoint.sh"]

EXPOSE 6817 6818 6819 3306 