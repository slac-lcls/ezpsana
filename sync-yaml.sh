#!/bin/bash

pslocation="/cds/sw/ds/ana/conda1/manage/envfiles/"

echo "$> rsync -avr ${USER}@psexport.slac.stanford.edu:${pslocation} ./yaml"
rsync -avr ${USER}@psexport.slac.stanford.edu:${pslocation} ./yaml

echo "$> rm -f ./yaml/ana-latest*.yml"
rm -f ./yaml/ana-latest*.yml

echo "$> copying latest yaml file as ana-latest.yml"
latestpy3=`ls yaml/ana-4.0.*-py3.yml | sort | tail -n 1`
cp $latestpy3 ./yaml/ana-latest-py3.yml
latest=`echo $latestpy3 | sed 's/-py3//g'`
cp $latest ./yaml/ana-latest.yml

echo "$> ls yaml/ana-latest*.yml"
ls yaml/ana-latest*.yml
