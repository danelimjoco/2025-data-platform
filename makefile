# Variables
AWS_REGION = us-east-1
STACK_NAME_S3 = "s3-stack"
STACK_NAME_EMR = "emr-stack"
TEMPLATE_FILE_S3 = "cloudformation/s3.yaml"
TEMPLATE_FILE_EMR = "cloudformation/emr.yaml"
S3_BUCKET_PATH = s3://data-platform-bucket-474668389058/data/raw/
PYTHON = python3
VENV_DIR = venv
REQUIREMENTS = requirements/aws_deployment.txt
RAW_DATA_PATH = data/customers.parquet

# Help message
help:
	@echo "Usage:"
	@echo "  make install            - Create venv and install dependencies."
	@echo "  make clean              - Remove the virtual environment."
	@echo "  make deploy             - Deploy full infrastructure (S3 and EMR)."
	@echo "  make teardown           - Tear down all infrastructure."
	@echo "  make deploy-s3          - Deploy S3 stack."
	@echo "  make deploy-emr         - Deploy EMR stack."
	@echo "  make teardown-s3        - Tear down S3 stack."
	@echo "  make teardown-emr       - Tear down EMR stack."
	@echo "  make upload-data        - Upload raw data to S3."
	@echo "  make run-batch          - Run a test batch on EMR."

# Targets
.PHONY: venv install activate clean deactivate install-requirements update-package-versions help empty-s3 teardown deploy spin-up spin-down generate-data upload-data upload-transform run-batch deploy-s3 deploy-emr teardown-s3 teardown-emr

# Create virtual environment
venv:
	@echo "Creating virtual environment..."
	$(PYTHON) -m venv $(VENV_DIR)
	@echo "Virtual environment created in $(VENV_DIR)."

# Install requirements and update package versions
install: venv update-package-versions
	@echo "Installing requirements from $(REQUIREMENTS)..."
	$(VENV_DIR)/bin/pip install --upgrade pip
	$(VENV_DIR)/bin/pip install -r $(REQUIREMENTS)
	@echo "Requirements installed."

# Activating virtual environment (prints activation command)
activate:
	@echo "To activate the virtual environment, run:"
	@echo "  source $(VENV_DIR)/bin/activate"

# Clean up virtual environment
clean:
	@echo "Removing virtual environment..."
	rm -rf $(VENV_DIR)
	@echo "Virtual environment removed."

# Deactivate virtual environment (informational only)
deactivate:
	@echo "To deactivate the virtual environment, run:"
	@echo "  deactivate"

# Update package versions
update-package-versions:
	@echo "Updating package versions..."
	uv pip compile --output-file=$(REQUIREMENTS) requirements/aws_deployment.in --pre
	@echo "Package versions updated."

# Deploy full infrastructure (S3 and EMR)
deploy: deploy-s3 deploy-emr
	@echo "Deployment complete."

# Deploy S3 stack
deploy-s3:
	@echo "Deploying S3 stack..."
	aws cloudformation deploy --template-file $(TEMPLATE_FILE_S3) --stack-name $(STACK_NAME_S3) --capabilities CAPABILITY_IAM
	@echo "S3 deployment complete."

# Deploy EMR stack (depends on S3 deployment)
deploy-emr: deploy-s3
	@echo "Deploying EMR stack..."
	aws cloudformation deploy --template-file $(TEMPLATE_FILE_EMR) --stack-name $(STACK_NAME_EMR) --capabilities CAPABILITY_IAM
	@echo "EMR deployment complete."

# Empty S3 bucket
empty-s3:
	@echo "Emptying S3 bucket..."
	python3 scripts/empty-s3.py

# Teardown full infrastructure (S3 and EMR)
teardown: empty-s3 teardown-s3 teardown-emr
	@echo "Teardown complete."

# Teardown S3 stack
teardown-s3:
	@echo "Tearing down S3 stack..."
	aws cloudformation delete-stack --stack-name $(STACK_NAME_S3) --region $(AWS_REGION)
	@echo "S3 teardown complete."

# Teardown EMR stack
teardown-emr:
	@echo "Tearing down EMR stack..."
	aws cloudformation delete-stack --stack-name $(STACK_NAME_EMR) --region $(AWS_REGION)
	@echo "EMR teardown complete."

# Generate and upload all prerequisites to s3
upload-all: generate-data upload-data upload-transform
	@echo "Prerequisites complete."

# Generate raw data
generate-data:
	@echo "Generating raw data..."
	@python ./scripts/generate_data.py --output $(RAW_DATA_PATH)
	@echo "Raw data generated at $(RAW_DATA_PATH)."

# Upload raw data to S3
upload-data: generate-data
	@echo "Uploading raw data to S3..."
	aws s3 cp $(RAW_DATA_PATH) $(S3_BUCKET_PATH)
	@echo "Upload complete."

# Upload transformation script to S3
upload-transform:
	@echo "Uploading transform script to S3..."
	aws s3 cp transform/transform.py s3://data-platform-bucket-474668389058/scripts/transform.py

# Run a test batch job on EMR
run-batch:
	@echo "Running batch job on EMR..."
	aws emr add-steps --cluster-id j-1EJGGPATMQ1I5 --steps Type=Spark,Name="Spark Batch Transformation",ActionOnFailure=CONTINUE,Args='["--deploy-mode", "cluster", "--class", "org.apache.spark.examples.SparkPi", "s3://data-platform-bucket-474668389058/scripts/transform.py"]'
	@echo "Batch job submitted."
