# ld4p-blazegraph-scripts

### General Dependencies

- Java 8
- Maven 3
- Blazegraph
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

