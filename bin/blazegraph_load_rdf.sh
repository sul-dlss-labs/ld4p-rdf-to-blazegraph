#!/bin/bash

SCRIPT_PATH=$( cd $(dirname $0) && pwd -P )
export LD4P_ROOT=$( cd "${SCRIPT_PATH}/.." && pwd -P )
source ${LD4P_ROOT}/config/config.sh
source ${LD4P_ROOT}/config/config_blazegraph.sh

# ---
# Check the configuration

if [ ! -d "${LD4P_MARCRDF}" ]; then
    echo "LD4P_MARCRDF path is not a directory: ${LD4P_MARCRDF}"
    exit 1
fi

if [ -z "${BG_SPARQL}" ]; then
    echo "BG_SPARQL is undefined."
    exit 1
fi

# ---
# Help

if [ "$1" == '-h' -o "$1" == '--help' ]; then
    cat <<HERE
Usage:
$0 > log/blazegraph_load.log 2>&1

NOTES:
  - this script must be run on a system able to connect to a blazegraph SPARQL endpoint
  - this script calls:
    - ${LD4P_ROOT}/config/config.sh
    - ${LD4P_ROOT}/config/config_blazegraph.sh

HERE
    exit
fi

# ---
# Load data

echo "Blazegraph loading MARC-RDF files ${LD4P_MARCRDF}/*.rdf into graph: ${BG_GRAPH}"
find ${LD4P_MARCRDF} -type f -name '*.rdf' \
  -exec ${LD4P_ROOT}/bin/blazegraph_sparql_update.sh ${BG_SPARQL} {} \;

