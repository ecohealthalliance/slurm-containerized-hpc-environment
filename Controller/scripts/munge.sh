#!/usr/bin/env bash
set -e


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