#!/bin/bash

# Define variables
REGION="ap-south-1"  # AWS region
ACCOUNT_ID="654654277756"  # Your AWS account ID
REPOSITORY_NAME="node-repo"  # ECR repository name
IMAGE_TAG="latest"  # Tag of the image you want to pull
CONTAINER_NAME="my-node-app"  # Name of the container
PORT="3000"  # Port to expose

# Function to authenticate and pull Docker image from ECR
function pull_and_run_image {
    echo "Authenticating Docker to ECR..."
    aws ecr get-login-password --region $REGION | docker login --username AWS --password-stdin $ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com

    echo "Pulling Docker image from ECR..."
    docker pull $ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/$REPOSITORY_NAME/nodeimage:$IMAGE_TAG

    echo "Running Docker container..."
    docker run -d --name $CONTAINER_NAME -p $PORT:$PORT $ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/$REPOSITORY_NAME:$IMAGE_TAG
}

# Execute function
pull_and_run_image

# List all containers, including stopped ones
echo "All containers:"
docker ps -a

# Retrieve the container name
CONTAINER_NAME=$(docker ps -f name=$CONTAINER_NAME -q)

# Print the container name
echo "Container name: $CONTAINER_NAME"
