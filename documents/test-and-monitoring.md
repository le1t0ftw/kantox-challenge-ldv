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