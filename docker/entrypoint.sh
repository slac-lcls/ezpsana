#!/usr/bin/env bash

# Load environment
source /img/conda/vars.sh
source activate /img/conda.local/miniconda3/envs/$CONDA_ENV

exec "$@"
