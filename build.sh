#!/bin/bash

set -e
set -x

# Define the base name for your images using GitHub Container Registry
base_image_name=ghcr.io/ecohealthalliance/slurm_reservoir

# Build and tag the base image
base_image=$base_image_name:base
echo "Building and tagging the base image..."
cd base
time docker build -f Dockerfile -t $base_image .
cd ..

# Build and tag the GPU image for the controller
controller_gpu_image=$base_image_name:controller-gpu
echo "Building and tagging the controller GPU image..."
cd Controller
time docker build -f Dockerfile.gpu -t $controller_gpu_image .
cd ..

# Build and tag the GPU image for the worker
worker_gpu_image=$base_image_name:worker-gpu
echo "Building and tagging the worker GPU image..."
cd Worker
time docker build -f Dockerfile.gpu -t $worker_gpu_image .
cd ..

echo "Docker images have been built and tagged successfully."
