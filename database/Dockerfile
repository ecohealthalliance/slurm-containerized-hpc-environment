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
  gcc \
  make \
  python3 \
  python3-pip \
  slurmd \
  slurmctld \
    vim \
    git \
    supervisor \
    iputils-ping  \
    netcat \
    telnet\
    ufw \
   slurmdbd\
   tini 

# Download and install SLURM
# RUN wget https://download.schedmd.com/slurm/slurm-23.02.3.tar.bz2
# RUN tar xjf slurm-23.02.3.tar.bz2
# WORKDIR slurm-23.02.3
# RUN ./configure
# RUN make
# RUN make install

ENV DBD_ADDR=database \
  DBD_HOST=database \
  DBD_PORT=3306 \
  STORAGE_HOST=database.local.dev \
  STORAGE_PORT=3306 \
  STORAGE_PASS=password \
  STORAGE_USER=slurm \
  USE_SLURMDBD=true \
  CLUSTER_NAME=database \
  CONTROL_MACHINE=controller \
  SLURMCTLD_PORT=6817 \
  SLURMD_PORT=6818 \
  ACCOUNTING_STORAGE_HOST=database.local.dev\
  ACCOUNTING_STORAGE_PORT=3306 \
  PARTITION_NAME=docker

# clean up
RUN apt-get autoremove -y && apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# RUN ls -l /usr/local/sbin/slurmdbd


COPY docker-entrypoint.sh /docker-entrypoint.sh

# Modify permissions
RUN chmod +x /docker-entrypoint.sh

ENTRYPOINT ["/usr/bin/tini", "--", "/docker-entrypoint.sh"]

EXPOSE 3306 