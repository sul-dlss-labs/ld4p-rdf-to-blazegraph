#!/bin/bash
# Configure the LD4P-tracer-bullet scripts
#
# This configuration script is designed to be used like so:
# source ./ld4p_blazegraph_configure.sh
#
# If any custom LD4P_* paths are required, they can be set in the
# system ENV or on the command line, like so:
# LD4P_RDF=/ld4p_rdf source /path/to/ld4p_blazegraph_configure.sh

export LD4P_BASEURI="http://linked-data-test.stanford.edu/library/"

if [ "$LD4P_BG" == "" ]; then
    # Defaults to the Blazegraph-DEV box
    export LD4P_BG='http://sul-ld4p-blazegraph-dev.stanford.edu/blazegraph'
fi

if [ "$LD4P_GRAPH" == "" ]; then
    export LD4P_GRAPH='ld4p'
fi

# If the system already defines an LD4P_APP path, it will be used.
# If a custom LD4P_APP path is required, it can be set in the
# system ENV or on the command line, like so:
# LD4P_APP=/ld4p_data source /path/to/ld4p_blazegraph_configure.sh
if [ "$LD4P_APP" == "" ]; then
    SCRIPT_PATH=$(pwd)
    export LD4P_APP=$SCRIPT_PATH
fi
if [ ! -d "$LD4P_APP" ]; then
    echo "ERROR: The LD4P scripts require an LD4P_APP path: ${LD4P_APP}" 1>&2
    kill -INT $$
fi

# If the system already defines an LD4P_RDF path, it will be used.
# If a custom LD4P_RDF path is required, it can be set in the
# system ENV or on the command line, like so:
# LD4P_RDF=/ld4p_data source /path/to/ld4p_blazegraph_configure.sh
if [ "$LD4P_RDF" == "" ]; then
    export LD4P_RDF=/rdf
fi
if [ ! -d "$LD4P_RDF" ]; then
    echo "ERROR: The LD4P scripts require an LD4P_RDF path: ${LD4P_RDF}" 1>&2
    kill -INT $$
fi

# Paths for code, configs and logs
export LD4P_BIN="${LD4P_APP}/bin"
export LD4P_LIB="${LD4P_APP}/lib"
export LD4P_LOGS="${LD4P_APP}/log"
export LD4P_CONFIGS="${LD4P_APP}/configs"
# Create paths, recursively, if they don't exist
#mkdir -p ${LD4P_BIN} || kill -INT $$
#mkdir -p ${LD4P_LIB} || kill -INT $$
#mkdir -p ${LD4P_LOGS} || kill -INT $$
#mkdir -p ${LD4P_CONFIGS} || kill -INT $$

# Paths for data records
export LD4P_MARCRDF="${LD4P_RDF}/MarcRDF"
# Create paths, recursively, if they don't exist
#mkdir -p ${LD4P_MARCRDF} || kill -INT $$

# Paths to archive processed records
export LD4P_ARCHIVE_MARCRDF="${LD4P_RDF}/Archive/MarcRDF"
# Create paths, recursively, if they don't exist
#mkdir -p ${LD4P_ARCHIVE_MARCRDF} || kill -INT $$

# Record processing options (toggles):
# Toggle to archive processed records
export LD4P_ARCHIVE_ENABLED=true

