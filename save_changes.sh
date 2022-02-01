#!/bin/sh

#Add dataset folder changes
dvc add dataset
git add *.dvc

# Check to see if there are changes
CHANGES_FOUND=""

CHANGES=`git status -s | awk {'print $2'}`
if [ -z "${CHANGES}" ]; then
	echo "No changes detected."
	echo "Must be changes on dataset folder"
    exit
fi

# Commit and push the detected changes if they are found.
if [ ! -z "${CHANGES_FOUND}" ]; then
	echo "Changes detected."
    current="`date +'%Y-%m-%d %H:%M:%S'`"
    message="Dataset detected changes: $current"
	git commit -m "$msg"
    dvc push
	git push origin argo
fi

