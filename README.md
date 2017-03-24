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

3. Load a test rdf xml file into the 'kb' namespace of blazegraph on the remote VM:

    `cap dev deploy:run_test`

## RDF Loading

To run the RDF loader on a deployed system, such as the blazegraph-dev box:

```
cd ~/ld4p-rdf-to-blazegraph/current/
./blazegraph_load_rdf.sh -h
# read the help info and modify the example so it works on real data
```

Look at the `blazegraph_load_test.sh` script for ideas on using `blazegraph_load_rdf.sh`;
then define the input parameters and call the script, e.g.

```
bg_sparql_uri="http://localhost:9999/blazegraph/kb/sparql"
rdf_data_path=./data/rdf
log_file="./log/blazegraph_load_rdf_$(date --iso-8601).log"
./blazegraph_load_rdf.sh ${bg_sparql_uri} ${rdf_data_path} > $log_file 2>&1 &
```

The RDF loader runs in the background. To check that it's working, quickly tail the
log file or count the records processed:
```
grep -c 'Uploading' $log_file
tail -f $log_file # tailing the log consumes some IO and CPU
```
To troubleshoot the loader, check that the input parameters are correct and ensure
that the blazegraph namespace is available for loading data.

Running the loader can take some time.  It's a good idea to run it using a gnu-screen
session to leave it running and come back to it later after disconnecting.  Using gnu-screen
is fairly simple once you get to know it a little.  To start it:
```
screen -ls  # to list existing screen sessions
screen -r   # to _r_econnect to a screen session
screen      # to start a new screen session
# screen runs a bash shell in the screen terminal
# to disconnect from the screen terminal, use ALT-D
```

To find the basics on gnu-screen, google for relevant hits, such as:
https://www.linux.com/learn/taking-command-terminal-gnu-screen

