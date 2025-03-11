# 📌 `main-api` Documentation

This document provides an overview of the **FastAPI-based `main-api` service**, including its **endpoints**, **environment variables**, and **monitoring setup**.

---

## 🚀 **Overview**
`main-api` is a **FastAPI service** that:
- **Communicates with** `auxiliary-service` to fetch S3 bucket and AWS Parameter Store data.
- **Provides API endpoints** to expose these resources.
- **Includes Prometheus instrumentation** for monitoring.
- **Uses environment variables** for configuration.

---

## 📂 **Project Structure**
```
/main-api/
│── app.py  # FastAPI service definition
│── Dockerfile  # Docker configuration
│── requirements.txt  # Python dependencies
```

---

## ⚙ **Environment Variables**
| Variable Name      | Default Value | Description |
|--------------------|--------------|-------------|
| `AUX_SERVICE_URL`  | `http://auxiliary-service:8085` | The URL of the auxiliary service. |
| `SERVICE_VERSION`  | `1.0.0` | Version identifier for `main-api`. |

---

## 📡 **Prometheus Monitoring**
The service integrates **Prometheus metrics** via the `prometheus_fastapi_instrumentator` package.

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
pip install fastapi requests prometheus-fastapi-instrumentator
```

### **2️⃣ Run the API Locally**
```sh
uvicorn app:app --host 0.0.0.0 --port 8085
```

### **3️⃣ Test API Locally**
```sh
curl http://localhost:8085/buckets
```

---

## 📌 **API Endpoints**

### **1️⃣ Get List of S3 Buckets**
```http
GET /buckets
```
🔹 **Description:** Retrieves a list of available S3 buckets from `auxiliary-service`.  
🔹 **Response Example:**
```json
{
  "buckets": ["my-s3-bucket"],
  "version": "1.0.0",
  "main_api_version": "1.0.0"
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
  "version": "1.0.0",
  "main_api_version": "1.0.0"
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
curl http://localhost:8085/parameters/database_url
```
🔹 **Response Example:**
```json
{
  "name": "database_url",
  "value": "postgres://user:pass@db.example.com",
  "version": "1.0.0",
  "main_api_version": "1.0.0"
}
```

---

## 🔥 **How It Works**
1. **The API receives a request** (e.g., `/buckets`).
2. **It forwards the request** to `auxiliary-service` using `requests.get()`.
3. **It appends its own version info** (`main_api_version`).
4. **It returns the combined response**.