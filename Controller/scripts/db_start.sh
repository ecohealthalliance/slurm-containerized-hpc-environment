#!/usr/bin/env bash
set -e

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


### main ###
_mariadb_start
_slurm_acct_db