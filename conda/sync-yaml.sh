#!/bin/bash

for py in "py2" "py3"; do

  echo "...> scp ${USER}@psexport.slac.stanford.edu:/cds/sw/ds/ana/conda1/manage-feedstocks/jenkins/ana-env-${py}.yaml tmp.yaml"
  scp ${USER}@psexport.slac.stanford.edu:/cds/sw/ds/ana/conda1/manage-feedstocks/jenkins/ana-env-${py}.yaml tmp.yaml

  echo "...> removing local channel line in yaml file"
  grep -v "file:///" tmp.yaml > ana-env-${py}.yaml.template; rm -f tmp.yaml

  echo "...> changing env name in yaml file to ana-env-${py}"
  sed -i "s/name: ana/name: ana-${py}/g" ana-env-${py}.yaml.template

  echo "!!!> checkout template file: ana-env-${py}.yaml.template"

done
