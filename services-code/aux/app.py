from fastapi import FastAPI  # Importing FastAPI framework
import boto3  # Importing Boto3 library for AWS service interactions
import os  # Importing os module to access environment variables
from prometheus_fastapi_instrumentator import Instrumentator  # Importing the Prometheus instrumentator for metrics

# Creating an instance of the FastAPI application
app = FastAPI()

# AWS Configuration
# Fetching the AWS region from environment variables, with a default value
region_name = os.getenv("AWS_REGION", "us-east-1")
# Creating a Boto3 session with the specified region
session = boto3.Session(region_name=region_name)
# Creating an S3 client using the Boto3 session
s3_client = session.client("s3")
# Creating an SSM client using the Boto3 session
ssm_client = session.client("ssm")

# Fetching the service version from environment variables, with a default value
SERVICE_VERSION = os.getenv("SERVICE_VERSION", "1.0.0")

# Setting up metrics instrumentation for the FastAPI app
Instrumentator().instrument(app).expose(app, endpoint="/metrics")


@app.get("/buckets")
def list_buckets():
    """Lists all S3 buckets."""
    # Calling the S3 client to list all buckets
    buckets = s3_client.list_buckets()
    # Returning the names of the buckets along with the service version
    return {
        "buckets": [b["Name"] for b in buckets["Buckets"]],
        "version": SERVICE_VERSION,
    }


@app.get("/parameters")
def list_parameters():
    """Lists all parameters in AWS Parameter Store."""
    # Calling the SSM client to describe all parameters
    params = ssm_client.describe_parameters()
    # Returning the names of the parameters along with the service version
    return {
        "parameters": [p["Name"] for p in params["Parameters"]],
        "version": SERVICE_VERSION,
    }


@app.get("/parameter/{name}")
def get_parameter(name: str):
    """Retrieves the value of a specific parameter."""
    # Calling the SSM client to get a specific parameter by name with decryption
    response = ssm_client.get_parameter(Name=name, WithDecryption=True)
    # Returning the name and value of the parameter along with the service version
    return {
        "name": name,
        "value": response["Parameter"]["Value"],
        "version": SERVICE_VERSION,
    }