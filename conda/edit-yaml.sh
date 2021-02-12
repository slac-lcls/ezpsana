#!/bin/bash

for py in "py2" "py3"; do

  yaml_name="ana-env-${py}.yaml"
  echo "...> editing $yaml_name"

  if [ ! -f ${yaml_name}.template ]; then
    echo "${yaml_name}.template not found!"
  else

    # remove package if there already
    cp ${yaml_name}.template tmp.yaml
    for package in "cudatoolkit" "cupy"; do
      grep -v "${package}" tmp.yaml > tmp2.yaml; mv tmp2.yaml tmp.yaml
    done
    mv tmp.yaml ${yaml_name}

    host=`hostname`
    echo "...> on host $host"
    case ${host:0:2} in

      sd)
        cudatoolkit_version="10.2"
        ;;

      ps)
        cudatoolkit_version="11"
        ;;

      *)
        cudatoolkit_version=""
        ;;

    esac

    if [ "$cudatoolkit_version" != "" ]; then
      echo "...> adding cudatoolkit=$cudatoolkit_version"
      echo "  - cudatoolkit=$cudatoolkit_version" >> ${yaml_name}
    fi

    if [ "$py" == "py3" ]; then
      echo "...> adding cupy"
      echo "  - cupy" >> ${yaml_name}
    fi

  fi

done
