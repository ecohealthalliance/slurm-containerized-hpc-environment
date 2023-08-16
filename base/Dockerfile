FROM ghcr.io/ecohealthalliance/reservoir:gpu


ENV SLURM_VERSION=23.02 \
  MUNGE_UID=981 \
  SLURM_UID=982 \
  WORKER_UID=1500

RUN groupadd -g $MUNGE_UID munge \
  && useradd  -m -c "MUNGE Uid 'N' Gid Emporium" -d /var/lib/munge -u $MUNGE_UID -g munge  -s /usr/sbin/nologin munge \
  && groupadd -g $SLURM_UID slurm \
  && useradd  -m -c "Slurm workload manager" -d /var/lib/slurm -u $SLURM_UID -g slurm  -s /bin/bash slurm \
  && groupadd -g $WORKER_UID worker \
  && useradd  -m -c "Workflow user" -d /home/worker -u $WORKER_UID -g worker  -s /bin/bash worker

# Update and install packages for general functionality
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
    telnet\
    ufw \
    netcat \
    tini \
    supervisor \
    iputils-ping  \
    netcat \
    mariadb-client


# Ensure locales are generated
RUN apt-get install -y locales && \
    locale-gen en_US.UTF-8

# Download and install SLURM
 RUN wget https://download.schedmd.com/slurm/slurm-23.02.3.tar.bz2
 RUN tar xjf slurm-23.02.3.tar.bz2
 WORKDIR slurm-23.02.3
 RUN ./configure
 RUN make
 RUN make install
 WORKDIR /

VOLUME ["/home", "/.secret"]

#   22:         SSH
# 3306:         MariaDB
# 6817:         Slurm Ctl D
# 6818:         Slurm D
# 6819:         Slurm DBD
EXPOSE 22 3306 6817 6818 6819 8787