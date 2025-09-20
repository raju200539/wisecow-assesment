# Wisecow Application Deployment on Kubernetes

This repository contains the solution for the Accuknox DevOps Trainee assessment, focusing on the containerization, deployment, and automation of the "Wisecow" application.

The primary objective is to deploy the application on a local Kubernetes cluster (Minikube), implement a full CI/CD pipeline using GitHub Actions, and secure the deployment with TLS encryption.

-----

## 🚀 Project Overview

The project achieves the following key objectives from Problem Statement 1:

  * **Dockerization**: A `Dockerfile` is provided to create a portable and efficient container image for the application.
  * **Kubernetes Deployment**: Kubernetes manifest files (`deployment.yaml`, `service.yaml`) are crafted to declaratively manage the application's deployment and exposure.
  * **CI/CD Automation**: A GitHub Actions workflow automates the building and pushing of the Docker image to a container registry upon every commit to the `main` branch.
  * **TLS Implementation**: The application is secured using TLS encryption via an NGINX Ingress controller and `cert-manager` for automated certificate management.

-----

## 🛠️ Prerequisites

To run this project locally, you will need the following tools installed:

  * **Docker**: For building and managing container images.
  * **Minikube**: For running a local Kubernetes cluster.
  * **kubectl**: The Kubernetes command-line tool.
  * **Git**: For cloning the repository.

-----

## 📁 Repository Structure

```
.
├── .github/workflows/
│   └── ci.yml             # GitHub Actions workflow for CI/CD
├── deployment.yaml        # Kubernetes Deployment manifest
├── service.yaml           # Kubernetes Service manifest
├── ingress.yaml           # Kubernetes Ingress manifest for TLS
├── cluster-issuer.yaml    # Cert-manager issuer for self-signed certs
├── Dockerfile             # Dockerfile for building the app image
└── wisecow.sh             # The application source code
```

-----

## ⚙️ Local Deployment Guide

Follow these steps to deploy the Wisecow application on your local Minikube cluster.

### 1\. Clone the Repository

```bash
git clone https://github.com/YOUR-USERNAME/wisecow.git
cd wisecow
```

### 2\. Start Minikube

Ensure your Docker daemon is running and start your Minikube cluster.

```bash
minikube start
```

### 3\. Apply Kubernetes Manifests

Apply the deployment and service configurations to your cluster. This will pull the pre-built image from Docker Hub and deploy it.

```bash
# Apply the deployment to create the application pods
kubectl apply -f deployment.yaml

# Apply the service to expose the deployment
kubectl apply -f service.yaml
```

### 4\. Access the Application

To access the running application, use the Minikube service command. This will automatically open the application URL in your default browser.

```bash
minikube service wisecow-service
```

-----

## 🔄 CI/CD Pipeline with GitHub Actions

This project implements a Continuous Integration (CI) pipeline using GitHub Actions.

  * **Workflow File**: The configuration is located at `.github/workflows/ci.yml`.
  * **Trigger**: The workflow is automatically triggered on every `push` to the `main` branch.
  * **Actions**:
    1.  The repository code is checked out.
    2.  The workflow logs into Docker Hub using encrypted secrets (`DOCKERHUB_USERNAME` and `DOCKERHUB_TOKEN`).
    3.  It builds the Docker image from the `Dockerfile`.
    4.  Finally, it pushes the newly built image to the specified Docker Hub repository, tagged with both `latest` and the unique commit SHA.

**Note**: To enable this in your forked repository, you must add your Docker Hub credentials as secrets in `Settings` \> `Secrets and variables` \> `Actions`.

-----

## 🔒 TLS Implementation (Challenge Goal)

The application is secured with TLS using an Ingress controller and `cert-manager`.

### 1\. Enable Ingress and Install Cert-Manager

First, enable the required addons in Minikube and install `cert-manager`.

```bash
# Enable the NGINX Ingress controller
minikube addons enable ingress

# Install cert-manager
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.13.2/cert-manager.yaml
```

### 2\. Apply the Issuer and Ingress

Apply the `ClusterIssuer` to enable certificate generation and the `Ingress` resource to manage external access.

```bash
# Apply the self-signed certificate issuer
kubectl apply -f cluster-issuer.yaml

# Apply the Ingress rule
kubectl apply -f ingress.yaml
```

### 3\. Test the Secure Endpoint

To access the secure application at `https://wisecow.local`, you must first map this hostname to your Minikube cluster's IP address.

1.  **Get the Minikube IP**:
    ```bash
    minikube ip
    ```
2.  **Edit your hosts file** (`/etc/hosts` on macOS/Linux or `C:\Windows\System32\drivers\etc\hosts` on Windows) and add the following line:
    ```
    <MINIKUBE_IP>   wisecow.local
    ```
3.  **Verify the connection** using `curl`. The `-k` flag is required because the certificate is self-signed.
    ```bash
    curl -k https://wisecow.local
    ```
    You should now see the `cowsay` output served over a secure HTTPS connection.
