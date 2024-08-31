#!/bin/bash

source ./src/RunnerHelper.sh

if ! [ -f $F_ENV ]; then
    touch $F_ENV
    echo $C_ENV_TOKEN_FORMAT_DEF >> $F_ENV
    echo $C_ENV_RUNNERS_ID_DEF >> $F_ENV
    echo -e $T_MISSING_ENV; echo -e $T_FILL_ENV
    ls -la $F_ENV
    open $F_ENV
    exit 1
else
    source .env
    validate_token $ENV_TOKEN
    download_installer
    IFS=" "; read -ra ids <<< "$ENV_RUNNERS_ID"
    for id in "${ids[@]}"; do
        ttab -w -t "$C_ORG-Rnr-$id" "$S_RUNNER $ENV_TOKEN $id"
    done
fi