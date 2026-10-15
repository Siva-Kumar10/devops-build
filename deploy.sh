#!/bin/bash

echo "stopping Existing container created with docker compose file"

docker stop dovops-react-app 2>/dev/null || true
docker rm dovops-react-app 2>/dev/null || true

echo "Deploying new container"

docker run -d --name devops-react-app -p 80:80 devops-build-app:v1

echo "Deployment Successful"


