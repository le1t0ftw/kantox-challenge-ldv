# **🏗 Local Environment Setup**
The process to set up the local environment consists of the following steps:

1️⃣ **[Installing and Configuring Minikube](#1-installing-and-configuring-minikube)**  
2️⃣ **[Deploying Infrastructure with Terraform](terraform/README.md)**  
3️⃣ **[Deploying Services with CI/CD and Argo CD](kubernetes/README.md)**  
4️⃣ **[Testing and Monitoring the Services](#4-testing-and-monitoring)**  

---

## **1️⃣ Installing and Configuring Minikube**
To run the local environment, **Minikube** and additional components need to be installed and configured.  

🔗 **[See the full guide](#installing-and-configuring-minikube)**  

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