#!/bin/sh

pushd `dirname $0` > /dev/null

if [[ $# == 0 ]] || [[ $1 == "" ]] || [[ $2 == '' ]]; then
    echo "Usage: push.sh <configPath> <env> <--deploy/--stack/--site> [--create]"
    exit 1
fi

CONFIGPATH=$1
ENV=$2
MODE=$3
CREATE=$4

. src/yaml/parse_yaml.sh

eval $(parse_yaml $CONFIGPATH)

if [[ $MODE == "--deploy" ]]; then
    if [[ $CREATE == "--create" ]]; then
        bash src/cf_deploy/push_deploy_stack.sh $site_name $ENV --create
    else
        bash src/cf_deploy/push_deploy_stack.sh $site_name $ENV
    fi
fi
if [[ $MODE == "--stack" ]]; then
    if [[ $CREATE == "--create" ]]; then
        bash src/cf_site/push_stack.sh $site_name $ENV $site_certificate_arn $site_hosted_zone $site_s3_website $site_s3_hosted_zone --create
    else
        bash src/cf_site/push_stack.sh $site_name $ENV $site_certificate_arn $site_hosted_zone $site_s3_website $site_s3_hosted_zone
    fi
fi
if [[ $MODE == "--site" ]]; then
    bash src/cf_site/push_site.sh $site_hosted_zone $ENV $site_file_path
fi

popd > /dev/null
