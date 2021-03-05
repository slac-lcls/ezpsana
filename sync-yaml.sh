#!/bin/bash

version=${1-latest}
pslocation="/cds/sw/ds/ana/conda1/envfiles/"

for yml in "ana-${version}.yml" "ana-${version}-py3.yml"; do

  echo "...> scp ${USER}@psexport.slac.stanford.edu:${pslocation}${yml} "
  scp ${USER}@psexport.slac.stanford.edu:${pslocation}${yml} yaml/${yml}
  echo "!!!> checkout template file: yaml/${yml}"

done
