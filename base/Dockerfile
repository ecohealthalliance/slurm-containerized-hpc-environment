FROM ghcr.io/ecohealthalliance/reservoir:gpu

ENV DEBIAN_FRONTEND=noninteractive



ENV SLURM_VERSION=23.02.4 \
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
  tini \
  gcc \
  make \
  python3 \
  python3-pip \ 
  libmunge-dev  \ 
  libmunge2 \ 
   munge

# Install Ruby, Rubygems, and then fpm
RUN apt-get update && apt-get install -y \
    ruby \
    ruby-dev \
    rubygems \
    build-essential && \
    gem install --no-document fpm && \
    apt-get clean && rm -rf /var/lib/apt/lists/*




# Ensure locales are generated
RUN apt-get install -y locales && \
    locale-gen en_US.UTF-8

# Download and install SLURM
# Download, compile, and install SLURM
RUN wget https://download.schedmd.com/slurm/slurm-23.02.4.tar.bz2 && \
    tar xvjf slurm-23.02.4.tar.bz2 && \
    rm slurm-23.02.4.tar.bz2 && \
    cd slurm-23.02.4 && \
    ./configure --prefix=/tmp/slurm-build --sysconfdir=/etc/slurm --enable-pam --with-pam_dir=/lib/x86_64-linux-gnu/security/ --without-shared-libslurm  --with-munge  && \
    make && \
    make contrib && \
    make install

WORKDIR /

RUN fpm -s dir -t deb -v 1.0 -n slurm-23.02.4 --prefix=/usr -C /tmp/slurm-build . && dpkg -i slurm-23.02.4_1.0_amd64.deb
RUN apt-get clean && rm -rf /var/lib/apt/lists/*



VOLUME ["/home", "/.secret"]

#   22:         SSH
# 3306:         MariaDB
# 6817:         Slurm Ctl D
# 6818:         Slurm D
# 6819:         Slurm DBD
EXPOSE 22 3306 6817 6818 6819 8787