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

