#!/bin/bash

# Update the package list
sudo apt update -y

# Install OpenJDK 8
sudo apt install -y openjdk-8-jre-headless

# Install net-tools
sudo apt install -y net-tools

# Navigate to the /opt directory
cd /opt

#Latest Nexus Downlad url
download_url="https://download.sonatype.com/nexus/3/latest-unix.tar.gz"
downloaded_file="latest-unix.tar.gz"

# Download Nexus
sudo wget "$download_url"

# Extract Nexus version from the downloaded file name
nexus_version=$(tar tzf "$downloaded_file" | grep -oP 'nexus-3\.\d+\.\d+-\d+' | head -n 1)

# Extract Nexus
sudo tar -zxvf "$downloaded_file"

# Create a Nexus user (modify as needed for password input)
sudo useradd -m -s /bin/bash -U nexus

# Set password for the Nexus user password: nexus123 
#Change with your own password
echo "nexus:nexus123" | sudo chpasswd

# Set ownership for Nexus directories (checking if nexus_version is set)
if [ -n "$nexus_version" ]; then
  sudo chown -R nexus:nexus "$nexus_version"
  sudo chown -R nexus:nexus sonatype-work
else
  echo "Failed to determine Nexus version. Check the script and try again."
  exit 1
fi

# Edit Nexus runtime configuration (checking if nexus_version is set)
if [ -n "$nexus_version" ]; then
  sudo sed -i 's/^run_as_user=.*/run_as_user="nexus"/' "/opt/$nexus_version/bin/nexus.rc"
else
  echo "Failed to determine Nexus version. Check the script and try again."
  exit 1
fi

# Switch to the Nexus user and start Nexus
sudo su - nexus <<EOF
/opt/$nexus_version/bin/nexus start
EOF

# Wait for 60 seconds to allow Nexus to initialize
echo "Waiting for Nexus to initialize..."
sleep 60

# Check Nexus process status
ps aux | grep nexus

# Check Nexus port status
netstat -lnpt

# Print admin password
echo -e "=========== Admin Password ===========\n"
cat /opt/sonatype-work/nexus3/admin.password
echo -e "\n"
echo -e "=========== Admin Password ==========="