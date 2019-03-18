#!/bin/sh

pushd `dirname $0` > /dev/null

if [[ $# == 0 ]] || [[ $1 == "" ]] || [[ $2 == '' ]]; then
    echo "Usage: push.sh <configPath> <env> [--create]"
    exit 1
fi

CONFIGPATH=$1
ENV=$2
CREATE=$3

. src/yaml/parse_yaml.sh

parse_yaml $1

popd > /dev/null
