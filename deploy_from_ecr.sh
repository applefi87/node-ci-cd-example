
#!/bin/bash
# ECR repo variables
export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
AWS_REGION="${AWS_REGION:-ap-northeast-1}"  # Default to ap-northeast-1 if not set
AWS_ACCOUNT_ID="${AWS_ACCOUNT_ID}" 
ECR_URL="$AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com"

# Pull the latest image from ECR
aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $ECR_URL
docker pull $ECR_URL/my-node-app:latest

# Check if the container is running and stop/remove it if it exists
if [ "$(docker ps -aq -f name=my-node-app)" ]; then
    echo "Stopping and removing existing container..."
    docker stop my-node-app
    docker rm my-node-app
else
    echo "No existing container found. Proceeding to start a new one."
fi

# Run the new container
docker run -d --name my-node-app -p 80:3000 $ECR_URL/my-node-app:latest

# Ensure NGINX is installed and running
if ! systemctl is-active --quiet nginx; then
    echo "Starting NGINX..."
    sudo systemctl restart nginx
else
    echo "NGINX is already running."
fi

