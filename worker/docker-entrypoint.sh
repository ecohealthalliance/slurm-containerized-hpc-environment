#!/usr/bin/env bash
set -e

# start sshd server
_sshd_host() {
  if [ ! -d /var/run/sshd ]; then
    mkdir /var/run/sshd
    ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key -N ''
  fi
  /usr/sbin/sshd
}

# start munge using existing key
_munge_start_using_key() {
  echo -n "cheking for munge.key"
  while [ ! -f /.secret/munge.key ]; do
    echo -n "."
    sleep 1
  done
  echo ""
  mkdir -p /var/run/munge
  cp /.secret/munge.key /etc/munge/munge.key
  chown -R munge: /etc/munge /var/lib/munge /var/log/munge /var/run/munge
  chmod 0700 /etc/munge
  chmod 0711 /var/lib/munge
  chmod 0700 /var/log/munge
  chmod 0755 /var/run/munge
  sudo -u munge /sbin/munged
  munge -n
  munge -n | unmunge
  remunge
}

# wait for worker user in shared /home volume
_wait_for_worker() {
  if [ ! -f /home/worker/.ssh/id_rsa.pub ]; then
    echo -n "cheking for id_rsa.pub"
    while [ ! -f /home/worker/.ssh/id_rsa.pub ]; do
      echo -n "."
      sleep 1
    done
    echo ""
  fi
}

# run slurmd
_slurmd() {
  if [ ! -f /.secret/slurm.conf ]; then
    echo -n "cheking for slurm.conf"
    while [ ! -f /.secret/slurm.conf ]; do
      echo -n "."
      sleep 1
    done
    echo ""
  fi




   mkdir -p /var/spool/slurm/ctld \
    /var/spool/slurm/d \
    /var/log/slurm
  chown -R slurm: /var/spool/slurm/ctld \
    /var/spool/slurm/d \
    /var/log/slurm
  touch /var/log/slurmctld.log
  chown slurm: /var/log/slurmctld.log

  touch /var/log/slurm/slurmdbd.log
  touch /var/log/slurmd.log
   chown slurm: /var/log/slurm/slurmdbd.log
    chown slurm: /var/log/slurmd.log
   chown slurm: /etc/slurm/slurm.conf
   chown slurm: /etc/slurm/slurmdbd.conf
   chown slurm:  /etc/slurm/slurmdbd.conf
  chmod 600 /etc/slurm/slurmdbd.conf
  chmod 600 /etc/slurm/slurm.conf


 #start slurm service
  /usr/sbin/slurmd
}

### main ###
_sshd_host
_munge_start_using_key
_wait_for_worker
_slurmd

tail -f /dev/null
