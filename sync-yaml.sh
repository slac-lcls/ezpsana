#!/bin/bash

pslocation="/cds/sw/ds/ana/conda1/manage/envfiles/"
tplocation="./yaml/psana1"

echo "$> rsync -avr ${USER}@psexport.slac.stanford.edu:${pslocation} ${tplocation}"
rsync -avr ${USER}@psexport.slac.stanford.edu:${pslocation} ${tplocation}

echo "$> rm -f ${tplocation}/ana-latest*.yml"
rm -f ${tplocation}/ana-latest*.yml

echo "$> copying latest yaml file as ana-latest.yml"
latestpy3=`ls ${tplocation}/ana-4.0.*-py3.yml | sort | tail -n 1`
cp $latestpy3 ${tplocation}/ana-latest-py3.yml
latest=`echo $latestpy3 | sed 's/-py3//g'`
cp $latest ${tplocation}/ana-latest.yml

echo "$> ls ${tplocation}/ana-latest*.yml"
ls ${tplocation}/ana-latest*.yml
