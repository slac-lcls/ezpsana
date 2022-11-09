#!/usr/bin/env bash

unset PYTHONPATH
export PYTHONPATH=/home/psana2-build/lcls2/install/lib/python3.9/site-packages
export PYTHONPATH=/home/psana2-build/btx:$PYTHONPATH

mkdir -p $CCP4_SCR
source /home/psana2-build/ccp4-7.1/bin/ccp4.setup-sh

exec "$@"