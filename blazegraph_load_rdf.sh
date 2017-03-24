#!/bin/bash

# ---
# Help

usage () {
    cat <<HERE
Usage:
$0 {blazegraph_sparql_uri} {rdf_data_directory } > log/blazegraph_load.log 2>&1

Example:
$0 http://localhost:9999/blazegraph/namespace/kb/sparql ./data/test

HERE
}

if [ "$1" == '-h' -o "$1" == '--help' ]; then
    usage
    exit
fi


# ---
# Check the input parameters

bg_sparql=$1

if [ -z "${bg_sparql}" ]; then
    echo
    echo "ERROR: SPARQL URI is undefined."
    echo
    usage
    exit 1
fi

rdf_path=$2

if [ ! -d "${rdf_path}" ]; then
    echo
    echo "ERROR: RDF data path is not a directory: ${rdf_path}"
    echo
    usage
    exit 1
fi


# ---
# Load data

SCRIPT_PATH=$( cd $(dirname $0) && pwd -P )

echo "Loading RDF files ${rdf_path}/*.rdf into ${bg_sparql}"
find ${rdf_path} -type f -name '*.rdf' \
  -exec ${SCRIPT_PATH}/bin/blazegraph_sparql_update.sh ${bg_sparql} {} \;

