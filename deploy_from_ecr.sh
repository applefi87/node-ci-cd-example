
#!/bin/bash
# ECR repo variables
export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
AWS_REGION="${AWS_REGION:-ap-northeast-1}"  # Default to ap-northeast-1 if not set
AWS_ACCOUNT_ID="${AWS_ACCOUNT_ID}" 
ECR_URL="$AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com"

# Pull the latest image from ECR
aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $ECR_URL
docker pull $ECR_URL:latest

# Stop and remove the old container (if it exists)
docker stop my-app || true
docker rm my-app || true

# Run the new container
docker run -d --name my-app -p 80:3000 $ECR_URL:latest

# Replace NGINX config to point to new container if needed and reload NGINX
sudo cp /path/to/nginx-config /etc/nginx/nginx.conf
sudo systemctl reload nginx
