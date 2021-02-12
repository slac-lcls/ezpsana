#!/bin/bash

if [ $# -ne 1 ]; then 
  echo "Usage: $0 <path-to-yaml>"; exit
fi
if [ ! -f $1 ]; then
  echo "Error! $1 not found..."; exit
fi

env_name=`head -n 1 $1 | awk -v FS=" " '{print $2}'`

exist=`conda env list | grep -q "$env_name " && echo $?`
if [ "$exist" == 0 ]; then
  echo "...> $env_name already exists. Try again after doing this:"
  echo "...> conda env remove -n $env_name"
  exit
fi

echo "...> about to create $env_name"
conda env create -f $1

