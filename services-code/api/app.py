from fastapi import FastAPI  # Importing FastAPI framework
import requests  # Importing requests library for making HTTP requests
import os  # Importing os module to access environment variables
from prometheus_fastapi_instrumentator import Instrumentator  # Importing the Prometheus instrumentator for metrics

# Creating an instance of the FastAPI application
app = FastAPI()

# Fetching the auxiliary service URL from environment variables, with a default value
AUX_SERVICE_URL = os.getenv("AUX_SERVICE_URL", "http://auxiliary-service:8000")
# Fetching the service version from environment variables, with a default value
SERVICE_VERSION = os.getenv("SERVICE_VERSION", "1.0.0")

# Setting up metrics instrumentation for the FastAPI app
Instrumentator().instrument(app).expose(app, endpoint="/metrics")


@app.get("/buckets")
def list_buckets():
    """Queries the Auxiliary Service to get the list of buckets."""
    # Making a GET request to the auxiliary service to retrieve the list of buckets
    response = requests.get(f"{AUX_SERVICE_URL}/buckets")
    # Returning the JSON response from the auxiliary service along with the main API version
    return response.json() | {"main_api_version": SERVICE_VERSION}


@app.get("/parameters")
def list_parameters():
    """Queries the Auxiliary Service to get the list of parameters."""
    # Making a GET request to the auxiliary service to retrieve the list of parameters
    response = requests.get(f"{AUX_SERVICE_URL}/parameters")
    # Returning the JSON response from the auxiliary service along with the main API version
    return response.json() | {"main_api_version": SERVICE_VERSION}


@app.get("/parameter/{name}")
def get_parameter(name: str):
    """Queries the Auxiliary Service to get a specific parameter."""
    # Making a GET request to the auxiliary service to retrieve a specific parameter by name
    response = requests.get(f"{AUX_SERVICE_URL}/parameter/{name}")
    # Returning the JSON response from the auxiliary service along with the main API version
    return response.json() | {"main_api_version": SERVICE_VERSION}