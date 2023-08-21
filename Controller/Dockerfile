FROM espirado/eco-slurm-base:23.02 

# Install necessary packages
RUN apt-get update && apt-get install -y \
 sudo \
  wget \ 
  tini \ 
  libmunge-dev  \ 
  libmunge2 \ 
   munge



# Install OpenMPI
RUN apt-get install -y openmpi-bin

# Install Lmod 7.7
# Install Lmod
RUN apt-get install -y lmod
RUN apt-get update && apt-get install -y supervisor && rm -rf /var/lib/apt/lists/*



ENV USE_SLURMDBD=true \
  CLUSTER_NAME=snowflake \
  CONTROL_MACHINE=controller \
  SLURMCTLD_PORT=6817 \
  SLURMD_PORT=6819 \
  ACCOUNTING_STORAGE_HOST=localhost \
  ACCOUNTING_STORAGE_PORT=3306 \
  STORAGE_PASS=/var/run/munge/munge.socket.2 \
  STORAGE_USER=slurm \
  PARTITION_NAME=docker

COPY docker-entrypoint.sh /docker-entrypoint.sh
COPY slurm.conf /etc/slurm/slurm.conf
COPY slurmdbd.conf /etc/slurm/slurmdbd.conf




# Modify permissions
RUN chmod +x /docker-entrypoint.sh

ENTRYPOINT ["/usr/bin/tini", "--", "/docker-entrypoint.sh", "/init","/opt/nvidia/nvidia_…"]

EXPOSE 6817 6818 6819 3306 8787 