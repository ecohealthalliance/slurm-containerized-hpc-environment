FROM espirado/slurm.base:23.02

# avoid tzdata asking for geographic location
ENV DEBIAN_FRONTEND=noninteractive

# install necessary build tools and libraries
RUN apt-get update && apt-get install -y \
  build-essential \
  gfortran \
  liblua5.3-dev \
  lua-posix \
  lua-filesystem \
  wget \
  bzip2 \
  expect \
  make \
  gcc \
  openmpi-bin \
  openmpi-common \
  libopenmpi-dev \
  libgtk2.0-dev

# install Lmod 8.7.29
RUN wget https://sourceforge.net/projects/lmod/files/Lmod-8.7.29.tar.bz2 \
  && tar -xjvf Lmod-8.7.29.tar.bz2 \
  && cd Lmod-8.7.29 \
  && ./configure --prefix=/opt/apps \
  && make install \
  && ln -s /opt/apps/lmod/lmod/init/profile /etc/profile.d/z00_lmod.sh \
  && ln -s /opt/apps/lmod/lmod/init/cshrc /etc/profile.d/z00_lmod.csh \
  && cd .. \
  && rm -rf Lmod-8.7.29 Lmod-8.7.29.tar.bz2

WORKDIR /home/worker

# clean up
RUN apt-get autoremove -y && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

COPY docker-entrypoint.sh /docker-entrypoint.sh

# tini for handling kernel signals
RUN apt-get update && apt-get install -y tini \
  && rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["/usr/bin/tini", "--", "/docker-entrypoint.sh"]
