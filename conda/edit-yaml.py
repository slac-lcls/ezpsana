#!/bin/env python

import sys
import yaml

# Removes the build string from an
# environment dependency entry
def remove_build_string(entry):
    items = entry.split("=")
    return "{}={}".format(items[0], items[1])


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
elif host_type == "none":
    cudatoolkit_version = None
else:
    print("Host type unknown: {}".format(sys.argv[1]))
    sys.exit(1)

# Read input YAML environment file
with open(input_yaml_file, "r") as fh:
    env = yaml.safe_load(fh)

# Extract information about python version
python_entry = next(
    entry
    for entry in env["dependencies"]
    if not isinstance(entry, dict) and entry.startswith("python")
)
python_version = int(python_entry.split("=")[1][0])

# Strip build strings for openmpi and mpi
# This is needed because the environments come
# with custom LSF-enabled MPI packages that are
# not available on conda-forge. When we switch to
# SLURM and can use the conda-forge packages, this
# part can be removed
env["dependencies"] = [
    remove_build_string(entry)
    if not isinstance(entry, dict)
    and (entry.startswith("openmpi") or entry.startswith("mpi4py"))
    else entry
    for entry in env["dependencies"]
]

# Remove the LCLS custom channels
env["channels"] = [
    entry
    for entry in env["channels"]
    if not entry.startswith("file://") and not entry.startswith("/")
]

# Add cudatoolkit and cupy dependencies
if python_version == 3 and cudatoolkit_version is not None:
    env["dependencies"].extend(
        [
            "cudatoolkit={}".format(cudatoolkit_version),
            "cupy",
        ]
    )

# Write output YAML environmentfile
with open(output_yaml_file, "w") as fh:
    fh.writelines(yaml.dump(env))
