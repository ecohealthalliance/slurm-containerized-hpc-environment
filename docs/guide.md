# Step 1: Build or Modify SLURM Images

Create Docker images for the SLURM controller and the worker nodes. We could use an Ubuntu base image and install SLURM and its dependencies.

# Step 2: Modify the Image 

Modify the existing Reservoir image to include SLURM client utilities, which will allow users to submit jobs directly from the RStudio interface.
Reservoir worker and client node



# Step 3: Define Your Infrastructure As Code Using Ansible

Create Ansible playbooks to define and manage your infrastructure. These should include playbooks for:

Deploying the SLURM controller and worker nodes.
Modifying your Reservoir image to include SLURM client utilities.
Configuring NFS and shared storage to work with SLURM.

# Step 4: Test Your Setup

Create a test environment and use Ansible playbooks to deploy SLURM. Test a variety of job types and resource requests to ensure that SLURM is correctly managing resources.

# Step 5: Train Your Users

Before deploying SLURM to your production environment, We train your users on how to submit jobs from the RStudio interface in the Reservoir container.
Documentation 

# Step 6: Deploy SLURM to Your Production Environment

Once you  confident that  setup is working as expected,  We will use Ansible to deploy SLURM to  production environment.

# Step 7: Monitor Your Deployment

Use SLURM's built-in tools and any other preferred tools to monitor your cluster and ensure that it is working as expected.


# PHASE 1
1. Create Dockerfile for SLURM Controller
2. Create Dockerfile for SLURM Worker Node

# PHASE 2 Modify the Reservoir Image
         Modify the existing Reservoir image to include SLURM client utilities, which will allow users to submit jobs directly from the RStudio interface.
# PHASE 3  Define Your Infrastructure As Code Using Ansible    
    Create Ansible playbooks to define and manage your infrastructure. These should include playbooks for:
                1. Deploying the SLURM controller and worker nodes.
                 2.Modifying your Reservoir image to include SLURM client utilities.
                 3. Configuring NFS and shared storage to work with SLURM.

# PHASE 4  Test  Setup
  Create a test environment and use  Ansible playbooks to deploy SLURM. Test a variety of job types and resource requests to ensure that SLURM is correctly managing resources.


  During initial build 
  - Created containers for both controller and worker node 
  - Consideration 1. ensure that this slurm.conf file is accessible to all nodes in your cluster
                  2. ensure Docker containers can communicate using the hostnames specified in the slurm.conf file, you may create a Docker network for the SLURM cluster( For this since we are using prospero we have to configure network communication between the host and the containers)
                  3. Save all slurm logs on the host machine 
                  4. Mount /archive on slurm as a volume
                  5. Add reservoir with slurm configurations  
# Create network for containers to connect 
        # Create a new network
  docker network create mynetwork

# Connect the MariaDB container to the network
    docker network connect mynetwork slurm-mariadb

# Connect the Slurm container to the network
    docker network connect mynetwork your_slurm_container
