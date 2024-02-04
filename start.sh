#!/bin/bash

##
## This script has been crafted to be able to register a GitHub selfhosted runner into GitHub.
## The registration can be of two types, at the github repository level or are the organization level.
## The options need to be configured accordingly, leaving the unwanted options commented out.
##


##
## Use REPOSITORY to link the runner to a specific repository
##
# REPOSITORY=$REPO
# echo "REPO ${REPOSITORY}"

##
## Use ORG_NAME to specify your GitHub organization name
##
ORG_NAME=$ORG
echo "ORG_NAME ${ORG_NAME}"

##
## This is the PAT generated to use in automation
##
ACCESS_TOKEN=$TOKEN
echo "ACCESS_TOKEN ${ACCESS_TOKEN}"

##
## This line is used with REPOSITORY level runners
##
# REG_TOKEN=$(curl -X POST -H "Authorization: token ${ACCESS_TOKEN}" -H "Accept: application/vnd.github+json" https://api.github.com/repos/${REPOSITORY}/actions/runners/registration-token | jq .token --raw-output)

##
## This line is used with ORGANIZATION level runners
##
REG_TOKEN=$(curl -X POST -H "Authorization: token ${ACCESS_TOKEN}" -H "Accept: application/vnd.github.v3+json" "https://api.github.com/orgs/${ORG_NAME}/actions/runners/registration-token" | jq .token --raw-output)


cd /home/docker/actions-runner

##
## Configure the runner for a repository
##
# ./config.sh --url https://github.com/${REPOSITORY} --token ${REG_TOKEN}

##
## Configure the runner for the organization
##
./config.sh --url https://github.com/${ORG_NAME} --token ${REG_TOKEN}


cleanup() {
    echo "Removing runner..."
    ./config.sh remove --unattended --token ${REG_TOKEN}
}

trap 'cleanup; exit 130' INT
trap 'cleanup; exit 143' TERM

./run.sh & wait $!
