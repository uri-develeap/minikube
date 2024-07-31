#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Update and install Docker and Git
sudo apt update
sudo apt install -y docker.io git curl

# Allow non-root user to manage Docker
sudo chmod 666 /var/run/docker.sock

# Download and install Minikube
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube_latest_amd64.deb
sudo dpkg -i minikube_latest_amd64.deb

# Start Minikube
minikube start

# Clone the required repositories
git clone https://github.com/rwf2/Rocket.git
git clone https://github.com/uri-develeap/minikube.git

# Replace Cargo.toml files with custom versions
cp minikube/rootCargo.toml Rocket/Cargo.toml
cp minikube/exampleCargo.toml Rocket/examples/Cargo.toml

# Build Docker image
docker build --build-arg pkg=hello -t hello-world-rust -f Rocket/examples/hello/Dockerfile .

# Load Docker image into Minikube
minikube image load hello-world-rust:latest

# Apply Kubernetes configurations
minikube kubectl -- apply -f minikube/deployment.yaml
minikube kubectl -- apply -f minikube/service.yaml
minikube kubectl -- apply -f minikube/hpa.yaml

# Display the application access URL
app_url=$(minikube service hello-world-service --url)
echo "Test application is accessible via this link: wget -qO- ${app_url}/hello/world"

echo "Setup complete. Application has been deployed to Minikube."
