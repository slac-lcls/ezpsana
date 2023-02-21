To build the psana2nersc image, the following steps were carried:

1. Retrieve the latest psana2 .yaml file:
`scp fpoitevi@psexport.slac.stanford.edu:/cds/sw/ds/ana/conda2/manage/env_create.yaml .`
2. Edit and transform it to `env.txt`:
   1. python 3.9 -> 3.10
   2. remove `openmpi`
3. Run the GH action `.github/workflows/psana2-nerc.yaml`
