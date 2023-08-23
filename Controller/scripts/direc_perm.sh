#!/usr/bin/env bash
set -e

  
 mkdir -p /var/spool/slurm/ctld \
    /var/spool/slurm/d \
    /var/log/slurm
  chown -R slurm: /var/spool/slurm/ctld \
    /var/spool/slurm/d \
    /var/log/slurm
  touch /var/log/slurmctld.log
  chown slurm: /var/log/slurmctld.log

   touch /var/log/slurm/slurmdbd.log
   chown slurm: /var/log/slurm/slurmdbd.log
   chown slurm: /etc/slurm/slurm.conf
   chown slurm: /etc/slurm/slurmdbd.conf
   chown slurm:  /etc/slurm/slurmdbd.conf


  chmod 600 /etc/slurm/slurmdbd.conf
  chmod 600 /etc/slurm/slurm.conf
  chmod 644 /etc/slurm/slurm.conf


  #make slurm.conf writable by slurm group
 chmod 644 /etc/slurm/slurm.conf
 chmod g+r /etc/slurm/slurm.conf


 usermod -aG slurm rstudio 
 usermod -aG slurm worker
#make slurm.conf writable by slurm group
 chmod g+r /etc/slurm/slurm.conf