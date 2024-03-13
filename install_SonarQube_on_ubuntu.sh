# Pull the SonarQube Docker image
docker pull sonarqube

# Create a Docker network for communication between containers
docker network create sonar-network

# Start a PostgreSQL container for the SonarQube database
docker run -d --name sonar-db \
  --network sonar-network \
  -e POSTGRES_USER=sonar \
  -e POSTGRES_PASSWORD=sonar \
  -e POSTGRES_DB=sonar \
  postgres:9.6

# Start the SonarQube container and link it to the PostgreSQL container
docker run -d --name sonar \
  -p 9000:9000 \
  --network sonar-network \
  -e SONARQUBE_JDBC_URL=jdbc:postgresql://sonar-db:5432/sonar \
  -e SONAR_JDBC_USERNAME=sonar \
  -e SONAR_JDBC_PASSWORD=sonar \
  sonarqube