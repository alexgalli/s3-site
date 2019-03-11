#!/bin/bash

# set up
pushd `dirname $0` > /dev/null

PREV_UMASK=`umask`
umask 022

if [[ $# == 0 ]] || [[ $1 == "" ]] || [[ $2 == "" ]] || [[ $3 == "" ]] || [[ $4 == "" ]] || [[ $5 == "" ]] || [[ $6 == "" ]]; then
    echo "Usage: push_stack.sh <siteName> <env> <certificateArn> <hostedZone> <S3Website> <S3HostedZone> [--create]"
    exit 1
fi

SITENAME=$1
ENV=$2
CERTIFICATEARN=$3
HOSTEDZONE=$4
S3WEBSITE=$5
S3HOSTEDZONE=$6
CREATE=$7

STACKNAME=$SITENAME-$ENV
DEPLOYBUCKET=$STACKNAME-deploy

# package for deploy
aws s3 rm s3://$DEPLOYBUCKET --recursive > /dev/null
PACKAGEOUTPUT=`aws cloudformation package --s3-bucket $DEPLOYBUCKET --template-file cloudformation.yml --output-template-file cloudformation-packaged.yml 2>&1`

if [[ $? != 0 ]]; then
    echo "Error during packaging: $PACKAGEOUTPUT"
    exit 1
fi

# push stack
if [[ $CREATE == '--create' ]]; then
    aws cloudformation create-stack --stack-name $STACKNAME --template-body file://cloudformation-packaged.yml --capabilities CAPABILITY_IAM --parameters \
    ParameterKey=SiteName,ParameterValue=$SITENAME \
    ParameterKey=Environment,ParameterValue=$ENV \
    ParameterKey=CertificateArn,ParameterValue=$CERTIFICATEARN \
    ParameterKey=HostedZone,ParameterValue=$HOSTEDZONE
else
    aws cloudformation update-stack --stack-name $STACKNAME --template-body file://cloudformation-packaged.yml --capabilities CAPABILITY_IAM --parameters \
    ParameterKey=SiteName,ParameterValue=$SITENAME \
    ParameterKey=Environment,ParameterValue=$ENV \
    ParameterKey=CertificateArn,ParameterValue=$CERTIFICATEARN \
    ParameterKey=HostedZone,ParameterValue=$HOSTEDZONE
fi

# clean up package
rm cloudformation-packaged.yml

# clean up
umask $PREV_UMASK
popd > /dev/null
