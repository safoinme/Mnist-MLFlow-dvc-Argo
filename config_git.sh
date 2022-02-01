#!/bin/sh
set -e -x

# Verify our environment variables are set
[ -z "${COMMIT_USER}" ] && { echo "Need to set COMMIT_USER"; exit 1; }
[ -z "${COMMIT_EMAIL}" ] && { echo "Need to set COMMIT_EMAIL"; exit 1; }


# Set up our SSH Key
if [ ! -d ~/.ssh ]; then
	echo "SSH Key was not found. Configuring SSH Key."
	mkdir ~/.ssh
	cp /secret/mountpath/ssh-privatekey ~/.ssh/id_rsa
	chmod 700 ~/.ssh
	chmod 600 ~/.ssh/id_rsa

	echo -e "Host *\n    StrictHostKeyChecking no\n    UserKnownHostsFile=/dev/null\n" > ~/.ssh/config
fi


# Configure our user and email to commit as.
git config user.name "${COMMIT_USER}"
git config user.email "${COMMIT_EMAIL}"

# Configure dvc and pull dataset.
dvc remote add -d minikubeminio s3://dvc-bucket/
dvc remote modify minikubeminio endpointurl http://10.105.56.43:9000
dvc remote modify minikubeminio access_key_id "minio"
dvc remote modify minikubeminio secret_access_key "Do&BfNOtNcWqGtWV5i"
dvc pull

#dvc remote add -d minikubeminio s3://dvc-bucket/
#dvc remote modify minikubeminio endpointurl http://10.105.56.43:9000
#dvc remote modify minikubeminio access_key_id "minio"
#dvc remote modify minikubeminio secret_access_key "Do&BfNOtNcWqGtWV5i"
#dvc pull