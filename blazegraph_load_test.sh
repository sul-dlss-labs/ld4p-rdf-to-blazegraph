#!/bin/bash

# ---
# Blazegraph settings input or use defaults for test

SPARQL_URI=$1
if [ -z "$SPARQL_URI" ]; then
    # DLSS blazegraph-dev runs as a tomcat container on port 8080
    SPARQL_URI="http://localhost:8080/blazegraph/namespace/test/sparql";
fi

# ---
# Test data
rdf_file="data/test/rdfxml/one_record.rdf"
rdf_uri="http://ld4p-test.stanford.edu/1629059#Work"


# ---
# Load data

echo "Blazegraph loading MARC-RDF file ${rdf_file} into graph '${SPARQL_URI}'"
curl -s -X POST -H 'Content-Type:application/rdf+xml' --data-binary "@${rdf_file}" ${SPARQL_URI}
echo

success=$?
if [ "${success}" == "0" ]; then
  echo "SUCCESS: load data completed"
else
  echo "FAILURE: did not load data"
  exit 1
fi

# ---
# Issue a SPARQL query to confirm the data is loaded

query='SELECT ?s WHERE { ?s a <http://id.loc.gov/ontologies/bibframe/Work> . }'
curl -s -X POST -H 'Content-Type: application/sparql-query' ${SPARQL_URI} \
  --data-binary "${query}" | grep -q ${rdf_uri}

success=$?
if [ "${success}" == "0" ]; then
  echo "SUCCESS: confirmed the ${rdf_uri} is a bf:Work in the triple store"
else
  echo "FAILURE: did not find ${rdf_uri} as a bf:Work in the triple store"
  exit 1
fi

# ---
# Delete the loaded data so this test is idempotent

query="DESCRIBE <${rdf_uri}>"
curl -s -X DELETE -H 'Content-Type: application/sparql-query' ${SPARQL_URI} \
  --data "${query}" > /dev/null

success=$?
if [ "${success}" == "0" ]; then
  echo "SUCCESS: cleanup of the loaded data"
else
  echo "FAILURE: did not cleanup the loaded data"
  exit 1
fi


