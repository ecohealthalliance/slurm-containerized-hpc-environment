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

_run_scripts(){
#bash /wait_worker_key.sh
bash /munge_worker_init.sh
bash /slurm_setup.sh
bash /ansible_user.sh
bash /module.sh



}
# run slurmd
_slurmd() {
 /usr/sbin/slurmd
}

### main ###
_sshd_host
_run_scripts
_slurmd

tail -f /dev/null