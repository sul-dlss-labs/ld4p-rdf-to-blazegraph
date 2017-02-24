#!/bin/bash
# Configure the LD4P-tracer-bullet scripts
#
# This configuration script is designed to be used like so:
# source ./ld4p_configure.sh
#
# If any custom LD4P_* paths are required, they can be set in the
# system ENV or on the command line, like so:
# LD4P_SIRSI=/ld4p_data LD4P_RDF=/ld4p_rdf source /path/to/ld4p_configure.sh

export LD4P_BASEURI="http://linked-data-test.stanford.edu/library/"

# If the system already defines an LD4P_RDF path, it will be used.
# If a custom LD4P_RDF path is required, it can be set in the
# system ENV or on the command line, like so:
# LD4P_RDF=/ld4p_data source /path/to/ld4p_configure.sh
if [ "$LD4P_RDF" == "" ]; then
    export LD4P_RDF=/rdf
fi
if [ ! -d "$LD4P_RDF" ]; then
    echo "ERROR: The LD4P scripts require an LD4P_RDF path: ${LD4P_RDF}" 1>&2
    kill -INT $$
fi

# Paths for data records
export LD4P_MARCRDF="${LD4P_RDF}/MarcRDF"
# Create paths, recursively, if they don't exist
mkdir -p ${LD4P_MARCRDF} || kill -INT $$

# Paths to archive processed records
export LD4P_ARCHIVE_MARCRDF="${LD4P_DATA}/Archive/MarcRDF"
# Create paths, recursively, if they don't exist
mkdir -p ${LD4P_ARCHIVE_MARCRDF} || kill -INT $$

# Record processing options (toggles):
# Toggle to archive processed records
export LD4P_ARCHIVE_ENABLED=true
# Toggle to replace existing MARC-RDF files; note that when MARC-XML files
# have a timestamp later than a MARC-RDF file, the RDF file will be replaced.
export LD4P_MARCRDF_REPLACE=false
