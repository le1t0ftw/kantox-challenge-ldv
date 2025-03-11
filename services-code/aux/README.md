# 📌 `auxiliary-service` Documentation

This document provides an overview of the **FastAPI-based `auxiliary-service`**, including its **endpoints**, **AWS integrations**, and **monitoring setup**.

---

## 🚀 **Overview**
`auxiliary-service` is a **FastAPI microservice** that:
- **Interacts with AWS S3** to list available buckets.
- **Retrieves AWS Parameter Store values**.
- **Provides API endpoints** to expose this data.
- **Includes Prometheus instrumentation** for monitoring.
- **Uses environment variables** for configuration.

---

## 📂 **Project Structure**
```
/auxiliary-service/
│── app.py  # FastAPI service definition
│── Dockerfile  # Docker configuration
│── requirements.txt  # Python dependencies
```

---

## ⚙ **Environment Variables**
| Variable Name      | Default Value | Description |
|--------------------|--------------|-------------|
| `AWS_REGION`      | `us-east-1`   | AWS region for S3 and Parameter Store interactions. |
| `SERVICE_VERSION` | `1.0.0`       | Version identifier for `auxiliary-service`. |

---

## 📡 **Prometheus Monitoring**
The service integrates **Prometheus metrics** via `prometheus_fastapi_instrumentator`.

- **Metrics Endpoint:**  
  ```
  /metrics
  ```
- **Usage:**  
  Prometheus can scrape this endpoint to collect **latency, request count, and error rate** metrics.

---

## 🛠 **Installation & Setup**

### **1️⃣ Install Dependencies**
```sh
pip install fastapi boto3 prometheus-fastapi-instrumentator
```

### **2️⃣ Set AWS Credentials (Required)**
Ensure AWS credentials are configured before running the service:
```sh
export AWS_ACCESS_KEY_ID="your-access-key"
export AWS_SECRET_ACCESS_KEY="your-secret-key"
export AWS_REGION="us-east-1"
```

### **3️⃣ Run the API Locally**
```sh
uvicorn app:app --host 0.0.0.0 --port 8000
```

### **4️⃣ Test API Locally**
```sh
curl http://localhost:8000/buckets
```

---

## 📌 **API Endpoints**

### **1️⃣ Get List of S3 Buckets**
```http
GET /buckets
```
🔹 **Description:** Retrieves a list of available S3 buckets in the AWS account.  
🔹 **Response Example:**
```json
{
  "buckets": ["my-s3-bucket"],
  "version": "1.0.0"
}
```

---

### **2️⃣ Get List of AWS Parameters**
```http
GET /parameters
```
🔹 **Description:** Retrieves a list of stored parameters from AWS Parameter Store.  
🔹 **Response Example:**
```json
{
  "parameters": ["database_url", "api_key"],
  "version": "1.0.0"
}
```

---

### **3️⃣ Get a Specific Parameter**
```http
GET /parameters/{name}
```
🔹 **Description:** Retrieves the value of a specific AWS Parameter Store key.  
🔹 **Request Example:**  
```sh
curl http://localhost:8000/parameters/database_url
```
🔹 **Response Example:**
```json
{
  "name": "database_url",
  "value": "postgres://user:pass@db.example.com",
  "version": "1.0.0"
}
```

---

## 🔥 **How It Works**
1. **The API receives a request** (e.g., `/buckets`).
2. **It uses `boto3`** to query AWS services (`s3.list_buckets()`, `ssm.describe_parameters()`).
3. **It returns a structured JSON response** with the requested data.