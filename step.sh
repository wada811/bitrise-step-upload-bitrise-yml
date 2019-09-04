#!/bin/bash
set -eux

function is_mac(){
    "$(uname)" == 'Darwin'
}

function replace_newline(){
    if [ is_mac ]; then
        sed -e ':a' -e 'N' -e '$!ba' -e "s/\n/$1/g"
    else
        sed -z "s/\n/$1/g"
    fi
}

yml=$(cat $path_to_bitrise_yml | replace_newline '\\n' | sed -e 's/"/\\"/g')
curl -X POST -H "Authorization: token $bitrise_personal_access_token" \
    "https://api.bitrise.io/v0.1/apps/$app_slug/bitrise.yml" \
    -d @- <<EOS
{"app_config_datastore_yaml":"$yml"}
EOS
