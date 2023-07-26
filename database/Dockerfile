FROM espirado/slurm.base:23.02
LABEL maintainer="Your Name <your-email@example.com>"

ENV DBD_ADDR=database \
  DBD_HOST=database \
  DBD_PORT=6819 \
  STORAGE_HOST=database.local.dev \
  STORAGE_PORT=3306 \
  STORAGE_PASS=password \
  STORAGE_USER=slurm

# clean up
RUN apt-get autoremove -y && apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY docker-entrypoint.sh /docker-entrypoint.sh

ENTRYPOINT ["/usr/local/bin/tini", "--", "/docker-entrypoint.sh"]
