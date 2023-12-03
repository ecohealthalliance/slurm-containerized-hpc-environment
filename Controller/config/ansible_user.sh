#!/bin/bash
set -e

# User and group names
USER="ansible"
SUDO_GROUP="sudo"
SSH_USERS_GROUP="ssh-users"

# Password for the "ansible" user
PASSWORD="kangaroo679bike432ear"

# Add the "ansible" user to the sudo group
usermod -aG $SUDO_GROUP $USER

# Add the "ansible" user to the ssh-users group
usermod -aG $SSH_USERS_GROUP $USER

# Set the password for the "ansible" user
echo "$USER:$PASSWORD" | chpasswd

echo "User '$USER' has been added to the '$SUDO_GROUP' group and '$SSH_USERS_GROUP' group."
echo "The password for '$USER' has been set."
