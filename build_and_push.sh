#!/bin/bash

# Variables
AWS_REGION="ap-northeast-1"
AWS_ACCOUNT_ID="8464864648684"
ECR_URL="$AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com"
IMAGE_NAME="node-ci-cd-example"

# Login to AWS ECR
aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin "$ECR_URL"

# Build the Docker image
docker build -t $IMAGE_NAME .

# Tag the image
docker tag $IMAGE_NAME:latest "$ECR_URL/$IMAGE_NAME:latest"

# Push the image to ECR
docker push "$ECR_URL/$IMAGE_NAME:latest"
