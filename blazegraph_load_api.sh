#!/bin/bash

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

if [ -f "/etc/default/blazegraph" ] ; then
    . "/etc/default/blazegraph" 
else
    JETTY_PORT=9999
fi


# TODO: Find the right file to use here, possibly include it in this repo?
#
# On a debian package installation, there is a file at
# /etc/blazegraph/RWStore.properties
# That file is almost identical to the source file in 
# BLAZEGRAPH_RELEASE_2_1_4/src/resources/deployment/nss/WEB-INF/RWStore.properties
# Other installations might put this file in:
#export NSS_DATALOAD_PROPERTIES=/usr/local/blazegraph/conf/RWStore.properties
export NSS_DATALOAD_PROPERTIES=/etc/blazegraph/RWStore.properties

#Probably some unused properties below, but copied all to be safe.
LOAD_PROP_FILE=/tmp/$$.properties

cat <<EOT >> $LOAD_PROP_FILE
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
namespace=$NAMESPACE

#Files to load
fileOrDirs=$FILE_OR_DIR

#Property file (if creating a new namespace)
propertyFile=$NSS_DATALOAD_PROPERTIES
EOT

echo "Loading with properties..."
cat $LOAD_PROP_FILE

curl -X POST --data-binary @${LOAD_PROP_FILE} --header 'Content-Type:text/plain' http://localhost:${JETTY_PORT}/blazegraph/dataloader

#Let the output go to STDOUT/ERR to allow script redirection

rm -f $LOAD_PROP_FILE

