#/bin/bash

docker-compose stop
docker-compose rm -f
docker network rm slurm-containerized-hpc-environment_slurm 


