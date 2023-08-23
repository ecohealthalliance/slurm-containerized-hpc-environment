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

# setup worker ssh to be passwordless
_ssh_worker() {
  if [[ ! -d /home/worker ]]; then
    mkdir -p /home/worker
    chown -R worker:worker /home/worker
  fi
  cat > /home/worker/setup-worker-ssh.sh <<'EOF2'
mkdir -p ~/.ssh
chmod 0700 ~/.ssh
ssh-keygen -b 2048 -t rsa -f ~/.ssh/id_rsa -q -N "" -C "$(whoami)@$(hostname)-$(date -I)"
cat ~/.ssh/id_rsa.pub > ~/.ssh/authorized_keys
chmod 0640 ~/.ssh/authorized_keys
cat >> ~/.ssh/config <<EOF
Host *
  StrictHostKeyChecking no
  UserKnownHostsFile /dev/null
  LogLevel QUIET
EOF
chmod 0644 ~/.ssh/config
cd ~/
tar -czvf ~/worker-secret.tar.gz .ssh
cd -
EOF2
  chmod +x /home/worker/setup-worker-ssh.sh
  chown worker: /home/worker/setup-worker-ssh.sh
  sudo -u worker /home/worker/setup-worker-ssh.sh
}

_run_scripts(){

  bash  /munge.sh
  bash /copy_secrets.sh
  bash /db_start.sh
  bash  /direct_perm.sh
  bash /slurmdbd.sh 
  bash  /slurmctld.sh
 
}

_start_Rstudio() {
  service rstudio-server start
}


### main ###
_sshd_host
_ssh_worker
_run_scripts
_start_Rstudio



tail -f /dev/null