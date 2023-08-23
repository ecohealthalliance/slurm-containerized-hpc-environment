#!/usr/bin/env bash
set -e

cp /home/worker/worker-secret.tar.gz /.secret/worker-secret.tar.gz
  cp /home/worker/setup-worker-ssh.sh /.secret/setup-worker-ssh.sh
  cp /etc/munge/munge.key /.secret/munge.key
  rm -f /home/worker/worker-secret.tar.gz
  rm -f /home/worker/setup-worker-ssh.sh