# To use this file:
# source ./bibframe2_sparql.sh
# sparql_query http://localhost:9999/blazegraph/namespace/ld4p/sparql "$BF2_WORKS"

BF2_PREFIXES="/tmp/bibframe2_prefixes.sparql"
cat << EOF > $BF2_PREFIXES
PREFIX bf: <http://id.loc.gov/ontologies/bibframe/>
PREFIX mads: <http://www.loc.gov/mads/rdf/v1#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
EOF

export BF2_AGENTS='SELECT ?agent WHERE { ?agent a bf:Agent . }'

export BF2_INSTANCES='SELECT ?instance WHERE { ?instance a bf:Instance . }'

export BF2_WORKS='SELECT ?work WHERE { ?work a bf:Work . }'

sparql_query () {
    bg_sparql=$1
    query_file="/tmp/sparql_query_$$.sparql"
    cat $BF2_PREFIXES > $query_file
    echo "$2" >> $query_file
    curl -s -X POST \
      -H 'Content-Type: application/sparql-query' \
      ${bg_sparql} --data-binary "@${query_file}"
    rm "$query_file"
}

