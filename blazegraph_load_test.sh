#!/bin/bash

# To avoid conflicts with real data, this test script cannot source
# the $SCRIPT_PATH/config/config.sh file that is linked to a
# shared_configs file on a deployment system.

export SCRIPT_PATH=$( cd $(dirname $0) && pwd -P )

# Blazegraph settings
source "${SCRIPT_PATH}/blazegraph_config.sh"

# Test data
rdf_path="${SCRIPT_PATH}/data/test"
rdf_uri="http://ld4p-test.stanford.edu/1629059#Work"

# ---
# Load data

${SCRIPT_PATH}/blazegraph_load_rdf.sh ${BG_SPARQL} ${rdf_path}

# ---
# Issue a SPARQL query to confirm the data is loaded

query='SELECT ?s WHERE { ?s a <http://id.loc.gov/ontologies/bibframe/Work> . }'
curl -s -X POST -H 'Content-Type: application/sparql-query' ${BG_SPARQL} \
  --data-binary "${query}" | grep ${rdf_uri}

success=$?
if [ "${success}" == "0" ]; then
  echo "SUCCESS: confirmed the ${rdf_uri} is a bf:Work in the triple store"
else
  echo "FAILURE: did not find ${rdf_uri} as a bf:Work in the triple store"
fi

# ---
# Delete the loaded data so this test is idempotent

query="DESCRIBE <${rdf_uri}>"
curl -s -X DELETE -H 'Content-Type: application/sparql-query' ${BG_SPARQL} \
  --data "${query}" > /dev/null

success=$?
if [ "${success}" == "0" ]; then
  echo "SUCCESS: cleanup of the loaded data"
else
  echo "FAILURE: did not cleanup the loaded data"
fi
