#!/usr/bin/env bash
set -e

SLURM_ACCT_DB_SQL=/slurm_acct_db.sql

# start sshd server
_sshd_host() {
  if [ ! -d /var/run/sshd ]; then
    mkdir /var/run/sshd
    ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key -N ''
  fi
  /usr/sbin/sshd
}

# start database
_mariadb_start() {
  # mariadb somehow expects `resolveip` to be found under this path; see https://github.com/SciDAS/slurm-in-docker/issues/26
  mysql_install_db
  mkdir -p /var/log/mariadb /var/run/mariadb
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




# start munge using existing key
_munge_start_using_key() {
  if [ ! -f /.secret/munge.key ]; then
    echo -n "checking for munge.key"
    while [ ! -f /.secret/munge.key ]; do
      echo -n "."
      sleep 1
    done
    echo ""
  fi
   mkdir -p /var/run/munge /etc/munge /var/log/munge /var/lib/munge
  cp /.secret/munge.key /etc/munge/munge.key
  chown -R munge: /etc/munge /var/lib/munge /var/log/munge /var/run/munge
  chmod 0700 /etc/munge
  chmod 0711 /var/lib/munge
  chmod 0700 /var/log/munge
  chmod 0755 /var/run/munge
  sudo -u munge /usr/sbin/munged
  munge -n
  munge -n | unmunge
  remunge
}

# wait for worker user in shared /home volume
_wait_for_worker() {
  if [ ! -f /home/worker/.ssh/id_rsa.pub ]; then
    echo -n "checking for id_rsa.pub"
    while [ ! -f /home/worker/.ssh/id_rsa.pub ]; do
      echo -n "."
      sleep 1
    done
    echo ""
  fi
}




# generate slurmdbd.conf
_generate_slurmdbd_conf() {
mkdir -p /etc/slurm
  cat > /etc/slurm/slurmdbd.conf<<EOF
#
# Example slurmdbd.conf file.
#
# See the slurmdbd.conf man page for more information.
#
# Archive info
#ArchiveJobs=yes
#ArchiveDir="/tmp"
#ArchiveSteps=yes
#ArchiveScript=
#JobPurge=12
#StepPurge=1
#
# Authentication info
AuthType=auth/munge
AuthInfo=/var/run/munge/munge.socket.2
#
# slurmDBD info
DbdAddr=database.local.dev
DbdHost=database.local.dev
#DbdPort=3306
SlurmUser=slurm
#MessageTimeout=300
DebugLevel=4
#DefaultQOS=normal,standby
LogFile=/var/log/slurm/slurmdbd.log
PidFile=/var/run/slurmdbd.pid
#PluginDir=/usr/lib/slurm
#PrivateData=accounts,users,usage,jobs
#TrackWCKey=yes
#
# Database info
StorageType=accounting_storage/mysql
StorageHost=database.local.dev
StoragePort=3306
StoragePass=/var/run/munge/munge.socket.2 
StorageUser=slurm
StorageLoc=slurm_acct_db
EOF
}



# run slurmdbd
_slurmdbd() {
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

  if [[ ! -f /home/config/slurmdbd.conf ]]; then
    echo "### generate slurmdbd.conf ###"
    _generate_slurmdbd_conf
  else
    echo "### use provided slurmdbd.conf ###"
    cp /home/config/slurmdbd.conf  /etc/slurm/slurmdbd.conf
  fi
  chmod 600 /etc/slurm/slurmdbd.conf
  chown slurm: /etc/slurm/slurmdbd.conf

  # Start slurmbd service
  /usr/sbin/slurmdbd
  
  cp /etc/slurm/slurmdbd.conf /.secret/slurmdbd.conf
}


### main ###
_sshd_host
_slurm_acct_db
_mariadb_start
_munge_start_using_key
_wait_for_worker
_slurmdbd

tail -f /dev/null
