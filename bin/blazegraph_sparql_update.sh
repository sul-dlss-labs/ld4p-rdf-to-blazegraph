#!/bin/bash

usage () {
    echo "Usage: $0 {blazegraph_sparql_url} {rdfxml_file}"
    echo
    echo "e.g.:  $0 http://localhost:9999/blazegraph/namespace/kb/sparql ./example_file.rdf"
    echo
    exit
}

if [ "$1" == "-h" -o "$1" == "--help" ]; then
    usage
fi
if [ -z "$1" -a -z "$2" ]; then
    usage
fi
bg_sparql=$1
rdf_file=$2

log_stamp=$(date --iso-8601=sec)
echo "${log_stamp}  Uploading ${rdf_file} into ${bg_sparql}"

curl -s -X POST -H 'Content-Type:application/rdf+xml' --data-binary "@${rdf_file}" ${bg_sparql}
echo

