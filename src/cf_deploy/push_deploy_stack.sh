#!/bin/bash

pushd `dirname $0` > /dev/null

if [[ $# == 0 ]] || [[ $1 == "" ]] || [[ $2 == '' ]]; then
    echo "Usage: push_deploy_stack.sh <siteName> <env> [--create]"
    exit 1
fi

SITENAME=$1
ENV=$2
CREATE=$3

DEPLOYSTACKNAME=$SITENAME-$ENV-deploy

if [[ $CREATE == '--create' ]]; then
    aws cloudformation create-stack --stack-name $DEPLOYSTACKNAME --template-body file://deploy.yml --parameters ParameterKey=Environment,ParameterValue=$ENV ParameterKey=SiteName,ParameterValue=$SITENAME
else
    aws cloudformation update-stack --stack-name $DEPLOYSTACKNAME --template-body file://deploy.yml --parameters ParameterKey=Environment,ParameterValue=$ENV ParameterKey=SiteName,ParameterValue=$SITENAME
fi

popd > /dev/null
