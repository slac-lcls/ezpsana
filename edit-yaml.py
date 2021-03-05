#!/bin/env python


import yaml


import sys


# Removes the build string from an
# environment dependency entry
def remove_build_string(entry):
    items = entry.split("=")
    return "{}={}".format(items[0], items[1])


# Read input parameters
base_yaml_file = sys.argv[1]
user_yaml_file = sys.argv[2]
output_yaml_file = sys.argv[3]
output_env_name = sys.argv[4]

# Read base YAML environment file
with open(base_yaml_file, "r") as fh:
    base_env = yaml.safe_load(fh)

# Read user YAML environment file
with open(user_yaml_file, "r") as fh:
    user_env = yaml.safe_load(fh)

# Strip build strings for openmpi and mpi
# This is needed because the environments come
# with custom LSF-enabled MPI packages that are
# not available on conda-forge. When we switch to
# SLURM and can use the conda-forge packages, this
# part can be removed
base_env["dependencies"] = [
    remove_build_string(entry)
    if not isinstance(entry, dict)
    and (entry.startswith("openmpi") or entry.startswith("mpi4py"))
    else entry
    for entry in base_env["dependencies"]
]

# Remove the LCLS custom channels
base_env["channels"] = [
    entry
    for entry in base_env["channels"]
    if not entry.startswith("file://") and not entry.startswith("/")
]

# Add user dependencies and set user-provided name
base_env["dependencies"].extend(user_env["dependencies"])
base_env["name"] = output_env_name

# Write output YAML environmentfile
with open(output_yaml_file, "w") as fh:
    fh.writelines(yaml.dump(base_env))
