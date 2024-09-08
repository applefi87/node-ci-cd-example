#!/bin/bash
# ECR repo variables
AWS_REGION="${AWS_REGION:-ap-northeast-1}"  # Default to ap-northeast-1 if not set
AWS_ACCOUNT_ID="${AWS_ACCOUNT_ID}" 
ECR_URL="$AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com"

# Authenticate Docker to your ECR
aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $ECR_URL

# Build Docker image
docker build -t my-app .

# Tag the Docker image
docker tag my-app:latest $ECR_URL:latest

# Push to ECR
docker push $ECR_URL:latest

# For PRs, add a step to run tests (example):
if [ "$1" == "pr" ]; then
    docker run --rm -d --name test-container my-app:latest
    # Perform test actions here (health checks, etc.)
    docker stop test-container
    docker rm test-container
fi
