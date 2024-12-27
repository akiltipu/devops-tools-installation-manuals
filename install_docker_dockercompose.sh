#!/bin/bash

# Update the package lists
sudo apt update

# Install required packages to allow apt to use a repository over HTTPS
sudo apt install -y \
  apt-transport-https \
  ca-certificates \
  curl \
  software-properties-common

# Add Docker's official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Add the Docker stable repository
echo "deb [signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update the package list again
sudo apt update

# Install the latest version of Docker
sudo apt install -y docker-ce docker-ce-cli containerd.io

# Verify that Docker is installed and running
sudo docker --version

# Allow Docker to be run without sudo (non-root users)
sudo usermod -aG docker $USER

# Activate the changes to the user's group without requiring a logout/login
newgrp docker

# Source the profile to apply changes in the current shell session
source /etc/profile

# Print a message indicating that Docker installation completed
echo "Docker installation completed."

# Fetch the latest stable Docker Compose release version from GitHub API
COMPOSE_VERSION=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep -Po '"tag_name": "\K.*\d')

# Installing Docker Compose
sudo curl -SL "https://github.com/docker/compose/releases/download/${COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/bin/docker-compose

# Give execute permissions to Docker Compose
sudo chmod +x /usr/bin/docker-compose

# Verify that Docker Compose is installed
docker-compose --version

# Print a message indicating that Docker Compose installation completed
echo "Docker Compose installation completed."
