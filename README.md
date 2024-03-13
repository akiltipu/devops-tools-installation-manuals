# Devops Tools Installation Manuals
My installation guides and bash scripts for essential DevOps tools like Jenkins (CI/CD), Nexus (artifact repository), SonarQube (code analysis), Docker (containerization), Trivy (vulnerability scanning), etc... on Ubuntu Based Server like EC2, Droplet, Linode.



**Expand Dropdown for Details Installation Guideline:**

<details>
<summary>Install Jenkins on Ubuntu Server</summary>
<br>
  
Update the package list
```bash
sudo apt update
```

Add Jenkins repository key

```bash
sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
```

Then add a Jenkins apt repository entry:

```bash
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
/etc/apt/sources.list.d/jenkins.list > /dev/null
```
Update the package list

```bash 
sudo apt update
```
Install Java (Jenkins requires Java)
```bash
sudo apt-get install fontconfig openjdk-17-jre -y
```
Add Jenkins repository to sources list
```bash
echo "deb http://pkg.jenkins.io/debian-stable binary/" | sudo tee -a /etc/apt/sources.list.d/jenkins.list
```
Update package list again to include Jenkins repository
```bash
sudo apt update
```
Install Jenkins
```bash
sudo apt install -y jenkins
```
Start Jenkins service
```bash
sudo systemctl start jenkins
```
Enable Jenkins to start on boot
```bash
sudo systemctl enable jenkins
```
Display initial Jenkins admin password
```bash
echo "Waiting for Jenkins to start..."
sleep 60 # Wait for Jenkins to fully start (adjust if needed)
```
Retrieve the initial admin password
```bash
JENKINS_PASSWORD=$(sudo cat /var/lib/jenkins/secrets/initialAdminPassword)
echo "Jenkins initial admin password: $JENKINS_PASSWORD"
echo "Access Jenkins at http://your-server-ip:8080"
```
Open the firewall to allow access to Jenkins
```bash
sudo ufw allow 8080
```
Display Jenkins status
```bash
sudo systemctl status jenkins | cat
```
</details>


<details>
<summary>Install Nexus Artifact Repository on Ubuntu Server</summary>
<br>
  
Create Ubuntu Server (Droplet) - min 4GB RAM & 2 CPUs
Open SSH port 22, 8081
  
#### Nexus Installation Guide on Ubuntu

Update the package list:

```bash
sudo apt update
``` 
Install OpenJDK 8:

```bash 
sudo apt install openjdk-8-jre-headless
``` 
Install net-tools:
```bash 
sudo apt install net-tools
``` 
Navigate to the `/opt` directory:
```bash
cd /opt
``` 
Download and extract Nexus:
```bash
sudo wget https://download.sonatype.com/nexus/3/latest-unix.tar.gz
sudo tar -zxvf latest-unix.tar.gz
``` 
Create a Nexus user:
```bash
sudo adduser nexus
``` 
Set ownership for Nexus directories:
```bash
sudo chown -R nexus:nexus nexus-3.28.1-01
sudo chown -R nexus:nexus sonatype-work
``` 
Edit Nexus runtime configuration:
```bash
sudo vim nexus-3.28.1-01/bin/nexus.rc
```
Inside `nexus.rc`, set the `run_as_user` variable to `"nexus".`
```bash
run_as_user="nexus"
```
Save and exit the editor.

Switch to the Nexus user:
```bash
sudo su - nexus
``` 
Start Nexus:
```bash 
/opt/nexus-3.28.1-01/bin/nexus start
```
Check Nexus process status:
```bash
ps aux | grep nexus
```
Check Nexus port status:
```bash
netstat -lnpt
``` 
Now, Nexus should be up and running on your Ubuntu system. You can access the Nexus web interface by navigating to `http://your_server_ip:8081` in a web browser.
</details>

<details>
<summary>Install SonarQube on Ubuntu Server</summary>
<br>
  
**Pull SonarQube Image:**
     
```bash
    docker pull sonarqube
```
**Create Docker Network:**
    
```bash
    docker network create sonar-network
```
**Run PostgreSQL Database Container:**
```bash
    docker run -d --name sonar-db --network sonar-network \
    -e POSTGRES_USER=sonar \
    -e POSTGRES_PASSWORD=sonar \
    -e POSTGRES_DB=sonar \
    postgres:9.6
```
 -   `-d`: Detached mode, run container in the background.
 -   `--name sonar-db`: Assign a name to the container.
 -   `--network sonar-network`: Connect container to the created network.
 -   `-e POSTGRES_USER=sonar`: Set PostgreSQL username to 'sonar'.
 -   `-e POSTGRES_PASSWORD=sonar`: Set PostgreSQL password to 'sonar'.
 -   `-e POSTGRES_DB=sonar`: Create a database named 'sonar' in PostgreSQL.
 
 **Run SonarQube Container:**
    
```bash
    docker run -d --name sonar -p 9000:9000 --network sonar-network \
    -e SONARQUBE_JDBC_URL=jdbc:postgresql://sonar-db:5432/sonar \
    -e SONAR_JDBC_USERNAME=sonar \
    -e SONAR_JDBC_PASSWORD=sonar \
    sonarqube
```
    
   -   `-d`: Detached mode, run container in the background.
    -   `--name sonar`: Assign a name to the SonarQube container.
    -   `-p 9000:9000`: Map container's port 9000 to host's port 9000.
    -   `--network sonar-network`: Connect container to the created network.
    -   `-e SONARQUBE_JDBC_URL=jdbc:postgresql://sonar-db:5432/sonar`: Set JDBC URL to connect SonarQube to the PostgreSQL database.
    -   `-e SONAR_JDBC_USERNAME=sonar`: Set SonarQube's database username.
    -   `-e SONAR_JDBC_PASSWORD=sonar`: Set SonarQube's database password.
    
 **Access SonarQube:**
 After running the container, you can access SonarQube by navigating to `http://localhost:9000` in your web browser. The default credentials are:
 - Username: admin
 - Password: admin

This setup will allow you to use SonarQube for static code analysis on your projects with the PostgreSQL database backend.


</details>
