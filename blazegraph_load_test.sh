#!/bin/bash

# To avoid conflicts with real data, this test script cannot source
# the $LD4P_ROOT/config/config.sh file that is linked to a
# shared_configs file on a deployment system.

SCRIPT_PATH=$( cd $(dirname $0) && pwd -P )
export LD4P_ROOT=$( cd "${SCRIPT_PATH}" && pwd -P )

# Test data
rdf_file="${LD4P_ROOT}/data/test/one_record.rdf"
rdf_uri="http://ld4p-test.stanford.edu/1629059#Work"

# Blazegraph settings
source "${LD4P_ROOT}/config/config_blazegraph.sh"
export BG_GRAPH='kb'
export BG_SPARQL="${BG_URL}/namespace/${BG_GRAPH}/sparql";

# ---
# Load data

echo "Blazegraph loading MARC-RDF file ${rdf_file} into graph '${BG_GRAPH}'"
${LD4P_ROOT}/bin/blazegraph_sparql_update.sh ${BG_SPARQL} ${rdf_file}

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
