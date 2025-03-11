## 🔍 API Testing Guide

This guide explains how to **test the API** using `cURL`.

The main-api must be exposed on port 8085 before testing.

Expose the main-api:
Run the following command to expose the main-api service:
```sh
kubectl port-forward svc/main-api -n main-api 8085:80
```
This forwards port 8085 on your local machine to the main-api running in Kubernetes.

### **1️⃣ Get Available S3 Buckets**
```sh
curl http://localhost:8085/buckets
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
curl http://localhost:8085/parameters
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
curl http://localhost:8085/parameter/prueba-ldv
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
curl http://localhost:8085/parameter/nonexistent-param
```
#### **❌ Expected Response**
```json
{
  "error": "Parameter not found"
}
```

---

# 📌 Grafana Monitoring Documentation

This document provides a guide on how to **use Grafana** to monitor our services (`main-api` and `auxiliary-service`) within the Kubernetes cluster.

---

## 🚀 **Overview**
Grafana is already deployed and running inside the **Kubernetes cluster** in the **`monitoring` namespace**.  
It is configured to **retrieve metrics from Prometheus**, which scrapes data from both services.

**Key Features:**
- 📊 **Real-time monitoring of service performance**
- 📈 **Pre-built dashboards for quick setup**
- 🔍 **Customizable alerts and visualizations**

---

## 🎯 **Accessing Grafana**
Since Grafana is already running in the **`monitoring` namespace**, you can access it using **port-forwarding**:

```sh
kubectl port-forward svc/grafana -n monitoring 3000:3000
```
Now, you can open Grafana in your browser at:
```
http://localhost:3000
```
### **🔑 Default Credentials**
| Username | Password |
|----------|----------|
| `admin`  | `admin` (or check your deployment secrets) |

If credentials were changed, retrieve them using:
```sh
kubectl get secret -n monitoring grafana -o jsonpath="{.data.admin-password}" | base64 --decode
```

---

## 📌 **Importing Dashboards**
To quickly set up monitoring, we can **import pre-built dashboards** using their IDs.

### **1️⃣ Import a Dashboard**
1. **Login to Grafana**
2. Navigate to **"Dashboards" → "Import"**
3. Enter the following Dashboard ID and click **Load**
4. Select the **Prometheus** data source
5. Click **Import**

---

## 📊 **Pre-Built Dashboards**
### **1️⃣ Service Metrics and Status**
**Dashboard ID:** `18538`  
**Purpose:** Monitors:
- ✅ **CPU & Memory Usage**
- ✅ **Request Rate & Latency**
- ✅ **Service Uptime**
- ✅ **Error Rates & Response Codes**

🔹 **Import using the steps above to instantly get insights into your services.**

---