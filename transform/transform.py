from pyspark.sql import SparkSession
from pyspark.sql.functions import col

# Initialize Spark session
spark = SparkSession.builder.appName("BatchTransform").getOrCreate()

# Input and output S3 paths
input_path = "s3://data-platform-bucket-474668389058/data/raw/customers.parquet"
output_path = "s3://data-platform-bucket-474668389058/data/conformed/"

# Read the raw data
df = spark.read.parquet(input_path)

# Simple transformation: Add a new column 'age_group'
df_transformed = df.withColumn(
    "age_group", 
    when(col("age") < 30, "Young")
    .when((col("age") >= 30) & (col("age") < 50), "Middle-aged")
    .otherwise("Senior")
)

# Write the transformed data back to S3 in Parquet format
df_transformed.write.parquet(output_path)

# Stop the Spark session
spark.stop()
