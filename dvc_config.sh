#!/bin/sh

DVC_BUCKET = s3://dvc-bucket/
DVC_ENDPOINT_URL = http://10.105.56.43:9000
DVC_AWS_ACCESS_KEY_ID = "minio"
DVC_AWS_SECRET_ACCESS_KEY = "Do&BfNOtNcWqGtWV5i"

dvc remote add -d minikubeminio ${DVC_BUCKET} 
dvc remote modify minikubeminio endpointurl ${DVC_ENDPOINT_URL} 
dvc remote modify minikubeminio access_key_id ${DVC_AWS_ACCESS_KEY_ID}
dvc remote modify minikubeminio secret_access_key ${DVC_AWS_SECRET_ACCESS_KEY}
dvc pull
