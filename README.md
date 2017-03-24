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

2. Deploy custom configuration files

Each deployment system can have settings for data paths and blazegraph parameters.
At DLSS, these files are usually in the shared_config repository; for example, see
https://github.com/sul-dlss/shared_configs/tree/ld4p-rdf-to-blazegraph-dev

Unless dev-ops have already setup these files, they can be deployed as follows:

    cap dev deploy:check
    ssh {remote system}
    git clone https://github.com/sul-dlss/shared_configs.git \
        --branch ld4p-rdf-to-blazegraph-dev --single-branch ld4p-rdf-to-blazegraph-configs

Once they are on the deployment system, they can be updated and copied to the deployed
application, as follows:

    ssh {remote system}
    cd ld4p-rdf-to-blazegraph-configs
    git pull
    rsync -av ./config ~/ld4p-rdf-to-blazegraph/shared/

3. Deploy code to remote system:


    cap dev deploy:check
    cap dev deploy

4. Load a test rdf xml file into the 'kb' namespace of blazegraph on the remote VM:

    `cap dev deploy:run_test`

## Conversions

To run the conversion on a deployed system, such as the blazegraph-dev box:

```
cd ~/ld4p-rdf-to-blazegraph/current/
log_file="./log/blazegraph_load_rdf_$(date --iso-8601).log"
./blazegraph_load_rdf.sh > $log_file 2>&1 &
```

The conversion runs in the background. To check that it's working, quickly tail the
log file or count the records processed:
```
grep -c 'Uploading' $log_file
tail -f $log_file # tailing the log consumes some IO and CPU
```
To troubleshoot the conversion, check that the configuration data from the shared_configs is
correct in `~/ld4p-rdf-to-blazegraph-config/config/` and that these files are up to date.
Also check that those files have been copied into `~/ld4p-rdf-to-blazegraph/shared/config/`.

Running the conversions can take some time.  It's a good idea to run them using a gnu-screen
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

