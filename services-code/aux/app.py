from fastapi import FastAPI
import boto3
import os

app = FastAPI()

region_name = os.getenv("AWS_REGION", "us-east-1")
session = boto3.Session(region_name=region_name)
s3_client = session.client("s3")
ssm_client = session.client("ssm")

# Obtener versión del servicio
SERVICE_VERSION = os.getenv("SERVICE_VERSION", "1.0.0")


@app.get("/buckets")
def list_buckets():
    """Lista todos los buckets de S3."""
    buckets = s3_client.list_buckets()
    return {
        "buckets": [b["Name"] for b in buckets["Buckets"]],
        "version": SERVICE_VERSION,
    }


@app.get("/parameters")
def list_parameters():
    """Lista todos los parámetros en AWS Parameter Store."""
    params = ssm_client.describe_parameters()
    return {
        "parameters": [p["Name"] for p in params["Parameters"]],
        "version": SERVICE_VERSION,
    }


@app.get("/parameter/{name}")
def get_parameter(name: str):
    """Obtiene el valor de un parámetro específico."""
    response = ssm_client.get_parameter(Name=name, WithDecryption=True)
    return {
        "name": name,
        "value": response["Parameter"]["Value"],
        "version": SERVICE_VERSION,
    }
