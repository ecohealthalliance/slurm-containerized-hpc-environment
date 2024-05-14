#!/usr/bin/env bash
set -e

# start munge using existing key
_munge_start_using_key() {
  echo -n "cheking for munge.key"
  while [ ! -f /work/.secrets/munge.key  ]; do
    echo -n "."
    sleep 1
  done
  echo ""
  mkdir -p /var/run/munge
  #cp /work/.secrets/munge.key  /etc/munge/munge.key
  cp  ./secret/munge.key  /etc/munge/munge.key
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


### main ###
_munge_start_using_key