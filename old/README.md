[![Dependency Status](https://gemnasium.com/badges/github.com/sul-dlss/ld4p-rdf-to-blazegraph.svg)](https://gemnasium.com/github.com/sul-dlss/ld4p-rdf-to-blazegraph)

# ld4p-rdf-to-blazegraph
Load rdf files into a Blazegraph (https://www.blazegraph.com/) instance

## Dependencies

- Blazegraph instance
- File system configuration details
    - See how `ld4p_blazegraph_configure.sh` sets various input/output paths

## Getting Started: Installation and Configuration

```sh
git clone https://github.com/sul-dlss/ld4p-blazegraph-scripts.git
cd ld4p-blazegraph-scripts
```

Review and modify `ld4p_blazegraph_configure.sh` as required to configure
system paths for data files (see details in that script).

```
cp ld4p_blazegraph_configure.sh custom_configure.sh
# edit custom_configure.sh
source ./custom_configure.sh
```

#### Configuration

The details are in `ld4p_blazegraph_configure.sh`; that file is more
authoritative than this README.  In brief, there is one RDF data path that must
be set and the rest of the configuration can be done automatically.

For example, the effective defaults are:
    ```
    export LD4P_RDF=/rdf
    source ./ld4p_blazegraph_configure.sh
    ```

#### Loading RDF to Blazegraph

Follow the getting started notes above and then it should be possible to load
the RDF data into blazegraph on a development laptop.  To work on custom
configurations and shell scripts, prefix the script file with `laptop` and git
will ignore them.

## Deployment

Capistrano is used for deployment.

1. On your laptop, run

    `bundle`

  to install the Ruby capistrano gems and other dependencies for deployment.

2. Deploy code to remote VM:

    `cap dev deploy`

3. Load a test file into blazegraph to ensure it works on remote VM:

    `cap dev deploy:run_test`
