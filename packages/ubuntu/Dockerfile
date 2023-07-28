FROM espirado/slurm-eco-base:23.02

ENV SLURM_VERSION=23.02 

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
  perl \
   mariadb-server \
   libmariadb-dev \
  build-essential \
  && rm -rf /var/lib/apt/lists/*

COPY docker-entrypoint.sh /docker-entrypoint.sh

# Modify permissions
RUN chmod +x /docker-entrypoint.sh

VOLUME ["/packages"]
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["ls", "-alh", "/packages"]
