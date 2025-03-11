# 📌 CI/CD Pipeline - Step-by-Step Guide

This document provides a detailed step-by-step explanation of the **CI/CD pipeline** defined in the **GitHub Actions workflow**.

---

## **🚀 Overview**
The pipeline automates the **validation, building, pushing, and deployment** of services to **AWS ECR** and **Kubernetes** using **Argo CD**.

### **Pipeline Stages:**
1️⃣ **Validate Code (Linting & Testing)**  
2️⃣ **Lint Dockerfiles**  
3️⃣ **Build & Push Docker Images to AWS ECR**  
4️⃣ **Update Kubernetes Manifests & ConfigMap**  
5️⃣ **Commit & Push Updated Deployment Files**  
6️⃣ **Argo CD Automatically Redeploys Updated Services**  

---

## **1️⃣ Validate Code**
The pipeline starts by **checking out the repository** and running **linting and static code analysis**.

### **Steps:**
1. **Checkout the repository**
   ```sh
   uses: actions/checkout@v4
   ```
2. **Setup Python**
   ```sh
   uses: actions/setup-python@v4
   with:
     python-version: '3.13.2'
   ```
3. **Install dependencies**
   ```sh
   pip install flake8 pytest
   ```
4. **Run `flake8` for linting**
   ```sh
   flake8 services-code
   ```
✅ **Ensures the Python code follows best practices.**

---

## **2️⃣ Lint Dockerfiles**
The pipeline validates the **Dockerfiles** using **Hadolint**.

### **Steps:**
1. **Checkout the repository**
   ```sh
   uses: actions/checkout@v4
   ```
2. **Run Hadolint for `main-api`**
   ```sh
   docker run --rm -i hadolint/hadolint < ./services-code/api/Dockerfile
   ```
3. **Run Hadolint for `auxiliary-service`**
   ```sh
   docker run --rm -i hadolint/hadolint < ./services-code/aux/Dockerfile
   ```
✅ **Ensures Dockerfiles follow best practices.**

---

## **3️⃣ Build & Push Docker Images**
The pipeline builds **Docker images** and **pushes them to AWS ECR**.

### **Steps:**
1. **Checkout the repository**
   ```sh
   uses: actions/checkout@v4
   ```
2. **Detect changes in `main-api` or `auxiliary-service`**
   ```yaml
   id: changes
   uses: dorny/paths-filter@v2
   with:
     filters: |
       api:
         - 'services-code/api/**'
       aux:
         - 'services-code/aux/**'
   ```
3. **Authenticate with AWS**
   ```yaml
   uses: aws-actions/configure-aws-credentials@v2
   with:
     aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
     aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
     aws-region: us-east-1
   ```
4. **Log in to AWS ECR**
   ```sh
   aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin ${{ secrets.AWS_ACCOUNT_ID }}.dkr.ecr.us-east-1.amazonaws.com
   ```
5. **Ensure ECR repository exists**
   ```sh
   aws ecr describe-repositories --repository-names main-api --region us-east-1 || \
   (aws ecr create-repository --repository-name main-api --region us-east-1 && echo "REPO_CREATED=true" >> $GITHUB_ENV)
   ```
6. **Build and push the `main-api` image**
   ```sh
   SHORT_SHA=${GITHUB_SHA::7}
   docker build -t main-api:$SHORT_SHA ./services-code/api
   docker tag main-api:$SHORT_SHA ${{ secrets.AWS_ACCOUNT_ID }}.dkr.ecr.us-east-1.amazonaws.com/main-api:$SHORT_SHA
   docker push ${{ secrets.AWS_ACCOUNT_ID }}.dkr.ecr.us-east-1.amazonaws.com/main-api:$SHORT_SHA
   ```
7. **Repeat for `auxiliary-service`**
   ```sh
   SHORT_SHA=${GITHUB_SHA::7}
   docker build -t auxiliary-service:$SHORT_SHA ./services-code/aux
   docker tag auxiliary-service:$SHORT_SHA ${{ secrets.AWS_ACCOUNT_ID }}.dkr.ecr.us-east-1.amazonaws.com/auxiliary-service:$SHORT_SHA
   docker push ${{ secrets.AWS_ACCOUNT_ID }}.dkr.ecr.us-east-1.amazonaws.com/auxiliary-service:$SHORT_SHA
   ```
✅ **Ensures the latest service versions are built and deployed.**

---

## **4️⃣ Update Kubernetes Manifests & ConfigMap**
Once the images are pushed, the pipeline updates **Kubernetes manifests**.

### **Steps:**
1. **Update `main-api` deployment**
   ```sh
   SHORT_SHA=${GITHUB_SHA::7}
   sed -i "s|image:.*|image: ${{ secrets.AWS_ACCOUNT_ID }}.dkr.ecr.us-east-1.amazonaws.com/main-api:$SHORT_SHA|g" ./kubernetes/services/main-api/main-api-deployment.yaml
   ```
2. **Update `auxiliary-service` deployment**
   ```sh
   SHORT_SHA=${GITHUB_SHA::7}
   sed -i "s|image:.*|image: ${{ secrets.AWS_ACCOUNT_ID }}.dkr.ecr.us-east-1.amazonaws.com/auxiliary-service:$SHORT_SHA|g" ./kubernetes/services/auxiliary-service/auxiliary-service-deployment.yaml
   ```
3. **Increment `SERVICE_VERSION` in `configmap.yaml`**
   ```sh
   CONFIGMAP_FILE="./kubernetes/services/main-api/configmap.yaml"
   CURRENT_VERSION=$(grep 'SERVICE_VERSION:' $CONFIGMAP_FILE | awk -F'"' '{print $2}')
   NEW_VERSION=$(echo $CURRENT_VERSION | awk -F. -v OFS=. '{$NF++;print}')
   sed -i "s|SERVICE_VERSION: \"$CURRENT_VERSION\"|SERVICE_VERSION: \"$NEW_VERSION\"|g" $CONFIGMAP_FILE
   echo "Incremented SERVICE_VERSION to $NEW_VERSION"
   ```
✅ **Ensures Kubernetes deployments always use the latest images.**

---

## **5️⃣ Commit & Push Updated Deployment Files**
The final step is committing and pushing the updated Kubernetes manifests.

### **Steps:**
1. **Setup Git**
   ```sh
   git config --global user.name "GitHub Actions"
   git config --global user.email "actions@github.com"
   ```
2. **Add changes to Git**
   ```sh
   git add -A
   ```
3. **Commit changes**
   ```sh
   git commit -m "DEPLOY-[service:$SHORT_SHA] - new deployment generated"
   ```
4. **Pull latest changes & rebase**
   ```sh
   git pull origin main --rebase
   ```
5. **Push changes to GitHub**
   ```sh
   git push https://x-access-token:${{ secrets.PAT_TOKEN }}@github.com/your-username/repo.git -q
   ```
✅ **Ensures Kubernetes manifests are updated in the repository.**

---

## **6️⃣ Argo CD Automatically Redeploys Updated Services**
Once the pipeline successfully completes, **Argo CD automatically detects changes** in the Git repository and **redeploys the necessary applications**.

### **How It Works:**
- Argo CD **monitors the Git repository** for changes in Kubernetes manifests.
- When a **new deployment file is committed**, Argo CD **syncs the updates** to the Kubernetes cluster.
- **No manual intervention is required**—Argo CD ensures that the cluster state matches the latest changes in the repository.

### **Verify Argo CD Sync**
```sh
argocd app list
argocd app sync main-api
argocd app sync auxiliary-service
```
✅ **Ensures that the new images and configurations are automatically deployed.**

---