#!/bin/bash

# Check if slurmctld is running
echo "### Checking if slurmctld is running on the controller container ###"
if docker exec -it controller service slurmctld status | grep -q "is running"; then
  echo "slurmctld is up and running in the controller container!"
else
  echo "slurmctld is not running in the controller container!"
  exit 1
fi

# Print logs
echo "### Printing logs for slurm in the controller container ###"
docker exec -it controller cat /var/log/slurm/slurm.log
echo "### Printing logs for slurmctld in the controller container ###"
docker exec -it controller cat /var/log/slurm/slurmctld.log
echo "### Printing logs for munge in the controller container ###"
docker exec -it controller cat /var/log/munge/munged.log
echo "### Printing logs for slurmdbd in the controller container ###"
docker exec -it controller cat /var/log/slurm/slurmdbd.log
