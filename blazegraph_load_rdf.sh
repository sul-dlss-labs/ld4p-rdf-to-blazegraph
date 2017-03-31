#!/bin/bash

# ---
# Help

usage () {
    cat <<HERE
Usage:
$0 {blazegraph_sparql_uri} {rdf_data} > log/blazegraph_load.log 2>&1

Examples:

- loading a directory of files
$0 http://localhost:9999/blazegraph/namespace/kb/sparql ./data/test

- loading a single file
$0 http://localhost:9999/blazegraph/namespace/kb/sparql ./data/test/one_record.rdf 

HERE
}


# ---
# Function to use SPARQL update for loading RDF into blazegraph

export CONTENT_TYPE='application/rdf+xml'

sparql_update () {
    rdf_file=$1

    # log message with timestamp to STDOUT, so they can be redirected to a log file.
    log_stamp=$(date --iso-8601=sec)
    echo "${log_stamp}  Uploading ${rdf_file} into ${BG_SPARQL}"
    
    curl -s -X POST -H "Content-Type:${CONTENT_TYPE}" --data-binary "@${rdf_file}" ${BG_SPARQL}
    echo
}


# ---
# Function to load data from a directory

load_rdf_directory () {
    rdf_path=$1
    echo "Loading RDF files ${rdf_path}/*.* into ${BG_SPARQL}"
    for f in $(find ${rdf_path} -type f); do
        sparql_update $f
    done
}


# ---
# Parse input parameters and execute loading


if [ "$1" == '-h' -o "$1" == '--help' ]; then
    usage
    exit
fi


export BG_SPARQL=$1

if [ -z "${BG_SPARQL}" ]; then
    echo
    echo "ERROR: SPARQL URI is undefined."
    echo
    usage
    exit 1
fi


rdf_data=$2

if   [ -d "${rdf_data}" ]; then
    # Process a directory of RDF data
    load_rdf_directory $rdf_data

elif [ -f "${rdf_data}" ]; then
    # Process one RDF data file
    sparql_update $rdf_data

else
    echo
    echo "ERROR: RDF data is not a directory or a file: ${rdf_data}"
    echo
    usage
    exit 1
fi


