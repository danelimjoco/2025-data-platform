# 2025-data-platform

## Bare-minimum tech Stack
1. s3 (data lake, data engineering code, version-controlled batch configs)
2. emrs spun up/down per batch? have pricing figured out here
3. redshift for analytical queries and reporting

## Other
1. Debug steps quickly using command-runner.jar in EMR for s3 location

## Glue/Athena  workflow
1. In Glue console, can set up a crawler to infer the schema of parquet in s3. The glue database is just a metadata db, not a data db. There is no duplication of data when crawlers run.
2. Athena then uses the metadata to query s3 directly. So glue is good for when schemas change, and so that you don't have to explicitly specify schemas every time you want to query.

Example working Athena queries:
CREATE EXTERNAL TABLE my_parquet_table ( customer_id bigint, name STRING, email STRING, age bigint
) STORED AS PARQUET
LOCATION 's3://data-platform-bucket-474668389058/data/raw/'

SELECT * FROM "parquet_db"."my_parquet_table" limit 10;

## Requirements
1. Add pip to PATH:
export PATH="/Users/danelimjoco/Library/Python/3.9/bin:$PATH"
2. Install uv
brew install uv

## TODOs
1. Pricing - Calculate financials of EMR serverless vs EMR on EC2 + EMR configs
3. Generate dummy data of ALL potential data types.
3. Be able to handle the same data types as in work 
4. Have some type of batch config
5. Airflow Scheduling
6. UI
7. Build Pipelines - Transform, Offline, EMR spec, Spark spec, Masking, Promote
8. Discover Data - Data dictionary, Qlik User Onboarding
9. Monitor Batches - Batches Dashboard, Audit Dashboard
10. Data Operations - S3 Source Upload? data/idea/source/
11. Understand multi-tenancy: 

## Done
1. s3.yaml and emr.yaml work, with makefile commands for generating data, data upload, and triggering a batch (with manual copy of cluster id)
2. Figure out PaaS packaging/distribution for Data engineering teams
-SaaS Subscription-based (do this): customers interact with web UI to configure their environment, then platform handles backend. The UI can be used to do minimal infra setup things, but mostly be like ideasphere UI
-Cloud Marketplace (do this): List platform on AWS Marketplace, Azure Marketplace, or Google CLoud Marketplace. It's easier for customers to deploy platform directly into accounts this way. Better visibility/credibility, and cloud provider haandles billing for me
-Private Repo or Github (harder)
-Automated Onboarding and Setup via CLI/API (harder)
3. What UI will have to offer for the SaaS route:
-Account Creation: Users should be able to sign up with their company details and register an account. You should be able to support creating a new AWS account, or allowing them to use their existing AWS account (need to check what's on it, and see if your platform is compatible if there are existing resources, or just mandate a clean AWS account...)
-User Auth for logging into the UI (AWS Cognito)
-Account Settings
Platform Onboarding:
-Wizard-style setup for platform onboarding (Provider selection, S3 bucket setup, IAM roles)
-Infra template customization (cluster sizes, storage options, security, VPC configuration)
-generate API keys
Environment Management (Customers will need dev, UAT, prod):
-Allow customers to spin up new environments
-Monitor resources
-Manage data pipelines
-Upload raw data
Need to Integrate Billing:
-Stripe
-AWS Marketplace
-Basic or Premium
4. Multi-tenancy Considerations:
-You need to Use AWS Organizations to manage multiple AWS accounts. 
-Implement least-privilege IAM policies per customer





