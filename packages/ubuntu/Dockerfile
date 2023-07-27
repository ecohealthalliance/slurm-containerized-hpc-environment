FROM espirado/slurm.base:23.02
LABEL maintainer="andrew espira"

ENV SLURM_VERSION=3.02 

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
  wget \
  munge \
  gcc \
  openssl \
  libssl-dev \
  libssh2-1-dev \
  libpam0g-dev \
  numactl \
  libnuma-dev \
  libhwloc-dev \
  lua5.3 \
  liblua5.3-dev \
  libreadline-dev \
  librrd-dev \
  libncurses5-dev \
  libgtk2.0-dev \
  man2html-base \
  libibmad-dev \
  libibumad-dev \
  perl-switch \
  perl \
  mariadb-server \
  libmariadb-dev \
  build-essential \
  && rm -rf /var/lib/apt/lists/*

COPY docker-entrypoint.sh /docker-entrypoint.sh
VOLUME ["/packages"]
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["ls", "-alh", "/packages"]
