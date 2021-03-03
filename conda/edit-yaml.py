#!/bin/env python

import sys
import yaml

# Read input parameters
host_type = sys.argv[1]
input_yaml_file = sys.argv[2]
output_yaml_file = sys.argv[3]

# Select cudatoolkit version depending on the host
# type
if host_type == "sdf":
    cudatoolkit_version = "10.2"
elif host_type == "psana":
    cudatoolkit_version = "11"
else:
    print("Host type unknown: {}".format(sys.argv[1]))
    sys.exit(1)

# Read input YAML environment file
with open(input_yaml_file, "r") as fh:
    env = yaml.safe_load(fh)

# Strip build strings for openmpi and mpi
# This is needed because the environments come
# with custom LSF-enabled MPI packages that are
# not available on conda-forge. When we switch to
# SLURM and can use the conda-forge packages, this
# part can be removed
for index, entry in enumerate(env["dependencies"]):
    items = entry.split("=")
    if items[0].strip() == "openmpi" or items[0].strip() == "mpi4py":
        env["dependencies"][index] = "{}={}".format(items[0], items[1])

# Add cudatoolkit and cupy dependencies
env["dependencies"].extend(
    [
        "cudatoolkit={}".format(cudatoolkit_version),
        "cupy",
    ]
)

# Write output YAML environmentfile
with open(output_yaml_file, "w") as fh:
    fh.writelines(yaml.dump(env))
