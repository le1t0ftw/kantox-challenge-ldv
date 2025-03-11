## 🔍 API Testing Guide

This guide explains how to **test the API** using `cURL`.

The main-api must be exposed on port 8001 before testing.

Expose the main-api:
Run the following command to expose the main-api service:
```sh
kubectl port-forward svc/main-api -n main-api 8001:80
```
This forwards port 8001 on your local machine to the main-api running in Kubernetes.

### **1️⃣ Get Available S3 Buckets**
```sh
curl http://localhost:8001/buckets
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
curl http://localhost:8001/parameters
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
curl http://localhost:8001/parameter/prueba-ldv
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
curl http://localhost:8001/parameter/nonexistent-param
```
#### **❌ Expected Response**
```json
{
  "error": "Parameter not found"
}
```

---