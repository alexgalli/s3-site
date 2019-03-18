#!/bin/sh

if [[ $# != 3 ]] || [[ $1 == "" ]] || [[ $2 == "" ]] || [[ $3 == "" ]]; then
    echo "Usage: push-site.sh <siteUrl> <env> <filePath>"
    exit 1
fi

SITEURL=$1
ENV=$2
FILEPATH=$3

SITEENV=$1

if [[ $ENV != "prod" ]]; then
    S3PATH=$ENV.$SITEURL
else
    S3PATH=$SITEURL
fi

aws s3 sync --delete $FILEPATH s3://$S3PATH/
