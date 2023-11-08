#!/bin/bash

set -e
set -x

# Define the base name for your images using GitHub Container Registry
base_image_name=ghcr.io/ecohealthalliance/slurm-containerized-hpc-environment

# Log in to GitHub Container Registry
echo "Logging in to GitHub Container Registry..."
echo $CR_PAT | docker login ghcr.io -u USERNAME --password-stdin

# Build and push the GPU image for the controller
controller_gpu_image=$base_image_name:controller-gpu
echo "Building the controller GPU image..."
cd Controller
time docker build -f Dockerfile.gpu -t $controller_gpu_image .
echo "Pushing the controller GPU image..."
docker push $controller_gpu_image
cd ..

# Build and push the GPU image for the worker
worker_gpu_image=$base_image_name:worker-gpu
echo "Building the worker GPU image..."
cd worker
time docker build -f Dockerfile.gpu -t $worker_gpu_image .
echo "Pushing the worker GPU image..."
docker push $worker_gpu_image
cd ..

echo "Docker images have been built and pushed successfully."
