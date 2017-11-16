#!/bin/sh
#
# Simple script that will display docker repository tags.
#
# Usage:
#   $ docker-show-repo-tags.sh ubuntu
IMAGE_NAME=$1

if [[ $IMAGE_NAME != *"/"* ]]
then
    NAMESPACE=library/
fi

curl -s -S "https://registry.hub.docker.com/v2/repositories/${NAMESPACE}${IMAGE_NAME}/tags/" | \
    sed -e 's:,:,\n:g' -e 's:\[:\[\n:g' | \
    grep '"name"' | \
    awk -F\" '{print $4;}' | \
    sort -fu | \
    sed -e "s|^|${IMAGE_NAME}:|"
