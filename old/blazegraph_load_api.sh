#!/bin/bash

# On a debian package installation, the original file could be found at:
#/usr/bin/loadRestAPI.sh

if [ "$1" == "" -o "$1" == "-h" -o "$1" == "--help" ]; then
    echo "Usage: $0 {file_or_directory} [{graph_namespace}]"
    exit
else
    FILE_OR_DIR=$1
fi

if [ ! -z "$2" ]; then
    NAMESPACE=$2
else
    NAMESPACE=kb
fi

[ -f "/etc/default/blazegraph" ] && source /etc/default/blazegraph
[ -z "$JETTY_PORT" ] && JETTY_PORT=9999

BG_URL="http://localhost:${JETTY_PORT}/blazegraph/dataloader"

# On a debian package installation, there is a file at
# /etc/blazegraph/RWStore.properties
# That file is almost identical to the source file in 
# BLAZEGRAPH_RELEASE_2_1_4/src/resources/deployment/nss/WEB-INF/RWStore.properties
# Other installations might put this file in:
#export NSS_DATALOAD_PROPERTIES=/usr/local/blazegraph/conf/RWStore.properties

[ -z "${NSS_PROPERTIES}" ] && NSS_PROPERTIES=/etc/blazegraph/RWStore.properties

export NSS_DATALOAD_PROPERTIES=${NSS_PROPERTIES}

#Probably some unused properties below, but copied all to be safe.
LOAD_PROP_FILE=/tmp/$$.properties

cat <<EOT > ${LOAD_PROP_FILE}
quiet=false
verbose=0
closure=false
durableQueues=true
com.bigdata.rdf.store.DataLoader.flush=false
com.bigdata.rdf.store.DataLoader.bufferCapacity=100000
com.bigdata.rdf.store.DataLoader.queueCapacity=10
com.bigdata.rdf.store.DataLoader.ignoreInvalidFiles=true
#Needed for quads
#defaultGraph=
#Namespace to load
namespace=${NAMESPACE}
#Files to load
fileOrDirs=${FILE_OR_DIR}
#Property file (if creating a new namespace)
propertyFile=${NSS_DATALOAD_PROPERTIES}
EOT


echo "Submitting to loader at: ${BG_URL}"
echo "Submitting with properties..."
cat ${LOAD_PROP_FILE}
echo

curl -X POST --data-binary @${LOAD_PROP_FILE} --header 'Content-Type:text/plain' ${BG_URL}
echo

#Let the output go to STDOUT/ERR to allow script redirection

rm -f ${LOAD_PROP_FILE}

