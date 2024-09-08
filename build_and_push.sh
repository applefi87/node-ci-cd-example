#!/bin/bash
set -x

echo "Starting build and push process..."

# ECR repo variables
AWS_REGION="${AWS_REGION:-ap-northeast-1}"  # Default to ap-northeast-1 if not set
AWS_ACCOUNT_ID="${AWS_ACCOUNT_ID}" 
ECR_URL="$AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com"

# Authenticate Docker to your ECR
echo "Authenticating Docker with ECR..."
aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $ECR_URL
LOGIN_STATUS=$?
if [ $LOGIN_STATUS -ne 0 ]; then
  echo "Docker login to ECR failed!" >&2
  exit 1
fi
# Build the Docker image
echo "Building Docker image..."
docker build -t my-app .
BUILD_STATUS=$?
if [ $BUILD_STATUS -ne 0 ]; then
  echo "Docker build failed!" >&2
  exit 1
fi

# Tag the Docker image with ECR URL
echo "Tagging Docker image..."
docker tag my-app:latest $ECR_URL/my-app:latest
TAG_STATUS=$?
if [ $TAG_STATUS -ne 0 ]; then
  echo "Docker tag failed!" >&2
  exit 1
fi

# Push the image to ECR
echo "Pushing Docker image to ECR..."
docker push $ECR_URL/my-app:latest
PUSH_STATUS=$?
if [ $PUSH_STATUS -ne 0 ]; then
  echo "Docker push to ECR failed!" >&2
  exit 1
fi

# Log successful completion
echo "Build and push process completed successfully!"

# Disable command tracing after the critical part
set +x