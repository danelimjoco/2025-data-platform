STACK_NAME="data-platform-stack"
TEMPLATE_FILE="cloudformation/infra.yaml"

# Deploy  infra
aws cloudformation deploy --template-file $TEMPLATE_FILE --stack-name $STACK_NAME --capabilities CAPABILITY_IAM

# # Put raw data onto s3 bucket
aws s3 cp data/customers.parquet s3://data-platform-bucket-474668389058/data/raw/customers.parquet

# Put transform script onto s3 bucket
aws s3 cp transform/transform.py s3://data-platform-bucket-474668389058/scripts/transform.py

# Submit spark job to EMR cluster
# aws emr add-steps \
#     --cluster-id j-2VNZC7Y4FJ3ZG \
#     --steps Type=Spark,Name="Spark Batch Transformation",ActionOnFailure=CONTINUE,Args="--deploy-mode cluster --class org.apache.spark.examples.SparkPi s3://data-platform-bucket-474668389058/scripts/transform.py"
	
# Destroy emr cluster