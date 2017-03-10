#!/bin/bash
# Configure the scripts
#
# This configuration script is designed to be used like so:
# source ./config/config.sh
#
# If any custom LD4P_* settings are required, they can be set in the
# system ENV or on the command line, like so:
# export LD4P_DATA=/ld4p_data
# export LD4P_RDF=/ld4p_rdf
# source $LD4P_ROOT/config/config.sh

# An LD4P_ROOT path must be defined by any scripts calling this configuration.
if [ "$LD4P_ROOT" == "" ]; then
    echo "ERROR: The LD4P configuration requires an LD4P_ROOT path: ${LD4P_ROOT}" 1>&2
    kill -INT $$
fi

# Paths for code, configs and logs
export LD4P_BIN="${LD4P_ROOT}/bin"
export LD4P_LIB="${LD4P_ROOT}/lib"
export LD4P_LOGS="${LD4P_ROOT}/log"
export LD4P_CONFIG="${LD4P_ROOT}/config/config.sh"
# Check paths exist, fail if they do not
[[ ! -d "$LD4P_BIN" ]] && echo "ERROR: LD4P_BIN (${LD4P_BIN}) does not exist" && kill -INT $$
[[ ! -d "$LD4P_LIB" ]] && echo "ERROR: LD4P_LIB (${LD4P_LIB}) does not exist" && kill -INT $$
[[ ! -d "$LD4P_LOGS" ]] && echo "ERROR: LD4P_LOGS (${LD4P_LOGS}) does not exist" && kill -INT $$
[[ ! -f "$LD4P_CONFIG" ]] && echo "ERROR: LD4P_CONFIGS (${LD4P_CONFIG}) does not exist" && kill -INT $$

# If the system already defines an LD4P_DATA path, it will be used.
if [ "$LD4P_DATA" == "" ]; then
    export LD4P_DATA="${LD4P_ROOT}/data"
fi
if [ ! -d "$LD4P_DATA" ]; then
    echo "ERROR: The LD4P scripts require an LD4P_DATA path: ${LD4P_DATA}" 1>&2
    kill -INT $$
fi

# If the system already defines an LD4P_RDF path, it will be used.
if [ "$LD4P_RDF" == "" ]; then
    export LD4P_RDF="${LD4P_DATA}/rdf"
fi
if [ ! -d "$LD4P_RDF" ]; then
    echo "ERROR: The LD4P scripts require an LD4P_RDF path: ${LD4P_RDF}" 1>&2
    kill -INT $$
fi

# Paths for data records
export LD4P_MARCRDF="${LD4P_RDF}/marc_rdf"

# Record archive settings:
export LD4P_ARCHIVE_ENABLED=false
export LD4P_ARCHIVE_MARCRDF="${LD4P_DATA}/marc_rdf_archive"

