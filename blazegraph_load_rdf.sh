#!/bin/bash

# ---
# Help

usage () {
    cat <<HELP
Usage:

$0 {sparql_uri} {rdf_data} [content_type]

content_type is optional, it defaults to 'application/rdf+xml'

Examples:

SPARQL_URI='http://localhost:9999/blazegraph/namespace/kb/sparql'

# loading a directory of files (all files must have the content_type)
$0 \$SPARQL_URI ./data/test/rdfxml
$0 \$SPARQL_URI ./data/test/turtle text/turtle

# loading a single file
$0 \$SPARQL_URI ./data/test/one_record.rdf
$0 \$SPARQL_URI ./data/test/one_record.ttl text/turtle

HELP
}


# ---
# Function to use SPARQL update for loading RDF into blazegraph

sparql_update () {
    rdf_file=$1

    # log message with timestamp to STDOUT, so they can be redirected to a log file.
    log_stamp=$(date --iso-8601=sec)
    echo "${log_stamp}  Uploading ${rdf_file} into ${SPARQL_URI}"
    
    curl -s -X POST -H "Content-Type:${CONTENT_TYPE}" --data-binary "@${rdf_file}" ${SPARQL_URI}
    echo
}


# ---
# Function to load data from a directory

load_rdf_directory () {
    rdf_path=$1
    echo "Loading RDF files ${rdf_path}/*.* into ${SPARQL_URI}"
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

export SPARQL_URI=$1

if [ -z "${SPARQL_URI}" ]; then
    echo
    echo "ERROR: SPARQL URI is undefined."
    echo
    usage
    exit 1
fi

export RDF_DATA=$2

if [ -z "${RDF_DATA}" ]; then
    echo
    echo "ERROR: RDF_DATA is undefined."
    echo
    usage
    exit 1
fi

export CONTENT_TYPE=$3

if [ -z "${CONTENT_TYPE}" ]; then
    export CONTENT_TYPE='application/rdf+xml'
fi


# ---
# Process RDF_DATA

if   [ -d "${RDF_DATA}" ]; then
    # Process a directory of RDF data
    load_rdf_directory $RDF_DATA

elif [ -f "${RDF_DATA}" ]; then
    # Process one RDF data file
    sparql_update $RDF_DATA

else
    echo
    echo "ERROR: RDF data is not a directory or a file: ${RDF_DATA}"
    echo
    usage
    exit 1
fi

