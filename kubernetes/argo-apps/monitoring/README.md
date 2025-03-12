# 📌 ArgoCD Monitoring Stack Deployment

This document provides an overview of how **ArgoCD** is used to manage the deployment of the **monitoring stack** in a **Kubernetes cluster**.  

The monitoring stack includes:
- **Prometheus** → Metric collection & monitoring.
- **VictoriaMetrics** → High-performance time-series database.
- **Grafana** → Dashboard visualization.
- **Kube-State-Metrics** → Kubernetes resource monitoring.
- **Prometheus Operator CRDs** → Manages custom resource definitions for Prometheus.
- **Blackbox Exporter** → External endpoint probing.

---

## 🚀 **Overview**
Each monitoring component is **deployed as an ArgoCD Application**, allowing **GitOps-style continuous deployment**.

- 📊 **Metrics are collected using Prometheus.**
- 🗄 **VictoriaMetrics acts as a storage backend for Prometheus.**
- 📡 **Grafana visualizes collected metrics using pre-built dashboards.**
- 🔍 **Kube-State-Metrics provides Kubernetes resource metrics.**
- 🌐 **Blackbox Exporter monitors external services via HTTP probing.**

---

## 📂 **Kubernetes Resources Overview**

### **1️⃣ Prometheus Deployment**
```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: prometheus
  namespace: argocd
spec:
  destination:
    namespace: monitoring
    server: https://kubernetes.default.svc
  project: default
  source:
    chart: prometheus
    repoURL: https://prometheus-community.github.io/helm-charts
    targetRevision: 27.5.1
    helm:
      values: |
        extraScrapeConfigs: |
          - job_name: 'prometheus-blackbox-exporter'
            metrics_path: /probe
            params:
              module: [http_2xx]
            static_configs:
              - targets:
                - http://main-api.main-api.svc.cluster.local:9000/metrics
            relabel_configs:
              - source_labels: [__address__]
                target_label: __param_target
              - target_label: __address__
                replacement: blackbox-exporter-prometheus-blackbox-exporter.monitoring.svc.cluster.local:9115
              - source_labels: [__param_target]
                target_label: instance
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
    syncOptions:
    - CreateNamespace=true
```
✅ **Deploys Prometheus via Helm Chart.**  
✅ **Configures additional scrape jobs for Blackbox Exporter and `main-api`.**  
✅ **Sync Policy:** Ensures automatic redeployment if the configuration drifts.

---

### **2️⃣ VictoriaMetrics Deployment**
```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: victoria-metrics
  namespace: argocd
spec:
  destination:
    namespace: monitoring
    server: https://kubernetes.default.svc
  project: default
  source:
    chart: victoria-metrics-single
    repoURL: https://victoriametrics.github.io/helm-charts/
    targetRevision: 0.14.3
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
    syncOptions:
    - CreateNamespace=true
```
✅ **Deploys VictoriaMetrics as the time-series database backend for Prometheus.**  
✅ **Optimized for high-performance data storage.**

---

### **3️⃣ Grafana Deployment**
```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: grafana
  namespace: argocd
spec:
  destination:
    namespace: monitoring
    server: https://kubernetes.default.svc
  project: default
  source:
    chart: grafana
    repoURL: https://grafana.github.io/helm-charts
    targetRevision: 8.10.2
    helm:
      values: |
        datasources:
          datasources.yaml:
            apiVersion: 1
            datasources:
              - name: Prometheus
                type: prometheus
                url: http://victoria-metrics-victoria-metrics-single-server:8428
                access: proxy
                isDefault: true
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
    syncOptions:
    - CreateNamespace=true
```
✅ **Deploys Grafana with Prometheus as the default data source.**  
✅ **Connects to VictoriaMetrics via `http://victoria-metrics-victoria-metrics-single-server:8428`.**  
✅ **Allows importing pre-built dashboards (e.g., `18538` for service metrics).**

---

### **4️⃣ Kube-State-Metrics Deployment**
```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: kube-state-metrics
  namespace: argocd
spec:
  destination:
    namespace: monitoring
    server: https://kubernetes.default.svc
  project: monitoring
  source:
    chart: kube-state-metrics
    repoURL: https://prometheus-community.github.io/helm-charts
    targetRevision: 5.30.1
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
    syncOptions:
    - CreateNamespace=true
```
✅ **Deploys kube-state-metrics to expose Kubernetes resource metrics.**  
✅ **Provides insights into deployments, pods, and other cluster objects.**  

---

### **5️⃣ Prometheus Operator CRDs Deployment**
```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: prometheus-crds
  namespace: argocd
  finalizers:
    - resources-finalizer.argocd.argoproj.io  
spec:
    destination:
      namespace: monitoring
      server: https://kubernetes.default.svc
    project: default  
    source:
      repoURL: https://prometheus-community.github.io/helm-charts
      chart: prometheus-operator-crds
      targetRevision: 18.0.1
    syncPolicy:
      automated:
        prune: true
        selfHeal: true
      syncOptions:
      - CreateNamespace=true
      - Replace=true
    syncOptions:
    - CreateNamespace=true
```
✅ **Installs Prometheus Custom Resource Definitions (CRDs).**  
✅ **Enables advanced monitoring configurations within the cluster.**

---

### **6️⃣ Blackbox Exporter Deployment**
```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: blackbox-exporter
  namespace: argocd
spec:
  destination:
    namespace: monitoring
    server: https://kubernetes.default.svc
  project: default
  source:
    chart: prometheus-blackbox-exporter
    repoURL: https://prometheus-community.github.io/helm-charts
    targetRevision: 9.3.0
    helm:
      values: |
        config:
          modules:
            http_2xx:
              prober: http
              timeout: 5s
              http:
                valid_http_versions: ["HTTP/1.1", "HTTP/2"]
                valid_status_codes: []  # Default: 2xx
                fail_if_ssl: false
                method: GET
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
```
✅ **Deploys Blackbox Exporter to monitor external services.**  
✅ **Configured to check HTTP responses for `main-api` health metrics.**  

---

## 🎯 **ArgoCD Sync Policies**
All applications are **automatically synced** with:
- **`prune: true`** → Removes resources not in Git.
- **`selfHeal: true`** → Restores resources if modified outside ArgoCD.
- **`CreateNamespace=true`** → Ensures required namespaces exist.

To **manually trigger a sync**, use:
```sh
argocd app sync prometheus
argocd app sync grafana
argocd app sync victoria-metrics
```

---

## 📌 **Conclusion**
✅ **Fully automated monitoring stack using ArgoCD.**  
✅ **Prometheus scrapes metrics from services and external probes.**  
✅ **VictoriaMetrics efficiently stores time-series data.**  
✅ **Grafana visualizes metrics with pre-configured dashboards.**  
✅ **Kube-State-Metrics and Blackbox Exporter provide detailed insights.**  

🚀 **Now, your cluster is fully monitored and production-ready!** 🔥
