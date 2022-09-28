#!/usr/bin/env bash

source /opt/anaconda/etc/profile.d/conda.sh
conda activate ana
export PATH=/home/btx-build/btx/scripts:$PATH

exec "$@"