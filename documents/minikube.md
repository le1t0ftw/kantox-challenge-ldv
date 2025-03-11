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