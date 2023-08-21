#/bin/bash

docker-compose stop
docker-compose rm -f
docker volume rm slurmindocker_home slurmindocker_secret
docker network rm slurmindocker_slurm




# copy secrets to /.secret directory for other nodes
_copy_secrets() {
  cp /home/worker/worker-secret.tar.gz /.secret/worker-secret.tar.gz
  cp /home/worker/setup-worker-ssh.sh /.secret/setup-worker-ssh.sh
 # cp /etc/munge/munge.key /.secret/munge.key
  rm -f /home/worker/worker-secret.tar.gz
  rm -f /home/worker/setup-worker-ssh.sh
}


_start_Rstudio() {
  service rstudio-server start
}



_slurmctld() {
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
# Checking and changing permission for slurm.conf
echo "Changing file permission for /etc/slurm/slurm.conf..."
/bin/chmod 600 /etc/slurm/slurm.conf
if [ "$(stat -c %a /etc/slurm/slurm.conf)" == "600" ]; then
    echo "File permission for /etc/slurm/slurm.conf changed successfully."
else
    echo "Failed to change file permission for /etc/slurm/slurm.conf."
    exit 1
fi
# Checking and changing permission for slurmdbd.conf
echo "Changing file permission for /etc/slurm/slurmdbd.conf..."
/bin/chmod 600 /etc/slurm/slurmdbd.conf
if [ "$(stat -c %a /etc/slurm/slurmdbd.conf)" == "600" ]; then
    echo "File permission for /etc/slurm/slurmdbd.conf changed successfully."
else
    echo "Failed to change file permission for /etc/slurm/slurmdbd.conf."
    exit 1
fi
 # Start slurmctld service
    /usr/sbin/slurmctld 
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

# start munge and generate key
_munge_start() {


  # Create necessary directories if they do not exist
  mkdir -p /var/run/munge /etc/munge /var/log/munge /var/lib/munge

  
# Restrict the permissions of the Munge directories
  chown -R munge: /etc/munge/
 chown -R munge: /var/log/munge/
 chown -R munge: /var/lib/munge/
 chown -R munge: /run/munge/
 chmod 0700 /etc/munge/
 chmod 0700 /var/log/munge/
 chmod 0700 /var/lib/munge/
 chmod 0700 /run/munge/
 chmod a+x /run/munge
 chown munge:munge /etc/munge/munge.key
sudo chmod 400 /etc/munge/munge.key

 # Start the Munge daemon
  sudo -u munge /usr/sbin/munged 

  # Test Munge operation
  munge -n
  munge -n | unmunge

}

# copy secrets to /.secret directory for other nodes
_copy_secrets() {
  cp /home/worker/worker-secret.tar.gz /.secret/worker-secret.tar.gz
  cp /home/worker/setup-worker-ssh.sh /.secret/setup-worker-ssh.sh
 # cp /etc/munge/munge.key /.secret/munge.key
  rm -f /home/worker/worker-secret.tar.gz
  rm -f /home/worker/setup-worker-ssh.sh
}


_start_Rstudio() {
  service rstudio-server start