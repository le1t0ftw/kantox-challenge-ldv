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