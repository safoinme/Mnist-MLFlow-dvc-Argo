#!/bin/sh

#Add data changes to dvc (in this case it's dataset folder)
dvc add dataset

# initialise found changes empty will be used later to check that there is a change
CHANGES_FOUND=""

# saving names of changed files in change using status command
CHANGES=`git status -s | awk {'print $2'}`

# check if no change is done , the code will exit and print that changes must be made since the script was called
if [ -z "${CHANGES}" ]; then
	echo "No changes detected."
	echo "Must be changes on dataset folder"
    exit
fi

# Add all changed files that end with .dvc to our git ! the objective of the script is to save changes on data not code that's why we only add .dvc
for changed_file in ${CHANGES}; do
    echo "entered loop ${changed_file}"
	if if [ "${changed_file: -4}" == ".dvc" ]; then
        echo "chnages are in ${changed_file}"
		CHANGES_FOUND="1"
		git add ${changed_file}
	fi
done

# Commit and push the detected changes if they are found. and push new dataset version to S3 Storage
if [ ! -z "${CHANGES_FOUND}" ]; then
	echo "Changes detected."
    current="`date +'%Y-%m-%d %H:%M:%S'`"
    message="Dataset detected changes: $current"
	git commit -m "$message"
	git push origin argo
    dvc push
fi
