#!/bin/bash

AWS_ACCOUNT_ID=572600675123
AWS_REGION=ap-northeast-1
PROFILE=yosetti-rhythm
REPOSITORY=${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com
CONTEXT=yosetti-com-ecs

COMMANDS=(
"Docker-Rebuild"
"Docker-Up"
"Docker-Down"
"Composer-Install"
"Init-DB"
"Ide-helper-generate"
"Ide-helper-models"
"UnitTest"
"Connect-Nginx"
"Connect-PHP"
"Staging-ECR-Push"
"Production-ECR-Push"
)


if [ -z "$1" ]; then
  echo Please select a command.
  select COMMAND in ${COMMANDS[@]}
  do
    if [ -z "$COMMAND" ]; then
      continue
    else
      break
    fi
  done
  echo You selected $REPLY\) $COMMAND
else
  COMMAND="$1"
fi


. ./commands/local.sh
. ./commands/staging.sh
. ./commands/production.sh
