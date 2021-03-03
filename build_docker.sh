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
  image_name=`grep name $1 | awk -v FS=" " '{print $2}'`
  version=${image_name#*-}
  prefix=${image_name/-$version/}
  echo $prefix $version
fi

set -e

echo "build: "${prefix}:${suffix}
echo "YAML file: "$(basename $1)
docker build ${docker_cache_option}                             \
    --build-arg inputyaml=$(basename $1)                        \
    --build-arg psana_version=${version}                        \
    --tag slaclcls/${prefix}:${version}                         \
    docker