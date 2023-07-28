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

# slurm database user settings
_slurm_acct_db() {
  {
    echo "CREATE DATABASE IF NOT EXISTS slurm_acct_db;"
    echo "CREATE USER IF NOT EXISTS '${STORAGE_USER}'@'localhost';"
    echo "SET PASSWORD FOR '${STORAGE_USER}'@'localhost' = PASSWORD('${STORAGE_PASS}');"
    echo "GRANT USAGE ON *.* TO '${STORAGE_USER}'@'localhost';"
    echo "GRANT ALL PRIVILEGES ON slurm_acct_db.* TO '${STORAGE_USER}'@'localhost';"
    echo "FLUSH PRIVILEGES;"
  } >> $SLURM_ACCT_DB_SQL
}

# start database
# start database
_mariadb_start() {
  if [ ! -d "/var/lib/mysql/mysql" ]; then
    mysql_install_db
  fi
  mkdir -p /var/run/mysqld
  chown -R mysql: /var/lib/mysql /var/log/mysql /var/run/mysqld
  cd /var/lib/mysql
  mysqld_safe --user=mysql &
  cd /
  _slurm_acct_db
  sleep 5s
  mysql -uroot < $SLURM_ACCT_DB_SQL
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
  cat > /usr/local/etc/slurmdbd.conf<<EOF
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
DbdAddr=database
DbdHost=database
DbdPort=6819
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
StoragePass=password
StorageUser=slurm
StorageLoc=slurm_acct_db
EOF
}

# run slurmdbd
_slurmdbd() {
  mkdir -p /var/spool/slurm/d \
    /var/log/slurm
  chown slurm: /var/spool/slurm/d \
    /var/log/slurm
  if [[ ! -f /home/config/slurmdbd.conf ]]; then
    echo "### generate slurmdbd.conf ###"
    _generate_slurmdbd_conf
  else
    echo "### use provided slurmdbd.conf ###"
    cp /home/config/slurmdbd.conf  /usr/local/etc/slurmdbd.conf
  fi
  chmod 600 /usr/local/etc/slurmdbd.conf
  chown slurm: /usr/local/etc/slurmdbd.conf

  /usr/local/sbin/slurmdbd
  cp /usr/local/etc/slurmdbd.conf /.secret/slurmdbd.conf
}


### main ###
_sshd_host
_mariadb_start
_munge_start_using_key
_wait_for_worker
_slurmdbd

tail -f /dev/null
