FROM   rocker/ml-verse:4.3.0
MAINTAINER "Noam Ross" ross@ecohealthalliance.org

ENV CUDAToolkit_ROOT=/usr/local/cuda
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/cuda/lib64

# Install SLURM client
RUN apt-get update && apt-get install -y slurm-client

# Add SLURM configuration file
ADD slurm.conf /etc/slurm-llnl/slurm.conf

# All your previous installation scripts and configurations
COPY scripts/install_xgboost.sh /reservoir_scripts/install_xgboost.sh
RUN /reservoir_scripts/install_xgboost.sh

COPY scripts/install_system_tools.sh /reservoir_scripts/install_system_tools.sh
RUN /reservoir_scripts/install_system_tools.sh

COPY scripts/install_eigen_stan_inla.sh /reservoir_scripts/install_eigen_stan_inla.sh
RUN /reservoir_scripts/install_eigen_stan_inla.sh

COPY scripts/install_r_pkgs_compiled.sh /reservoir_scripts/install_r_pkgs_compiled.sh
RUN /reservoir_scripts/install_r_pkgs_compiled.sh

COPY scripts/install_r_pkgs_other.sh /reservoir_scripts/install_r_pkgs_other.sh
RUN /reservoir_scripts/install_r_pkgs_other.sh

RUN apt-get update && apt-get install -y mesa-opencl-icd

#RUN ln -s /usr/lib/x86_64-linux-gnu/libcudnn.so.8 /usr/local/cuda-11.1/lib64

ENV TZ=America/New_York
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime \
  && echo $TZ > /etc/timezone \
  && dpkg-reconfigure --frontend noninteractive tzdata

COPY /scripts/server_config.sh /reservoir_scripts/server_config.sh
COPY config /reservoir_config
RUN /reservoir_scripts/server_config.sh

RUN locale-gen en_US.UTF-8

EXPOSE 22 8787
