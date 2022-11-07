#!/usr/bin/env bash

unset LD_LIBRARY_PATH
unset PYTHONPATH

source /opt/anaconda3/etc/profile.d/conda.sh
export PATH=/home/psana2-build/lcls2/install/bin:$PATH
export PATH=/home/psana-build/btx/scripts:$PATH
export PYTHONPATH=/home/psana2-build/lcls2/install/lib/python3.9/site-packages
export PYTHONPATH=/home/psana2-build/btx:$PYTHONPATH

exec "$@"