#!/bin/bash

# Define variables
REGION="ap-south-1"  # AWS region
ACCOUNT_ID="654654277756"  # Your AWS account ID
REPOSITORY_NAME="node-repo"  # ECR repository name
IMAGE_TAG="latest"  # Tag of the image you want to pull

# Function to stop and remove existing container
function stop_existing_container {
    echo "Stopping existing container..."
    docker stop my-node-app || true
    docker rm my-node-app || true
}

# Function to authenticate and pull Docker image from ECR
function pull_and_run_container {
    echo "Authenticating Docker to ECR..."
    aws ecr get-login-password --region $REGION | docker login --username AWS --password-stdin $ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com

    echo "Pulling Docker image from ECR..."
    docker pull $ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/$REPOSITORY_NAME/nodeimage:$IMAGE_TAG

    echo "Running Docker container..."
    docker run -d --name my-node-app -p 3000:3000 $ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/$REPOSITORY_NAME/nodeimage:$IMAGE_TAG
}

# Function to validate if the application is running
function validate_service {
    if curl -s http://localhost:3000; then
        echo "Application is running successfully."
        exit 0
    else
        echo "Application failed to start."
        exit 1
    fi
}

# Execute functions
stop_existing_container
pull_and_run_container
validate_service
