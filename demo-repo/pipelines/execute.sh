#! /bin/bash
set -euo pipefail

ACTION_COMMAND=${1}
ROOT_OF_REPO=$(pwd)

for ACTION_OUTPUT in $(cat execute.txt); do

  if [[ ${ACTION_OUTPUT} != "#"* ]]; then

  echo "*****************************"
  echo "Processing ${ACTION_OUTPUT}"
  echo "*****************************"
  cd ${ACTION_OUTPUT}
  ${ACTION_COMMAND}
  cd ${ROOT_OF_REPO}
  fi

done