#!/usr/bin/env bash
set -e

# Function to start the SSHD server
start_sshd_server() {
  if [ ! -d /var/run/sshd ]; then
    mkdir /var/run/sshd
    ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key -N ''
  fi
  /usr/sbin/sshd
}

# Function to setup passwordless SSH for the worker user
setup_worker_ssh() {
  if [[ ! -d /home/worker ]]; then
    mkdir -p /home/worker
    chown -R worker:worker /home/worker
  fi

  # Create SSH setup script for worker
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

  # Execute the SSH setup script
  chmod +x /home/worker/setup-worker-ssh.sh
  chown worker: /home/worker/setup-worker-ssh.sh
  sudo -u worker /home/worker/setup-worker-ssh.sh
}

# Function to run necessary scripts
run_scripts() {
  bash /munge.sh
  bash /copy_secrets.sh
  bash /db_start.sh
  bash /direct_perm.sh
  bash /ansible_user.sh
  bash /slurmdbd.sh 
  bash /slurmctld.sh
  bash /module.sh
  
}

# Function to start RStudio Server
start_rstudio_server() {
  service rstudio-server start
}

# Main execution
start_sshd_server
setup_worker_ssh
run_scripts
start_rstudio_server

# Keep the container running
tail -f /dev/null
