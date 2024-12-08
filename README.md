# 2025-data-platform

# TODOs
1. Get infra.yaml up
2. Using a single script (deploy.sh), deploy infra, upload data and transform script, and run a transform job on an EMR cluster
3. Calculate financials of serverless vs EMR on EC2 + EMR configs
4. Figure out PaaS packaging/distribution for Data engineering teams

# Bare-minimum tech Stack
1. s3 (data lake, data engineering code, version-controlled batch configs)
2. emrs spun up/down per batch? have pricing figured out here
3. redshift for analytical queries and reporting

# Other
1. Debug steps quickly using command-runner.jar in EMR for s3 location.