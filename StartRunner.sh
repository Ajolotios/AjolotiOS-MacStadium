#!/bin/bash

source ./src/RunnerHelper.sh

validate_token $1
ttab -w -t "$C_ORG-Rnr-$2" "$S_RUNNER $1 $2"