#!/bin/env python

import argparse
import pathlib
import sys

import docker
import yaml


# Removes the build string from an
# environment dependency entry
def remove_build_string(entry):
    items = entry.split("=")
    return "{}={}".format(items[0], items[1])


parser = argparse.ArgumentParser()
parser.add_argument(
    "-b",
    "--base-env-yaml-file",
    dest="base_env_filename",
    type=str,
    help="YAML file for base environment",
    action="store",
    required=True,
)
parser.add_argument(
    "-a",
    "--additional-deps-yaml-file",
    dest="additional_deps_filename",
    type=str,
    default=None,
    help="YAML file for additional dependencies",
    action="store",
)
parser.add_argument(
    "-l",
    "--additional-channel-yaml-file",
    dest="additional_channel_filename",
    type=str,
    default=None,
    help="YAML file for additional conda channels",
    action="store",
)
parser.add_argument(
    "-o",
    "--output-yaml-file",
    dest="output_filename",
    type=str,
    help="output YAML file name (will be written in the 'docker' directory)",
    action="store",
    required=True,
)
parser.add_argument(
    "-d",
    "--build-docker-container",
    dest="build",
    help="Build docker container",
    action="store_true",
)
parser.add_argument(
    "-c",
    "--no-cache",
    dest="nocache",
    help="Do not use cache when building the docker container",
    action="store_true",
)
parser.add_argument(
    "-r",
    "--repository",
    dest="repository",
    type=str,
    help="Repository for the docker image",
    action="store",
    required=True,
)
parser.add_argument(
    "-t",
    "--tag",
    dest="tag",
    type=str,
    help="Tag for the docker image",
    action="store",
    required=True,
)
parser.add_argument(
    "-v",
    "--version",
    dest="version",
    type=str,
    help="Version for the docker image",
    action="store",
    required=True,
)
args = parser.parse_args()

# Read base YAML environment file
print(
    ">> Reading base environment YAML file: {}".format(
        pathlib.Path(args.base_env_filename)
    )
)
try:
    with open(pathlib.Path(args.base_env_filename), "r") as fh:
        base_env = yaml.safe_load(fh)
except OSError as exc:
    print(">> Error reading the file: {}".format(exc))
    sys.exit(1)

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

# Remove pyopengl if present in the environment
# The "glue" packages are currently removed, but
# this  part of the script will be obsolete once
# glueviz is removed from the original environment
base_env["dependencies"] = [
    entry
    for entry in base_env["dependencies"]
    if not isinstance(entry, dict)
    and not entry.startswith("pyopengl")
    and not entry.startswith("glue")
]

# Remove the LCLS custom channels
base_env["channels"] = [
    entry
    for entry in base_env["channels"]
    if not entry.startswith("file://") and not entry.startswith("/")
]
if args.additional_channel_filename is not None:
    # Read user additional channel YAML file
    print(
        ">> Reading additional channel YAML file: {}".format(
            pathlib.Path(args.additional_channel_filename)
        )
    )
    try:
        with open(pathlib.Path(args.additional_channel_filename), "r") as fh:
            additional_channels = yaml.safe_load(fh)
    except OSError as exc:
        print(">> Error reading the file: {}".format(exc))
        sys.exit(1)

    # Add additional user-provided channel
    print(">> Adding custom channels to base environment")
    base_env["channels"].extend(additional_channels["channels"])

if args.additional_deps_filename is not None:
    # Read user additional dependencies YAML file
    print(
        ">> Reading base environment YAML file: {}".format(
            pathlib.Path(args.additional_deps_filename)
        )
    )
    try:
        with open(pathlib.Path(args.additional_deps_filename), "r") as fh:
            additional_deps = yaml.safe_load(fh)
    except OSError as exc:
        print(">> Error reading the file: {}".format(exc))
        sys.exit(1)

    # Add additional dependencies and set user-provided name
    print(">> Adding custom dependencies to base environment")
    base_env["dependencies"].extend(additional_deps["dependencies"])
    base_env["name"] = "{}-{}".format(args.tag, args.version)

# Write output YAML environment file
print(
    ">> Writing output YAML file: {}".format(
        pathlib.Path("docker") / pathlib.Path(args.output_filename)
    )
)

try:
    with open(
        pathlib.Path("docker") / pathlib.Path(args.output_filename), "w"
    ) as fh:
        fh.writelines(yaml.dump(base_env, sort_keys=False))
except OSError as exc:
    print(">> Error writing the file: {}".format(exc))
    sys.exit(1)

if args.build is True:
    print(
        ">> Building docker image with tag: {}/{}:{}. "
        "Please wait (it can take several minutes)".format(
            args.repository, args.tag, args.version
        )
    )
    try:
        client = docker.from_env()
    except docker.errors.DockerException as ext:
        print(
            "Error accessing the docker service from the system: {}".format(
                ext
            )
        )
        sys.exit(1)
    try:
        client.images.build(
            path=str(pathlib.Path("docker")),
            quiet=False,
            rm=True,
            pull=True,
            nocache=args.nocache,
            tag="{}/{}:{}".format(args.repository, args.tag, args.version),
            buildargs={
                "inputyaml": args.output_filename,
                "psana_version": "{}:{}".format(args.tag, args.version),
            },
        )
    except TypeError as ext:
        print(">> Error: The 'docker' directory could not be found")
        print(ext)
        sys.exit(1)
    except docker.errors.DockerException as ext:
        print(">> Error building the docker image: {}".format(ext))
        print(
            ">> To see the full error, build the image manually with: "
            "'docker build --build-arg inputyaml={} --build-arg psana_version={}:{} "
            "-t {}/{}:{} docker' and see the output of the command ".format(
                args.output_filename,
                args.tag,
                args.version,
                args.repository,
                args.tag,
                args.version,
            )
        )
        sys.exit(1)
    print(
        ">> Image {}/{}:{} built. It can be found in the 'docker images' "
        "list".format(args.repository, args.tag, args.version)
    )
    print(">> To upload the image to DockerHub:")
    print(">> 'docker login'")
    print(
        ">> 'docker push {}/{}:{}'".format(
            args.repository, args.tag, args.version
        )
    )
else:
    print(">> Not building docker image")
    print(
        ">> To build the image manually: 'docker build --build-arg inputyaml={} "
        "--build-arg psana_version={}:{} -t {}/{}:{} docker'".format(
            args.output_filename,
            args.tag,
            args.version,
            args.repository,
            args.tag,
            args.version,
        )
    )
    print(">> Use -d option to build the image automatically")
print(">> Done!")
