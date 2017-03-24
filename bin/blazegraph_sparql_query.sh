#!/bin/bash

usage () {
    echo "Usage: $0 {blazegraph_sparql_url} {sparql_query_file}"
    echo
    echo "e.g.:  $0 http://localhost:9999/blazegraph/namespace/kb/sparql ./example_file.sparql"
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
sparql_file=$2

curl -s -X POST -H 'Content-Type: application/sparql-query' ${bg_sparql} --data-binary "@${sparql_file}"

