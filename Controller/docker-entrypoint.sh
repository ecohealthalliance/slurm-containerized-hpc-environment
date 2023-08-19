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


 service munge start 
}

# copy secrets to /.secret directory for other nodes
_copy_secrets() {
  cp /home/worker/worker-secret.tar.gz /.secret/worker-secret.tar.gz
  cp /home/worker/setup-worker-ssh.sh /.secret/setup-worker-ssh.sh
  cp /etc/munge/munge.key /.secret/munge.key
  rm -f /home/worker/worker-secret.tar.gz
  rm -f /home/worker/setup-worker-ssh.sh
}



SLURM_ACCT_DB_SQL=/slurm_acct_db.sql

# start database
_mariadb_start() {
  # mariadb somehow expects `resolveip` to be found under this path; see https://github.com/SciDAS/slurm-in-docker/issues/26
  mysql_install_db
  mkdir -p /var/log/mariadb /var/run/mariadb
  mkdir -p /run/mysqld && chown mysql:mysql /run/mysqld
  chown -R mysql: /var/lib/mysql/ /var/log/mariadb/ /var/run/mariadb
  mysqld_safe --user=mysql --bind-address=0.0.0.0 &
  sleep 10s # Give MariaDB time to start
  _slurm_acct_db
  mysql -uroot < $SLURM_ACCT_DB_SQL || echo "Error executing SQL script"
}

_slurm_acct_db() {
  # Write SQL commands to the file directly, not appending
  echo "CREATE DATABASE IF NOT EXISTS slurm_acct_db;" > $SLURM_ACCT_DB_SQL
  echo "CREATE USER IF NOT EXISTS '${STORAGE_USER}'@'%';" >> $SLURM_ACCT_DB_SQL
  echo "SET PASSWORD FOR '${STORAGE_USER}'@'%' = PASSWORD('${STORAGE_PASS}');" >> $SLURM_ACCT_DB_SQL
  echo "GRANT USAGE ON *.* TO '${STORAGE_USER}'@'%';" >> $SLURM_ACCT_DB_SQL
  echo "GRANT ALL PRIVILEGES ON slurm_acct_db.* TO '${STORAGE_USER}'@'%';" >> $SLURM_ACCT_DB_SQL
  echo "FLUSH PRIVILEGES;" >> $SLURM_ACCT_DB_SQL
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
   chown slurm:  /etc/slurm/slurmdbd.conf
  chmod 600 /etc/slurm/slurmdbd.conf
  chmod 600 /etc/slurm/slurm.conf

  # Start slurmbd service
  /usr/sbin/slurmdbd

   # Check if slurmbd is up and running
  for i in {1..5}; do
    if pgrep -x "slurmbd" > /dev/null; then
      break
    fi
    echo "Waiting for slurmbd to start..."
    sleep 5
  done

  # If slurmbd isn't running after waiting, exit
  if ! pgrep -x "slurmdbd" > /dev/null; then
    echo "Error: slurmdbd failed to start!"
    exit 1
  fi

  # Start slurmctld service
    /usr/sbin/slurmctld 
}


### main ###
_sshd_host
_ssh_worker
_munge_start
_copy_secrets
_mariadb_start
_start_Rstudio
_slurmctld



tail -f /dev/null