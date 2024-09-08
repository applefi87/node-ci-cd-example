#!/bin/bash

# Variables
AWS_REGION="ap-northeast-1"
AWS_ACCOUNT_ID="8464864648684"
ECR_URL="$AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com"
IMAGE_NAME="node-ci-cd-example"

# Pull the image from ECR
docker pull "$ECR_URL/$IMAGE_NAME:latest"

# Stop and remove old container if exists
docker stop node-app || true
docker rm node-app || true

# Run the new container
docker run -d --name node-app -p 80:3000 "$ECR_URL/$IMAGE_NAME:latest"

# Reload nginx (assuming you have nginx set up to route to this container)
sudo systemctl reload nginx
