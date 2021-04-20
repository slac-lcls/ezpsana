#!/bin/bash

pslocation="/cds/sw/ds/ana/conda1/envfiles/"

rsync -avr ${USER}@psexport.slac.stanford.edu:${pslocation} ./yaml

