#!/usr/bin/env bash

unset PYTHONPATH
export PYTHONPATH=/home/psana2-build/lcls2/install/lib/python3.9/site-packages
export PYTHONPATH=/home/psana2-build/btx:$PYTHONPATH

exec "$@"