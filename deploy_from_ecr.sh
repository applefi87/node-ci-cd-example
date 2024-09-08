#!/bin/bash

# Variables
AWS_REGION="${AWS_REGION:-ap-northeast-1}"  # Default to ap-northeast-1 if not set
AWS_ACCOUNT_ID="${AWS_ACCOUNT_ID}" 
ECR_URL="$AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com"
IMAGE_NAME="my-node-app"
CONTAINER_NAME=node-app-container

# Pull the image from ECR
docker pull "$ECR_URL/$IMAGE_NAME:latest"

# Stop and remove old container if exists
docker stop $CONTAINER_NAME || true
docker rm $CONTAINER_NAME || true

# Run the new container
docker run -d --name $CONTAINER_NAME -p 80:3000 "$ECR_URL/$IMAGE_NAME:latest"

# Health check (optional)
curl -f http://localhost:80 || (echo "Health check failed!" && exit 1)

# Reload nginx (assuming you have nginx set up to route to this container)
sudo systemctl reload nginx
