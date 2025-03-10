# Kantox Challenge - DevOps

## 📌 Introduction

This project is part of a **technical challenge** for a **Cloud Engineer / DevOps** position.  
The application is designed to run in a **local Kubernetes environment** using **Minikube**.

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

## 🔧 Installation & Configuration

### **1️⃣ Start Minikube**
```sh
minikube start --memory=4g --cpus=2
```

### **2️⃣ Install & Configure AWS ECR Plugin**
Minikube **does not support ServiceAccounts with AWS**, so we need to enable  
the **`registry-creds` plugin** for authentication with **Amazon ECR**.

#### Enable the plugin:
```sh
minikube addons enable registry-creds
```

#### Configure the plugin:
```sh
minikube addons configure registry-creds
```

During the setup, select **AWS** and enter:

- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`
- `AWS_ACCOUNT_ID`

#### Verify Configuration:
```sh
kubectl get secrets -n kube-system | grep registry-creds
```
If a secret with the prefix `registry-creds` appears, the setup was successful.

---

## 🌍 Terraform Infrastructure Deployment

Before deploying applications in Kubernetes, deploy the **AWS infrastructure**  
using **Terraform**. The **Terraform state file** will be **stored locally** for this challenge.

### **📌 Infrastructure Overview**
| AWS Service | Purpose |
|-------------|---------|
| **S3 Bucket** | Stores static files and logs. |
| **IAM Role & Policies** | Grants permissions to services. |
| **Parameter Store** | Securely stores app configuration values. |

### **1️⃣ Initialize Terraform**
```sh
cd terraform
terraform init
```

### **2️⃣ Plan Deployment**
```sh
terraform plan
```
Shows the **AWS resources** that will be created.

### **3️⃣ Apply Deployment**
```sh
terraform apply -auto-approve
```
This will deploy the **S3 bucket, IAM roles, and Parameter Store settings**.

---

## ⚙️ CI/CD Pipeline - GitHub Actions

### **📌 Configuration**
Before running the pipeline, create a **fork** of this repository and set  
the following **GitHub Actions secrets**:

| Secret Name | Purpose |
|-------------|---------|
| `AWS_ACCESS_KEY_ID` | AWS Access Key |
| `AWS_SECRET_ACCESS_KEY` | AWS Secret Key |
| `AWS_ACCOUNT_ID` | AWS Account ID |

**Path:** `Settings > Secrets and variables > Actions`

---

### **📌 Pipeline Structure**
```sh
/
|-- main-api/               # Microservice: main API
|-- auxiliary-service/      # Microservice: auxiliary service
|-- k8s/                    # Kubernetes manifests
|-- terraform/              # Infrastructure as code
|-- .github/workflows/      # GitHub Actions workflows
|-- README.md               # Documentation
```

### **📌 CI/CD Steps**
1️⃣ **Validate Code**  
2️⃣ **Lint Dockerfiles**  
3️⃣ **Build & Push Docker Images to AWS ECR**  
4️⃣ **Update Kubernetes Deployment Files**  
5️⃣ **Deploy Updates using Argo CD**  

---

## 🚢 Deployment with Argo CD

Argo CD manages Kubernetes deployments automatically.

### **1️⃣ Install Argo CD**
```sh
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

### **2️⃣ Add GitHub Repository to Argo CD**
1. Generate an **SSH key**.
2. Add the **public key** to GitHub.
3. Configure **Argo CD** to use this key.
4. Verify the repository connection.

### **3️⃣ Deploy Applications**
```sh
kubectl apply -f kubernetes/argo-deploy.yaml
```

### **📌 Components Deployed**
- ✅ `main-api`
- ✅ `auxiliary-service`
- ✅ `Grafana & Prometheus` (for monitoring)

---

## 🔍 API Testing Guide

This guide explains how to **test the API** using `cURL`.

### **1️⃣ Get Available S3 Buckets**
```sh
curl http://localhost:8000/buckets
```
#### **✅ Expected Response**
```json
{
  "buckets": ["dv12354905834098"],
  "version": "1.0.0",
  "main_api_version": "1.0.0"
}
```

---

### **2️⃣ Get AWS Parameter Store Entries**
```sh
curl http://localhost:8000/parameters
```
#### **✅ Expected Response**
```json
{
  "parameters": ["prueba-ldv"],
  "version": "1.0.0",
  "main_api_version": "1.0.0"
}
```

---

### **3️⃣ Get a Specific Parameter's Value**
```sh
curl http://localhost:8000/parameter/prueba-ldv
```
#### **✅ Expected Response**
```json
{
  "name": "prueba-ldv",
  "value": "test",
  "version": "1.0.0",
  "main_api_version": "1.0.0"
}
```

---

### **4️⃣ Handling Errors**
If an incorrect **bucket or parameter name** is used, expect:
```json
{
  "error": "Parameter not found"
}
```

#### **❌ Example Failed Request**
```sh
curl http://localhost:8000/parameter/nonexistent-param
```
#### **❌ Expected Response**
```json
{
  "error": "Parameter not found"
}
```

---