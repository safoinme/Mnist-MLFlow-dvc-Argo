#!/bin/sh
set -e -x

# Verify our environment variables are set
[ -z "${GIT_REPO}" ] && { echo "Need to set GIT_REPO"; exit 1; }
[ -z "${GIT_BRANCH}" ] && { echo "Need to set GIT_BRANCH"; exit 1; }
[ -z "${COMMIT_USER}" ] && { echo "Need to set COMMIT_USER"; exit 1; }
[ -z "${COMMIT_EMAIL}" ] && { echo "Need to set COMMIT_EMAIL"; exit 1; }
[ -z "${DVC_BUCKET}" ] && { echo "Need to set GIT_REPO"; exit 1; }
[ -z "${DVC_S3_ENDPOINT_URL}" ] && { echo "Need to set GIT_BRANCH"; exit 1; }
[ -z "${AWS_ACCESS_KEY_ID}" ] && { echo "Need to set COMMIT_USER"; exit 1; }
[ -z "${AWS_SECRET_ACCESS_KEY}" ] && { echo "Need to set COMMIT_EMAIL"; exit 1; }

# Set up our SSH Key
if [ ! -d /root/.ssh ]; then
	mkdir /root/.ssh
	cp /secret/mountpath/ssh-privatekey /root/.ssh/id_rsa
	chmod 700 /root/.ssh
	chmod 600 /root/.ssh/id_rsa
	#echo -e "Host *\n    StrictHostKeyChecking no\n    UserKnownHostsFile=/dev/null\n" > /root/.ssh/config
fi

dvc remote add minio ${DVC_BUCKET} --global
dvc config core.remote minio 
dvc remote modify minio endpointurl ${DVC_S3_ENDPOINT_URL} --global 
dvc remote modify minio access_key_id "${AWS_ACCESS_KEY_ID}" --global
dvc remote modify minio secret_access_key "${AWS_SECRET_ACCESS_KEY}" --global
dvc pull

# Configure our user and email to commit as.
ssh-keyscan -t rsa github.com >> ~/.ssh/known_hosts
git config --global user.name "${COMMIT_USER}"
git config --global user.email "${COMMIT_EMAIL}"
git remote set-url origin ${GIT_REPO}
#it checkout -t origin ${GIT_BRANCH}

