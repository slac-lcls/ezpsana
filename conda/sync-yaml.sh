#!/bin/bash

version=${1-latest}
pslocation="/cds/sw/ds/ana/conda1/envfiles/"

for yml in "ana-${version}.yml" "ana-${version}-py3.yml"; do

  echo "...> scp ${USER}@psexport.slac.stanford.edu:${pslocation}${yml} ${yml}.template"
  scp ${USER}@psexport.slac.stanford.edu:${pslocation}${yml} ${yml}.template

  #echo "...> removing local channel line in yaml file"
  #grep -v "file:///" tmp.yaml > ana-env-${py}.yaml.template; rm -f tmp.yaml
  #
  #echo "...> changing env name in yaml file to ana-env-${py}"
  #sed -i "s/name: ana/name: ana-${py}/g" ana-env-${py}.yaml.template

  echo "!!!> checkout template file: ${yml}.template"

done
