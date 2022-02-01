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
	chmod 700 /root/.ssh
	chmod 600 /root/.ssh/id_rsa
	#echo -e "Host *\n    StrictHostKeyChecking no\n    UserKnownHostsFile=/dev/null\n" > /root/.ssh/config
fi

git status 

# Configure our user and email to commit as.
ssh-keyscan -t rsa github.com >> ~/.ssh/known_hosts
ssh-keygen -t rsa -C "${COMMIT_EMAIL}"
git config user.name "${COMMIT_USER}"
git config user.email "${COMMIT_EMAIL}"
git remote set-url origin ${GIT_REPO}
#it checkout -t origin ${GIT_BRANCH}

dvc pull
