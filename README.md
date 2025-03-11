# Kantox Challenge - DevOps

## 📌 Introduction

This project is part of a **technical challenge** for a **Cloud Engineer / DevOps** position.  
The application is designed to run in a **local Kubernetes environment** using **Minikube**.

---
# 📂 Repository Structure

This repository follows a structured format to separate concerns and ensure maintainability. Below is a breakdown of each directory and its contents.

---

## **1️⃣ Root Directory (`/`)**
This is the main directory containing the core files and subdirectories. Key files include:

- **`README.md`** → Main documentation file.
- **`.gitignore`** → Defines files to be ignored by Git.
- **`.github/workflows/`** → Contains GitHub Actions workflow files for CI/CD.

---

## **2️⃣ `terraform/` - Infrastructure as Code**
This directory contains Terraform files used to provision cloud infrastructure in **AWS**.

📂 **Contents:**
- **`main.tf`** → Defines the infrastructure modules (S3, IAM, Parameter Store).
- **`variables.tf`** → Stores Terraform variables (e.g., bucket name, IAM role).
- **`outputs.tf`** → Defines Terraform outputs (e.g., created S3 bucket ARN).
- **`provider.tf`** → Configures the AWS provider.
- **`modules/`** → Contains reusable Terraform modules.

---

## **3️⃣ `kubernetes/` - Kubernetes Manifests**
This directory contains Kubernetes configuration files used for deploying the application.

📂 **Contents:**
- **`argo-deploy.yaml`** → Defines Argo CD application deployments.
- **`services/`** → Contains separate Kubernetes resources for each service:
  - **`main-api/`** → Deployments, services, and configurations for the main API.
  - **`auxiliary-service/`** → Deployments, services, and configurations for the auxiliary service.

---

## **4️⃣ `services-code/` - Application Source Code**
This directory contains the source code for both microservices.

📂 **Contents:**
- **`api/`** → Main API service:
  - `Dockerfile` → Defines how to build the API container.
  - `app.py` → Main application logic.
  - `requirements.txt` → Dependencies required for the API.
- **`aux/`** → Auxiliary service with similar structure.

---

## **5️⃣ `.github/workflows/` - CI/CD Pipelines**
This directory contains GitHub Actions workflows that automate:
- **Code validation**
- **Docker image building**
- **Push to AWS ECR**
- **Updating Kubernetes manifests**

📂 **Contents:**
- **`main.yml`** → Defines the CI/CD pipeline.


---

## 🚀 Prerequisites

To run this project in a local environment, you need an **AWS account**,  
which will be used for **deploying the infrastructure with Terraform** and  
for **storing the Docker images** created by the pipeline.

Additionally, install the following tools:

- [Minikube](https://minikube.sigs.k8s.io/docs/)
- [Argo CD](https://argo-cd.readthedocs.io/)
- [Kubectl](https://kubernetes.io/docs/tasks/tools/)
- [Helm](https://helm.sh/)
- [Docker](https://docs.docker.com/get-docker/)
- [Terraform](https://developer.hashicorp.com/terraform/downloads)

---

# **🏗 Local Environment Setup**
The process to set up the local environment consists of the following steps:

1️⃣ **[Installing and Configuring Minikube](#1-installing-and-configuring-minikube)**  
2️⃣ **[Deploying Infrastructure with Terraform](terraform/README.md)**  
3️⃣ **[Deploying Services with CI/CD and Argo CD](kubernetes/README.md)**  
4️⃣ **[Testing and Monitoring the Services](#4-testing-and-monitoring)**  

---

## **1️⃣ Installing and Configuring Minikube**
To run the local environment, **Minikube** and additional components need to be installed and configured.  

🔗 **[See the full guide](documents/minikube.md)**  

### **Summary of Steps:**
```sh
minikube start --memory=4g --cpus=2
minikube addons enable registry-creds
minikube addons configure registry-creds
```
✅ **This configures authentication with AWS ECR for managing Docker images.**  

---

## **2️⃣ Deploying Infrastructure with Terraform**
The **AWS infrastructure** is deployed using **Terraform**, which provisions:
- **S3 Bucket**
- **IAM Roles**
- **AWS Systems Manager Parameter Store**

🔗 **[Detailed guide in `terraform/README.md`](terraform/README.md)**  

### **Example: Terraform Initialization**
```sh
cd terraform
terraform init
terraform apply -auto-approve
```

---

## **3️⃣ Deploying Services with CI/CD and Argo CD**
Once the infrastructure is deployed, services are managed and deployed using:  
- **GitHub Actions (CI/CD)**
- **Argo CD (Kubernetes GitOps)**

🔗 **[Full guide in `kubernetes/README.md`](kubernetes/README.md)**  

### **Summary of Steps:**
#### **Deploy Argo CD**
```sh
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```
#### **Connect the Repository to Argo CD**
```sh
argocd repo add git@github.com:your-username/your-repository.git \
  --ssh-private-key-path ~/.ssh/argocd
```
✅ **This allows Argo CD to automatically sync deployments from the repository.**

---

## **4️⃣ Testing and Monitoring**
Once the services are deployed, API tests can be performed using **cURL**,  
and the infrastructure can be monitored with **Grafana and Prometheus**.

🔗 **[Testing and monitoring guide in `kubernetes/README.md`](kubernetes/README.md)**  

### **Example: API Test**
```sh
curl http://localhost:8000/buckets
```
✅ **This verifies that the API responds correctly with AWS resources.**