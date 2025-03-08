from fastapi import FastAPI
import requests
import os

app = FastAPI()

AUX_SERVICE_URL = os.getenv("AUX_SERVICE_URL", "http://auxiliary-service:8000")
SERVICE_VERSION = os.getenv("SERVICE_VERSION", "1.0.0")


@app.get("/buckets")
def list_buckets():
    """Consulta el Auxiliary Service para obtener la lista de buckets."""
    response = requests.get(f"{AUX_SERVICE_URL}/buckets")
    return response.json() | {"main_api_version": SERVICE_VERSION}


@app.get("/parameters")
def list_parameters():
    """Consulta el Auxiliary Service para obtener la lista de parámetros."""
    response = requests.get(f"{AUX_SERVICE_URL}/parameters")
    return response.json() | {"main_api_version": SERVICE_VERSION}


@app.get("/parameter/{name}")
def get_parameter(name: str):
    """Consulta el Auxiliary Service para obtener un parámetro específico."""
    response = requests.get(f"{AUX_SERVICE_URL}/parameter/{name}")
    return response.json() | {"main_api_version": SERVICE_VERSION}
