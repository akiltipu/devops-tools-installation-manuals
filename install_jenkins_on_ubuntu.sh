#!/bin/bash

# Update the package list
sudo apt update

# Add Jenkins repository key
sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
    https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key

#Then add a Jenkins apt repository entry:
    
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
    https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
    /etc/apt/sources.list.d/jenkins.list > /dev/null

# Update the package list
sudo apt update

# Install Java (Jenkins requires Java)
sudo apt-get install fontconfig openjdk-17-jre -y
# Add Jenkins repository to sources list
# echo "deb http://pkg.jenkins.io/debian-stable binary/" | sudo tee -a /etc/apt/sources.list.d/jenkins.list

# Update package list again to include Jenkins repository
sudo apt update

# Install Jenkins
sudo apt install -y jenkins

# Start Jenkins service
sudo systemctl start jenkins

# Enable Jenkins to start on boot
sudo systemctl enable jenkins

# Display initial Jenkins admin password
echo "Waiting for Jenkins to start..."
sleep 60  # Wait for Jenkins to fully start (adjust if needed)

# Retrieve the initial admin password
# JENKINS_PASSWORD=$(sudo cat /var/lib/jenkins/secrets/initialAdminPassword)
# echo "Jenkins initial admin password: $JENKINS_PASSWORD"

echo -e "===========Initial Admin Password ===========\n"
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
echo -e "\n"
echo -e "===========Initial Admin Password ==========="

echo "Access Jenkins at http://your-server-ip:8080"

# Open the firewall to allow access to Jenkins
sudo ufw allow 8080

# Display Jenkins status
sudo systemctl status jenkins | cat
