#!/bin/bash

echo "building Docker Image"

docker build -t devops-build-app:v1 .

echo "Docker Image Build Completed"


