#!/usr/bin/env bash

docker_cache_option="--no-cache"
if [ ! ${DOCKER_DEBUG} == "" ]; then
  docker_cache_option=""
  echo "Debugging mode, using cache...."
fi

if [ "$1" == "" ]; then
  echo "ERROR: Please provide input YAML file. Exiting..."
  exit
elif [ ! -f "$1" ]; then
  echo "ERROR: $1 could not be found. Exiting..."
  exit
else
  image_name=`head -n 1 $1 | awk -v FS=" " '{print $2}'`
fi

set -e

echo "build: "${image_name}
echo "YAML file: "$(basename $1)
docker build ${docker_cache_option}                             \
    --build-arg inputyaml=$(basename $1)                        \
    -t ${image_name}                                            \
    docker
