# Build psana environment

## Prepare the recipes

### Retrieve latest stable psana environments maintained by Valerio Mariani on /cds
```bash
./sync-yaml.sh
```

### Write YAML from template, corresponding to host
The following script adds a few packages to the stable psana environment, hoping a solution exists. Some package versions, like `cudatoolkit`, will vary from a host to another; this can be dealt with in this script.
```bash
./edit-yaml.sh
```

## Create the environments from the recipes

### install Miniconda, if necessary

Follow the instructions [here](https://docs.conda.io/en/latest/miniconda.html).

### build the environment

Then simply run the following script (not that it is equivalent to just do `conda env create -f <.yaml>` at this point).
```bash
./build-envs.sh <path to .yaml file>
```


