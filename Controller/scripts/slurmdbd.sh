#!/usr/bin/env bash
set -e

_slurmcdbd() {
  # Check for the configuration files in /etc/slurm/
  if [[ ! -f /etc/slurm/slurm.conf ]]; then
    echo "Error: /etc/slurm/slurm.conf not found!"
    exit 1
  fi

  if [[ ! -f /etc/slurm/slurmdbd.conf ]]; then
    echo "Error: /etc/slurm/slurmdbd.conf not found!"
    exit 1
  fi

  # Setting Up Directories and Permissions
 
  # Start slurmbd service
  /usr/sbin/slurmdbd

}

### main ###
_slurmcdbd

