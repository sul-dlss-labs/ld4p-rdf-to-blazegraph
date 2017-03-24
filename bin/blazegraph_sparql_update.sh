#!/bin/bash

usage () {
    echo "Usage: $0 {blazegraph_sparql_url} {rdfxml_file}"
    echo
    echo "e.g.:  $0 http://localhost:9999/blazegraph/namespace/kb/sparql ./data/test/one_record.rdf"
    echo
    exit
}

if [ "$1" == "-h" -o "$1" == "--help" ]; then
    usage
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

rdf_file=$2

if [ ! -f "${rdf_file}" ]; then
    echo
    echo "ERROR: RDF file does not exist: ${rdf_file}"
    echo
    usage
    exit 1
fi

# ---
# Load data

# log message with timestamp to STDOUT, so they can be redirected to a log file.
log_stamp=$(date --iso-8601=sec)
echo "${log_stamp}  Uploading ${rdf_file} into ${bg_sparql}"

curl -s -X POST -H 'Content-Type:application/rdf+xml' --data-binary "@${rdf_file}" ${bg_sparql}
echo

