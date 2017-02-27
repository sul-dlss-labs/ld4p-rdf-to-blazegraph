#!/bin/bash
#
# Requires one input parameter - the path to an rdfxml file.
#
# Load rdfxml file indicated in param to a Blazegraph instance, using sparql endpoint


BASEURI="http://ld4p-test.stanford.edu/"

# vars above this line may need to change to process other data
#------------------------------------------------

BG_URL="http://localhost/blazegraph/"
TEST_NAMESPACE=test
BG_SPARQL="${BG_URL}/namespace/${TEST_NAMESPACE}/sparql";

RDF_FILE="test_data/86169543_rdf.xml"

log_stamp=$(date --iso-8601=sec)
echo "${log_stamp}  Uploading ${RDF_FILE} into ${BG_SPARQL}"

curl -s -X POST -H 'Content-Type:application/rdf+xml' --data-binary "@${RDF_FILE}" ${BG_SPARQL}
echo

#Let the output go to STDOUT/ERR to allow script redirection
