# 📌 ArgoCD Deployment for `main-api` and `auxiliary-service`

This document provides an overview of how **ArgoCD** is used to deploy and manage the **`main-api`** and **`auxiliary-service`** applications in the Kubernetes cluster.

---

## 🚀 **Overview**
- 🛠 **ArgoCD automates deployments** by continuously syncing the application manifests from a Git repository.
- 📦 **`main-api` and `auxiliary-service` are defined as separate ArgoCD applications.**
- 🔄 **Any changes pushed to the GitHub repository are automatically applied to the Kubernetes cluster.**
- 📌 **The sync policy ensures self-healing and automatic pruning.**

---

## 📂 **Kubernetes Resources Overview**

### **1️⃣ ArgoCD Application for `main-api`**
```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: main-api
  namespace: argocd
spec:
  project: default
  source:
    repoURL: "git@github.com:le1t0ftw/kantox-challenge-ldv.git"
    targetRevision: main
    path: kubernetes/services/main-api
  destination:
    server: https://kubernetes.default.svc
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
    syncOptions:
    - CreateNamespace=true
```
✅ **Deploys `main-api` from the Git repository.**  
✅ **Automatically creates the namespace if it doesn’t exist.**  
✅ **Self-healing ensures that any unintended changes are reverted.**  

---

### **2️⃣ ArgoCD Application for `auxiliary-service`**
```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: auxiliary-service
  namespace: argocd
spec:
  project: default
  source:
    repoURL: "git@github.com:le1t0ftw/kantox-challenge-ldv.git"
    targetRevision: main
    path: kubernetes/services/auxiliary-service
  destination:
    server: https://kubernetes.default.svc
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
    syncOptions:
    - CreateNamespace=true
```
✅ **Deploys `auxiliary-service` from the Git repository.**  
✅ **Ensures `auxiliary-service` is always in sync with the repository.**  

---
