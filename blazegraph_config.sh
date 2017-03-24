#!/bin/bash
# Default configuration for the LD4P blazegraph scripts
#
# This configuration script is designed to be called like so:
# source ./config/config_blazegraph.sh

[ -f /etc/default/blazegraph ] && source /etc/default/blazegraph
[[ -z "$JETTY_PORT" && -d /usr/share/tomcat/webapps/blazegraph ]] && export JETTY_PORT=80
[ -z "$JETTY_PORT" ] && JETTY_PORT=9999

export BG_URL="http://localhost:${JETTY_PORT}/blazegraph"

# 'kb' is a robust default
export BG_GRAPH='kb'

export BG_SPARQL="${BG_URL}/namespace/${BG_GRAPH}/sparql";
