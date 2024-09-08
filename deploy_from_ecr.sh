#!/bin/bash

# ECR repo variables
AWS_REGION="${AWS_REGION:-ap-northeast-1}"  # Default to ap-northeast-1 if not set
AWS_ACCOUNT_ID="${AWS_ACCOUNT_ID}"
ECR_URL="$AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com"

echo "Logging in to ECR..."
aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $ECR_URL
docker pull $ECR_URL/my-node-app:latest

echo "Checking for existing containers..."
EXISTING_CONTAINER=$(docker ps -aq -f name=my-node-app)
if [ "$EXISTING_CONTAINER" ]; then
    echo "Stopping and removing existing container: $EXISTING_CONTAINER"
    docker stop $EXISTING_CONTAINER
    docker rm $EXISTING_CONTAINER
else
    echo "No existing container found. Proceeding to start a new one."
fi

echo "Starting new container..."
CONTAINER_ID=$(docker run -d --name my-node-app -p 80:3000 $ECR_URL/my-node-app:latest)
if [ $? -eq 0 ]; then
    echo "Container started successfully. Container ID: $CONTAINER_ID"
else
    echo "Failed to start container."
fi

echo "Checking container logs..."
docker logs $CONTAINER_ID

echo "Checking NGINX status..."
systemctl status nginx --no-pager
systemctl is-active nginx

if ! systemctl is-active --quiet nginx; then
    echo "NGINX is not active. Starting NGINX..."
    sudo systemctl restart nginx
    echo "NGINX has been restarted."
else
    echo "NGINX is already running."
fi
