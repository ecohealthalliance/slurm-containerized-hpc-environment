#!/usr/bin/env bash
set -e


# Create directories
echo "Creating /var/spool/slurm/ctld, /var/spool/slurm/d  directories..."
mkdir -p /var/spool/slurm/ctld /var/spool/slurm/d 
echo "Finished creating directories."
[ -d "/var/spool/slurm/ctld" ] || log_msg "Failed to create /var/spool/slurm/ctld directory"
[ -d "/var/spool/slurm/d" ] || log_msg "Failed to create /var/spool/slurm/d directory"

#Create slurm log file
touch /var/log/slurm.log

# Change ownership
chown -R slurm: /var/spool/slurm/ctld /var/spool/slurm/d /var/log/slurm.log


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