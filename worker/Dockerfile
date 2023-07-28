FROM espirado/slurm-eco-base:23.02

# avoid tzdata asking for geographic location
ENV DEBIAN_FRONTEND=noninteractive

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
    supervisor \
    iputils-ping  \
    netcat \
    tini \
    mariadb-client

RUN apt  update
RUN apt-get install munge libmunge2 libmunge-dev
 
 
# Install OpenMPI
RUN apt-get install -y openmpi-bin

# Install Lmod 7.7
# Install Lmod
RUN apt-get install -y lmod



WORKDIR /home/worker

# clean up
RUN apt-get autoremove -y && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

COPY docker-entrypoint.sh /docker-entrypoint.sh

# Modify permissions
RUN chmod +x /docker-entrypoint.sh

# tini for handling kernel signals
RUN apt-get update && apt-get install -y tini \
  && rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["/usr/bin/tini", "--", "/docker-entrypoint.sh"]
