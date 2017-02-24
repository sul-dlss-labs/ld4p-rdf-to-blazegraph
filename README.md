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

2. Deploy code to remote VM:

    `cap dev deploy`

3. Load a test rdf xml file into the 'test' namespace of blazegraph on the remote VM:

    `cap dev deploy:run_test`
