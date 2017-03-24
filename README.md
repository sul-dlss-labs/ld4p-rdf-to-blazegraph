[![Dependency Status](https://gemnasium.com/badges/github.com/sul-dlss/ld4p-rdf-to-blazegraph.svg)](https://gemnasium.com/github.com/sul-dlss/ld4p-rdf-to-blazegraph)

# ld4p-rdf-to-blazegraph
Load rdf files into a Blazegraph (https://www.blazegraph.com/) instance

### Dependencies

- Blazegraph instance

## Deployment

Capistrano is used for deployment.

1. On your laptop, run

    `bundle`

  to install the Ruby capistrano gems and other dependencies for deployment.

2. Deploy code to remote system:

    cap dev deploy:check
    cap dev deploy

3. Load a test rdf xml file into the 'test' namespace of blazegraph on the remote VM:

    `cap dev deploy:run_test`


## Utility to load a directory of RDF files

The `./blazegraph_load_rdf.sh` uses `find` to iterate on all the files in a directory.

```
$ ./blazegraph_load_rdf.sh -h
Usage:
./blazegraph_load_rdf.sh {blazegraph_sparql_uri} {rdf_data_directory} > log/blazegraph_load.log 2>&1

Example:
./blazegraph_load_rdf.sh http://localhost:9999/blazegraph/namespace/kb/sparql ./data/test
```


## Utility to load a single RDF file

The `./bin/blazegraph_sparql_update.sh` script works for a single RDF file.  This script
is called by the `./blazegraph_load_rdf.sh` as it iterates on all the files in a directory.

```
$ ./bin/blazegraph_sparql_update.sh -h
Usage: ./bin/blazegraph_sparql_update.sh {blazegraph_sparql_url} {rdfxml_file}

e.g.:  ./bin/blazegraph_sparql_update.sh http://localhost:9999/blazegraph/namespace/kb/sparql ./data/test/one_record.rdf

```


## RDF Loading on Deployment Systems


To run the RDF loader on a deployed system, such as the blazegraph-dev box:

```
cd ~/ld4p-rdf-to-blazegraph/current/
./blazegraph_load_rdf.sh -h
```

Read the help info and modify the example so it works for real data.
Ensure the blazegraph namespace in the SPARQL endpoint is available.

For example, define some input parameters and call the script, e.g.

```
bg_sparql_uri="http://localhost:9999/blazegraph/namespace/kb/sparql"
rdf_data_path=./data/test
log_file="./log/blazegraph_load_rdf_$(date --iso-8601).log"
./blazegraph_load_rdf.sh ${bg_sparql_uri} ${rdf_data_path} > $log_file 2>&1 &
```


#### Monitoring the log file

The RDF loader runs in the background. To check that it's working, tail the
log file or count the records processed:
```
grep -c 'Uploading' $log_file
tail -f $log_file # tailing the log consumes some IO and CPU
```

#### Using GNU-Screen

Running the loader can take some time.  It's a good idea to run it using a gnu-screen
session to leave it running and come back to it later after disconnecting.  Using gnu-screen
is very useful once you get to know it a little.  To start it:
```
screen -ls  # to list existing screen sessions
screen -r   # to reconnect to a screen session
screen      # to start a new screen session
# screen runs a bash shell in the screen terminal
# to disconnect from the screen terminal, use ALT-D
```

To find the basics on gnu-screen, google for relevant hits, such as:
https://www.linux.com/learn/taking-command-terminal-gnu-screen


