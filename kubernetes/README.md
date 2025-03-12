## ⚙️ CI/CD Pipeline - GitHub Actions

### **📌 Configuration**
Before running the pipeline, you must set  
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

🔗 **[See detailed step by step pipeline guide: ](../documents/cicd-step-by-step.md)** 

## 🚢 Deployment with Argo CD

Argo CD manages Kubernetes deployments automatically.

### **1️⃣ Install Argo CD**

Argo CD is used for **declarative GitOps-based deployments** in Kubernetes.  
To install it, follow these steps:

#### **Step 1: Create a Namespace for Argo CD**
```sh
kubectl create namespace argocd
```
- This creates a dedicated **namespace** where Argo CD will run.

#### **Step 2: Deploy Argo CD Components**
```sh
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```
- This command **downloads and applies** the official Argo CD manifest.
- It deploys the **Argo CD API server, UI, repository manager, and controllers**.

#### **Step 3: Verify Installation**
```sh
kubectl get pods -n argocd
```
Expected Output:
```sh
NAME                                     READY   STATUS    RESTARTS   AGE
argocd-application-controller-0          1/1     Running   0          2m
argocd-dex-server-8476d69f57-abcde       1/1     Running   0          2m
argocd-redis-777d4c9c56-xyz12            1/1     Running   0          2m
argocd-repo-server-65497b5d99-ghijk       1/1     Running   0          2m
argocd-server-746f49978b-lmnop            1/1     Running   0          2m
```
- All Argo CD components should be in **"Running"** status.

#### **Step 4: Expose Argo CD Server (Optional)**
To access the **Argo CD UI**, expose it as a service:
```sh
kubectl port-forward svc/argocd-server -n argocd 8080:443
```
Now, access the UI at: **[https://localhost:8080](https://localhost:8080)**  
The default **username** is `admin`, and the password can be retrieved with:

```sh
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```

---

### **2️⃣ Add GitHub Repository to Argo CD**

To deploy applications from a **GitHub repository**, Argo CD needs **access** via SSH.

#### **Step 1: Generate an SSH Key**
```sh
ssh-keygen -t rsa -b 4096 -C "argo-cd" -f ~/.ssh/argocd
```
- This creates a **private key (`argocd`)** and a **public key (`argocd.pub`)**.

#### **Step 2: Add the Public Key to GitHub**
1. Go to **GitHub** → **Settings** → **Deploy Keys**  
2. Click **"Add new deploy key"**
3. Copy the contents of your **public key**:
   ```sh
   cat ~/.ssh/argocd.pub
   ```
4. Paste it into GitHub, enable **"Allow write access"**, and save.

#### **Step 3: Add the GitHub Repository to Argo CD**
```sh
argocd login localhost:8080 --username admin --password $(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)

argocd repo add git@github.com:le1t0ftw/kantox-challenge-ldv.git \
  --ssh-private-key-path ~/.ssh/argocd
```
- This tells Argo CD to **authenticate with GitHub** using the SSH key.

#### **Step 4: Verify Repository Connection**
```sh
argocd repo list
```
Expected Output:
```
TYPE  NAME                                      REPO                                                   STATUS      MESSAGE
git   your-repository-name                      git@github.com:your-username/your-repository.git       Successful  
```
- If `STATUS` is `Successful`, the repository is connected properly.



### **3️⃣ Deploy Applications**
```sh
kubectl apply -f kubernetes/argo-deploy.yaml
```

### **📌 Components Deployed**
- ✅ `main-api`
- ✅ `auxiliary-service`
- ✅ `Grafana & Prometheus` (for monitoring)
