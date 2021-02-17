#!/usr/bin/env bash

defaultyaml="conda/ana-env-py3.yaml"

inputyaml=${1:-$(defaultyaml)}

if [ ! -f "${inputyaml}" ]; then
  echo "ERROR: ${inputyaml} could not be found. Exiting..."
  exit
else
  image_name=`head -n 1 $inputyaml | awk -v FS=" " '{print $2}'`
fi

set -e

# use absolute paths:
#project_root=$(readlink -f $(dirname ${BASH_SOURCE[0]}))
project_root=$(greadlink -f $(dirname ${BASH_SOURCE[0]}))
# if `readlink -f` is not available on your machine,
# `brew install coreutils` then use `greadlink -f`

echo "build    : $image_name"

docker build                                                    \
    --build-arg inputyaml=$(basename $inputyaml)                \
    -t ${image_name}:latest                                     \
    -f $project_root/docker/Dockerfile                          \
    --no-cache                                                  \
    $project_root
