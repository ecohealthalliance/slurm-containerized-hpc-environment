#!/bin/bash
set -e

groupadd -g $MUNGE_UID munge
useradd -m -c "MUNGE Uid 'N' Gid Emporium" -d /var/lib/munge -u $MUNGE_UID -g munge -s /usr/sbin/nologin munge

groupadd -g $SLURM_UID slurm
useradd -m -c "Slurm workload manager" -d /var/lib/slurm -u $SLURM_UID -g slurm -s /bin/bash slurm

groupadd -g $WORKER_UID worker
useradd -m -c "Slurm worker manager" -d /var/lib/worker -u $WORKER_UID -g worker -s /bin/bash worker

groupadd -g $ANSIBLE_UID ansible
useradd -m -c "Workflow user" -d /home/ansible -u $ANSIBLE_UID -g ansible -s /bin/bash ansible

groupadd nfs-users
groupadd ssh-users
