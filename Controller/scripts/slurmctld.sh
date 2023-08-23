#!/usr/bin/env bash
set -e

 
 # Check if slurmbd is up and running
  for i in {1..2}; do
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

