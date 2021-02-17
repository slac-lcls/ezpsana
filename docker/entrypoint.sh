#!/usr/bin/env bash

source /img/conda.local/env.sh
# Load environment
source /img/conda/vars.sh
source activate /img/conda.local/miniconda3/envs/$CONDA_ENV

exec "$@"
