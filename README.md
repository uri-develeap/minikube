# Rocket HelloWorld Minikube Setup

## Purpose

This repository automates the setup and deployment of the Rocket framework example (`hello`) into a Minikube cluster. It installs the necessary tools, builds a Docker image, and deploys it to Minikube.

## Prerequisites

- Debian/Ubuntu Linux
- Administrator rights

## Setup Instructions

1. **Enable sudo for your user on Debian:**

    Follow the instructions [here](https://milq.github.io/enable-sudo-user-account-debian/) to enable sudo for your user account on Debian.

2. **Run the bootstrap script:**
 
    First, download the `bootstrap.sh` script and run it:

    ```bash
    wget https://raw.githubusercontent.com/uri-develeap/minikube/main/bootstrap.sh
    chmod +x bootstrap.sh
    ./bootstrap.sh
    ```

    This script performs the following tasks:
    - Installs Docker and Git.
    - Configures Docker to be managed by non-root users.
    - Installs Minikube.
    - Starts Minikube.
    - Clones the Rocket repository.
    - Replaces the `Cargo.toml` files in the Rocket repository with custom versions.
    - Builds the Docker image for the Rocket `hello` example.
    - Loads the Docker image into Minikube.
    - Applies the Kubernetes deployment and service configurations.

3. **Navigate to the `minikube` directory:**

    ```bash
    cd minikube
    ```

## Repository Contents

- `bootstrap.sh`: The main script to set up and deploy the Rocket example to Minikube.
- `deployment.yaml`: Kubernetes deployment configuration.
- `service.yaml`: Kubernetes service configuration.
- `hpa.yaml`: Kubernetes Horizontal Pod Autoscaler configuration.
- `rootCargo.toml`: Custom `Cargo.toml` for the root of the Rocket repository.
- `exampleCargo.toml`: Custom `Cargo.toml` for the `examples` directory of the Rocket repository.

## Usage

1. **Check the status of your Minikube pods and services:**

    ```bash
    kubectl get pods
    kubectl get services
    ```

2. **Access the application:**

    Find the URL to access the service:

    ```bash
    minikube service hello-world-service --url
    ```

    Open the URL in your browser or use `curl` to interact with the service.

## Notes

- Ensure you have sufficient permissions to run Docker commands.
- This setup assumes a clean Debian/Ubuntu minimal installation.

## Troubleshooting

- If Minikube fails to start, check your virtualization settings and ensure you have VT-x/AMD-v enabled in your BIOS.
- For any issues with Docker permissions, ensure you have run `sudo chmod 666 /var/run/docker.sock`.
- If the application does not deploy correctly, check the logs of the pods and deployments using `kubectl logs` and `kubectl describe`.

---

Feel free to customize the configurations and scripts according to your needs.

---
## ToDO:
- Migration to HelmChart
- Values parametrization
- SonarQube scanning
