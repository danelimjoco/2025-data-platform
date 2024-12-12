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
1. Debug steps quickly using command-runner.jar in EMR for s3 location

# Glue/Athena  workflow
1. In Glue console, can set up a crawler to infer the schema of parquet in s3. The glue database is just a metadata db, not a data db. There is no duplication of data when crawlers run.
2. Athena then uses the metadata to query s3 directly. So glue is good for when schemas change, and so that you don't have to explicitly specify schemas every time you want to query.

Example working Athena queries:
CREATE EXTERNAL TABLE my_parquet_table ( customer_id bigint, name STRING, email STRING, age bigint
) STORED AS PARQUET
LOCATION 's3://data-platform-bucket-474668389058/data/raw/'

SELECT * FROM "parquet_db"."my_parquet_table" limit 10;

# Requirements
1. Add pip to PATH:
export PATH="/Users/danelimjoco/Library/Python/3.9/bin:$PATH"
2. Install uv
brew install uv

# Running a batch


