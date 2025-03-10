from fastapi import FastAPI
import requests
import os
from prometheus_fastapi_instrumentator import Instrumentator

app = FastAPI()
AUX_SERVICE_URL = os.getenv("AUX_SERVICE_URL", "http://auxiliary-service:8000")
SERVICE_VERSION = os.getenv("SERVICE_VERSION", "1.0.0")
Instrumentator().instrument(app).expose(app, endpoint="/metrics")


# Esto es un comentari


@app.get("/buckets")
def list_buckets():
    response = requests.get(f"{AUX_SERVICE_URL}/buckets")
    return response.json() | {"main_api_version": SERVICE_VERSION}


@app.get("/parameters")
def list_parameters():
    response = requests.get(f"{AUX_SERVICE_URL}/parameters")
    return response.json() | {"main_api_version": SERVICE_VERSION}


@app.get("/parameters/{name}")
def get_parameter(name: str):
    response = requests.get(f"{AUX_SERVICE_URL}/parameters/{name}")
    return response.json() | {"main_api_version": SERVICE_VERSION}
