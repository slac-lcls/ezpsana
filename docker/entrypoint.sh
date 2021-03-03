#!/usr/bin/env bash

source /opt/anaconda/etc/profile.d/conda.sh
conda activate ana

exec "$@"
