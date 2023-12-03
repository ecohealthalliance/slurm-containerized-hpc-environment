#!/usr/bin/env bash
set -e

MUNGE_UID=981
SLURM_UID=982
ANSIBLE_UID=111

# Create Munge user and group
groupadd -g $MUNGE_UID munge
useradd -m -c "MUNGE Uid 'N' Gid Emporium" -d /var/lib/munge -u $MUNGE_UID -g munge -s /usr/sbin/nologin munge

# Create Slurm user and group
groupadd -g $SLURM_UID slurm
useradd -m -c "Slurm workload manager" -d /var/lib/slurm -u $SLURM_UID -g slurm -s /bin/bash slurm


