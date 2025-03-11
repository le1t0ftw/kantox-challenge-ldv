from fastapi import FastAPI
import boto3
import os
from prometheus_fastapi_instrumentator import Instrumentator

app = FastAPI()
region_name = os.getenv("AWS_REGION", "us-east-1")
session = boto3.Session(region_name=region_name)
s3_client = session.client("s3")
ssm_client = session.client("ssm")
SERVICE_VERSION = os.getenv("SERVICE_VERSION", "1.0.0")
Instrumentator().instrument(app).expose(app, endpoint="/metrics")


@app.get("/buckets")
def list_buckets():
    buckets = s3_client.list_buckets()
    return {
        "buckets": [b["Name"] for b in buckets["Buckets"]],
        "version": SERVICE_VERSION,
    }


# comment
@app.get("/parameters")
def list_parameters():
    params = ssm_client.describe_parameters()
    return {
        "parameters": [p["Name"] for p in params["Parameters"]],
        "version": SERVICE_VERSION,
    }


@app.get("/parameters/{name}")
def get_parameter(name: str):
    response = ssm_client.get_parameter(Name=name, WithDecryption=True)
    return {
        "name": name,
        "value": response["Parameter"]["Value"],
        "version": SERVICE_VERSION,
    }
