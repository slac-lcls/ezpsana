#!/bin/bash

version=${1-latest}
pslocation="/cds/sw/ds/ana/conda1/envfiles/"

for yml in "ana-${version}.yml" "ana-${version}-py3.yml"; do

  echo "...> scp ${USER}@psexport.slac.stanford.edu:${pslocation}${yml} ${yml}.template"
  scp ${USER}@psexport.slac.stanford.edu:${pslocation}${yml} ${yml}.template
  echo "!!!> checkout template file: ${yml}.template"

done
