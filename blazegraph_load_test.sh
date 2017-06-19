#!/bin/bash

# ---
# Blazegraph settings input or use defaults for test

SPARQL_URI=$1
if [ -z "$SPARQL_URI" ]; then
    # DLSS blazegraph-dev runs as a tomcat container on port 8080
    SPARQL_URI="http://localhost:8080/blazegraph/namespace/test/sparql";
fi

# ---
# Create or recreate the test namespace

# parse the namespace from the SPARQL_URI
export bg_url=$(echo $SPARQL_URI | sed -e 's#\(.*\)/namespace.*#\1#')
export bg_namespace=$(echo $SPARQL_URI | sed -e 's#.*namespace/\(.*\)/sparql#\1#')

# create the namespace XML properties
export ns_tmp="/tmp/ld4p_test_$$"
export ns_xml="${ns_tmp}_namespace_properties.xml"
export ns_response="${ns_tmp}_namespace_response.txt"

cleanup_temporary_files () {
  rm /tmp/ld4p_test_*
}

cat > $ns_xml <<_EOF_
<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<!DOCTYPE properties SYSTEM "http://java.sun.com/dtd/properties.dtd">
<properties>
<entry key="com.bigdata.rdf.sail.namespace">${bg_namespace}</entry>
<entry key="com.bigdata.rdf.store.AbstractTripleStore.quads">false</entry>
<entry key="com.bigdata.rdf.store.AbstractTripleStore.justify">false</entry>
<entry key="com.bigdata.rdf.store.AbstractTripleStore.statementIdentifiers">false</entry>
<entry key="com.bigdata.rdf.store.AbstractTripleStore.geoSpatial">false</entry>
<entry key="com.bigdata.rdf.store.AbstractTripleStore.axiomsClass">com.bigdata.rdf.axioms.NoAxioms</entry>
<entry key="com.bigdata.rdf.sail.truthMaintenance">false</entry>
<entry key="com.bigdata.rdf.sail.isolatableIndices">false</entry>
<entry key="com.bigdata.rdf.sail.textIndex">false</entry>
</properties>
_EOF_

create_namespace () {
  curl -s -X POST -H 'Content-type: application/xml' --data @${ns_xml} ${bg_url}/namespace | tee $ns_response
  echo
  if grep -q "CREATED: $bg_namespace" $ns_response; then
    return 0
  else
    echo "FAILED to create test namespace"
    return 1
  fi
}

delete_namespace () {
  curl -s -X DELETE ${bg_url}/namespace/${bg_namespace} | tee $ns_response
  echo
  if grep -q "DELETED: $bg_namespace" $ns_response; then
    return 0
  else
    echo "FAILED to delete test namespace"
    return 1
  fi
}

reset_namespace () {
  delete_namespace && create_namespace
}

# create or reset namespace
create_namespace || reset_namespace
cleanup_temporary_files


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

# ---
# Cleanup namespace

delete_namespace
cleanup_temporary_files

