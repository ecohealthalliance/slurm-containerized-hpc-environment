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
  if [ ! -f /etc/slurm/slurm.conf ]; then
    echo -n "cheking for slurm.conf"
    while [ ! -f /etc/slurm//slurm.conf ]; do
      echo -n "."
      sleep 1
    done
    echo ""
  fi


# Helper function to log messages and echo them
log_msg() {
    echo "$1" | tee -a $LOGFILE
}

# Create directories
echo "Creating /var/spool/slurm/ctld, /var/spool/slurm/d, and /var/log/slurm directories..."
mkdir -p /var/spool/slurm/ctld /var/spool/slurm/d /var/log/slurm
echo "Finished creating directories."
[ -d "/var/spool/slurm/ctld" ] || log_msg "Failed to create /var/spool/slurm/ctld directory"
[ -d "/var/spool/slurm/d" ] || log_msg "Failed to create /var/spool/slurm/d directory"
[ -d "/var/log/slurm" ] || log_msg "Failed to create /var/log/slurm directory"

# Change ownership
chown -R slurm: /var/spool/slurm/ctld /var/spool/slurm/d /var/log/slurm

# Touch and chown log files
for logfile in /var/log/slurmctld.log /var/log/slurm.log /var/log/slurm/slurmdbd.log /var/log/slurmd.log; do
    echo "Creating $logfile..."
    touch $logfile
    echo "Finished creating $logfile."
    [ -f "$logfile" ] || log_msg "Failed to create $logfile file"
    chown slurm: $logfile
    [ "$(stat -c %U $logfile)" = "slurm" ] || log_msg "Failed to chown $logfile to slurm"
done

# Chown config files
for conf_file in /etc/slurm/slurm.conf /etc/slurm/slurmdbd.conf; do
    chown slurm: $conf_file
    [ "$(stat -c %U $conf_file)" = "slurm" ] || log_msg "Failed to chown $conf_file to slurm"
done

# Change permissions for config files
chmod 600 /etc/slurm/slurmdbd.conf
[ "$(stat -c %a /etc/slurm/slurmdbd.conf)" = "600" ] || log_msg "Failed to set permissions for /etc/slurm/slurmdbd.conf"

chmod 600 /etc/slurm/slurm.conf
[ "$(stat -c %a /etc/slurm/slurm.conf)" = "600" ] || log_msg "Failed to set permissions for /etc/slurm/slurm.conf"

chmod 644 /etc/slurm/slurm.conf
[ "$(stat -c %a /etc/slurm/slurm.conf)" = "644" ] || log_msg "Failed to reset permissions for /etc/slurm/slurm.conf"

# Create cgroup directory
echo "Creating /sys/fs/cgroup/system.slice directory..."
mkdir -p /sys/fs/cgroup/system.slice
echo "Finished creating /sys/fs/cgroup/system.slice directory."
[ -d "/sys/fs/cgroup/system.slice" ] || log_msg "Failed to create /sys/fs/cgroup/system.slice directory"

#make slurm.conf writable by slurm group
 chmod 644 /etc/slurm/slurm.conf
 chmod g+r /etc/slurm/slurm.conf


usermod -aG slurm rstudio 
usermod -aG slurm worker
  #create directory /sys/fs/cgroup/system.slice
  #create cgroup config file /etc/slurm/cgroup.conf

 #start slurm service
  /usr/sbin/slurmd
}

### main ###
_sshd_host
_munge_start_using_key
_wait_for_worker
_slurmd

tail -f /dev/null