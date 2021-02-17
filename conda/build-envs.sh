#!/usr/bin/env bash
# This script creates the conda environment
# assuming conda can be found.
# It is not part of the docker image.

set -e


if [ $# -ne 1 ]; then
  echo "Usage: $0 <path-to-yaml>"; exit
fi
if [ ! -f $1 ]; then
  echo "Error! $1 not found..."; exit
fi

# access "our conda"
if [[ -e $(readlink -f $(dirname ${BASH_SOURCE[0]}))/../conda.local/env.sh ]]; then
    source $(readlink -f $(dirname ${BASH_SOURCE[0]}))/../conda.local/env.sh
fi

env_name=`head -n 1 $1 | awk -v FS=" " '{print $2}'`
if [ -f vars.sh ]; then
  rm -f vars.sh
fi
echo "export CONDA_ENV=$env_name" > ./vars.sh

# check if already installed
# this will only match packages in the current env root
env_grep=$(conda env list | tr '/' 'x' | grep -w $env_name  || true)
# don't match paths        ^^^^^^^^^^^^       ^^
if [[ -n $env_grep ]]; then
  echo "...> $env_name already exists."
  echo "...> To overwrite, try again after doing this:"
  echo "...> conda env remove -n $env_name"
  exit
fi

echo "...> about to create $env_name"
conda env create -f $1

echo "...> activating $env_name ..."
source activate $env_name
