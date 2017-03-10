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
