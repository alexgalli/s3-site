#!/bin/sh

SITENAME=alexgalli
SITEPATH=$PROJECTPATH/sites/$SITENAME/site/
SITEURL=alexgalli.co

if [[ $# != 1 ]]; then
    echo "Usage: push-site.sh <env>"
    exit 1
fi

SITEENV=$1

if [[ $SITEENV != "prod" ]]; then
    S3PATH=$SITEENV.$SITEURL
else
    S3PATH=$SITEURL
fi

aws s3 sync --delete $SITEPATH s3://$S3PATH/
