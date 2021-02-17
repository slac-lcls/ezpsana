#!/usr/bin/env bash

# Load environment
source /img/conda/vars.sh
source activate $CONDA_ENV

exec "$@"
