#!/bin/bash
# Bash script to install HashiCorp Terraform via apt

# Update apt package index and install necessary packages
sudo apt-get update && sudo apt-get install -y gnupg software-properties-common

# Download HashiCorp GPG key and add it to the keyring
wget -O- https://apt.releases.hashicorp.com/gpg | \
  gpg --dearmor | \
  sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null

# Display the fingerprint of the HashiCorp GPG key
gpg --no-default-keyring \
  --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg \
  --fingerprint

# Add HashiCorp apt repository to the sources list
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
  https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
  sudo tee /etc/apt/sources.list.d/hashicorp.list

# Update apt package index to include the new repository
sudo apt update

# Install Terraform
sudo apt-get install terraform

# Display Terraform version
terraform -version
