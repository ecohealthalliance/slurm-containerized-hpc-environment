# Slurm Configuration for Cluster1

This Slurm configuration file, named `slurm.conf`, is designed for configuring and managing a cluster named "megatron." It is intended to be used with the Slurm workload manager to efficiently allocate computing resources and manage jobs across the cluster.

## Cluster Configuration

- **Cluster Name:** The cluster is named "megatron."
- **Slurmctld Host:** The Slurm controller daemon (slurmctld) runs on the host named "controller."
- **Slurm User:** Slurm-related processes run under the user "slurm."

## Networking Configuration

- **Slurmctld Port:** Slurmctld listens on port 6817 for incoming connections.
- **Slurmd Port:** Slurmd (Slurm daemon on compute nodes) listens on port 6819.
- **Authentication:** Munge authentication is used to secure communication between Slurm components.

## File and Directory Configuration

- **State Save Location:** Slurm state files are stored in the `/var/spool/slurm/ctld` directory.
- **Slurmd Spool Directory:** Slurm daemon (slurmd) spool files are stored in the `/var/spool/slurm/d` directory.

## Scheduling Configuration

- **Scheduler Type:** The scheduling algorithm used is "backfill."
- **Debug Flags:** Debug flags include "cgroup" for monitoring resource usage.
  
## Timing Configuration

- **Timeouts:** Various timeouts are configured for slurmctld and slurmd.
- **Inactive Limit:** Jobs with an inactive state are set to terminate after 0 seconds.
- **Min Job Age:** Jobs must be at least 300 seconds old before they can be considered for preemption.
- **Kill Wait:** Slurm waits for 30 seconds before killing a job that exceeds its time limit.
- **Wait Time:** There is no waiting time for job scheduling.

## Logging Configuration

- **Slurmctld Debug Level:** Slurmctld logs have a debug level of 3 and are written to `/var/log/slurmctld.log`.
- **Slurmd Debug Level:** Slurmd logs have a debug level of 3 and are written to `/var/log/slurmd.log`.
- **Job Completion Logging:** Job completion logging is disabled (`jobcomp/none`).

## Accounting Configuration

- **Job Accounting Gathering:** Job accounting information is collected using the "linux" method.
- **Accounting Storage:** Job accounting data is stored in a Slurm database daemon (slurmdbd) on the host "controller."

## Compute Node Configuration

- **Nodes:** The cluster consists of four nodes named worker01 to worker04.
- **Node Resources:** Each node has 40 CPUs and an unknown amount of real memory.
  
## Partitions Configuration

- **Partition: non-gpu**
  - **Nodes:** Nodes worker01 and worker02 are part of this partition.
  - **Default:** This partition is the default for submitted jobs.
  - **Max Time:** Jobs in this partition can run for an infinite amount of time.
  - **Max Memory per CPU:** Each CPU in this partition has a maximum memory limit of 6.6 GB.

- **Partition: gpu**
  - **Nodes:** Nodes worker03 and worker04 are part of this partition.
  - **Default:** This partition is the default for submitted jobs.
  - **Max Time:** Jobs in this partition can run for an infinite amount of time.
  - **Max Memory per CPU:** Each CPU in this partition has a maximum memory limit of 13.2 GB.

This configuration file defines the basic setup for the "cluster1" Slurm cluster. It specifies how resources are allocated, how jobs are scheduled, and how job accounting is managed. Users can submit jobs to this cluster, taking into account the defined partitions and resource limits.



# SlurmDBD Configuration for Cluster1

This SlurmDBD configuration file, named `slurmdbd.conf`, is used to configure the Slurm Database Daemon (SlurmDBD) for managing accounting and job data in the "cluster1" Slurm cluster.

## Archive Configuration

- **Archive Jobs:** Job archiving is enabled but currently set to "no."
- **Archive Directory:** The directory for storing archived job data is not specified.
- **Archive Steps:** Archiving of job steps is enabled.
- **Archive Script:** There is no specified script for archiving.
- **Job Purge:** Jobs are purged after 12 months.
- **Step Purge:** Job steps are purged after 1 month.

## Authentication Configuration

- **Authentication Type:** Munge authentication is used for secure communication.
- **Authentication Information:** Munge socket information is specified as `/var/run/munge/munge.socket.2`.

## SlurmDBD Configuration

- **Database Address:** SlurmDBD communicates with the database server using the hostname "database."
- **Database Host:** The host where the database is located is set to "database."
- **Database Port:** SlurmDBD communicates with the database server on port 6819.
- **Slurm User:** Slurm-related processes run under the user "slurm."
- **Debug Level:** Debug level is set to 4.
- **Log File:** SlurmDBD logs are written to `/var/log/slurm/slurmdbd.log`.
- **PID File:** SlurmDBD process ID is stored in `/var/run/slurmdbd.pid`.

## Database Configuration

- **Storage Type:** SlurmDBD uses MySQL as the accounting storage.
- **Storage Host:** The MySQL database server "
- **Storage Port:** Communication with the MySQL server is on port 3306.
- **Storage Password:** The MySQL user  authenticates 
- **Storage User:** SlurmDBD connects to the MySQL server as the user"
- **Storage Location:** Accounting and job data are stored in the database named ."

This configuration file defines how SlurmDBD interacts with the database server, manages data archiving, and handles authentication for secure communication. It plays a crucial role in storing and retrieving accounting and job information for the "cluster1" Slurm cluster.

Make sure to customize the database-related parameters according to your specific database server setup and security considerations.


# User Management
Uses uses sacctmgr to manage users who can execute/submit jobs through slurm. Users need have to be part of slurm group inorder to run slurm

- add user to slurm account       sudo sacctmgr add user name=rstudio account=admin 
- add accounts to slurm cluster   sudo sacctmgr add account name=texas Description="project repel"