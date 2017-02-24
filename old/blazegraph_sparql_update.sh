#!/bin/bash

if [ -f "/etc/default/blazegraph" ] ; then
    . "/etc/default/blazegraph"
else
    JETTY_PORT=9999
fi

BG_URL="http://localhost:${JETTY_PORT}/blazegraph"
NAMESPACE=kb

usage () {
    echo "Usage: $0 {blazegraph_url} {graph_namespace} {rdfxml_file}"
    echo
    echo "e.g.:  $0  ${BG_URL} ${NAMESPACE} ./example_file.rdf"
    echo
    exit
}

if [ -z "$1" -a -z "$2" -a -z "$3" ]; then
    usage
fi
if [ "$1" == "-h" -o "$1" == "--help" ]; then
    usage
fi

[[ ! -z "$1" ]] && BG_URL=$1 || usage
[[ ! -z "$2" ]] && NAMESPACE=$2 || usage
[[ ! -z "$3" ]] && RDF_FILE=$3 || usage

BG_SPARQL="${BG_URL}/namespace/${NAMESPACE}/sparql";

log_stamp=$(date --iso-8601=sec)
echo "${log_stamp}  Uploading ${RDF_FILE} into ${BG_SPARQL}"

curl -s -X POST -H 'Content-Type:application/rdf+xml' --data-binary "@${RDF_FILE}" ${BG_SPARQL}
echo

#Let the output go to STDOUT/ERR to allow script redirection

# TODO: also consider alternative INSERT DATA operation:
## Use a SPARQL update file to insert into graph NAMESPACE
#DISABLE ENTAILMENTS;
#INSERT DATA { }
#CREATE ENTAILMENTS; # create new entailments using the database-at-once closure.
#ENABLE ENTAILMENTS; # reenable truth maintenance.

