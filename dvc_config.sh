#!/bin/sh

dvc remote add -d minikubeminio s3://dvc-bucket/
dvc remote modify minikubeminio endpointurl http://10.105.56.43:9000
dvc remote modify minikubeminio access_key_id "minio"
dvc remote modify minikubeminio secret_access_key "Do&BfNOtNcWqGtWV5i"
dvc pull
