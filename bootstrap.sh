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
cp minikube/Cargos/rootCargo.toml Rocket/Cargo.toml
cp minikube/Cargos/exampleCargo.toml Rocket/examples/Cargo.toml
cp minikube/*.yaml Rocket/examples/hello
cp minikube/Dockerfile Rocket/examples/hello/Dockerfile
cp minikube/dockerignore Rocket/.dockerignore
cp minikube/Rocket.toml Rocket/examples/hello/Rocket.toml

cd Rocket
# Build Docker image
docker build --build-arg pkg=hello -t hello-world-rust -f examples/hello/Dockerfile .

# Load Docker image into Minikube
minikube image load hello-world-rust:latest

# Apply Kubernetes configurations
cd examples/hello
minikube kubectl -- apply -f deployment.yaml

sleep 5

minikube kubectl -- apply -f service.yaml

# Wait for the pods to be ready

sleep 5

minikube kubectl -- apply -f hpa.yaml

sleep 5

# Display the application access URL
app_url=$(minikube service hello-world-service --url)
echo "Test application is accessible via this link: wget -qO- ${app_url}/hello/world"

echo "Setup complete. Application has been deployed to Minikube."
