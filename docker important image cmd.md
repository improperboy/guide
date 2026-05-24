# Pull SonarQube image
docker pull sonarqube

# Run SonarQube container
docker run -d --name sonarqube -p 9000:9000 sonarqube

# Pull Node.js image
docker pull node

# Run Node.js container
docker run -it --name nodeapp node bash

# Pull Open Policy Agent (OPA) image
docker pull openpolicyagent/opa

# Run OPA container
docker run -it --name opa openpolicyagent/opa run --server
