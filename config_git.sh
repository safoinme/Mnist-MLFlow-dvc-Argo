#!/bin/sh
set -e -x

# Verify our environment variables are set
[ -z "${GIT_REPO}" ] && { echo "Need to set GIT_REPO"; exit 1; }
[ -z "${GIT_BRANCH}" ] && { echo "Need to set GIT_BRANCH"; exit 1; }
[ -z "${COMMIT_USER}" ] && { echo "Need to set COMMIT_USER"; exit 1; }
[ -z "${COMMIT_EMAIL}" ] && { echo "Need to set COMMIT_EMAIL"; exit 1; }


# Set up our SSH Key
if [ ! -d ~/.ssh ]; then
	mkdir /root/.ssh
	cp /secret/mountpath/ssh-privatekey /root/.ssh/id_rsa
	ls -la /root/.ssh
	chmod 700 /root/.ssh
	chmod 600 /root/.ssh/id_rsa
	#echo -e "Host *\n    StrictHostKeyChecking no\n    UserKnownHostsFile=/dev/null\n" > /root/.ssh/config
fi


# Configure our user and email to commit as.
git config user.name "${COMMIT_USER}"
git config user.email "${COMMIT_EMAIL}"
git remote add origin ${GIT_REPO}
git checkout -t origin ${GIT_BRANCH}

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