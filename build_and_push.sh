#!/bin/bash

# Variables
AWS_REGION="${AWS_REGION:-ap-northeast-1}"  # Default to ap-northeast-1 if not set
AWS_ACCOUNT_ID="${AWS_ACCOUNT_ID}" 
ECR_URL="$AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com"
IMAGE_NAME="my-node-app"

# Login to AWS ECR
aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin "$ECR_URL"

# Build the Docker image
docker build -t $IMAGE_NAME .

# Tag the image
docker tag $IMAGE_NAME:latest "$ECR_URL/$IMAGE_NAME:latest"

# Push the image to ECR
docker push "$ECR_URL/$IMAGE_NAME:latest"
