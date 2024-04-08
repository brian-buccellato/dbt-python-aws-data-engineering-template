# dbt-python-data-eng-project:  ELT Reference

### What's in this project?
This project is a starter project which can be used for small to medium sized data engineering projects.  It is intended to be used as a template repo for new projects.  It includes the following:
- [terraform](./terraform/README.md): this is used to create the infrastructure for the project.
- [python-ingestors](./python-ingestors/README.md): this is used to ingest data from various sources.
- [dbt-transformtions](./dbt-transformations/README.md): this is used to transform the data using dbt.

There is also an example pipeline which shows how one might use the resources to create data pipelines, but it is only intended to an example.  The project can be molded to fit the style and preference of the user.

### What this project builds
This project creates:
- its own VPC for all resources.
- all necessary roles and policies to run the project
- a Redshift cluster in a private subnet
- a bastion host in a public subnet to access the redshift cluster locally
- an S3 bucket to store data
- an ECS cluster
- an ECR repository for two services: python ingestors and dbt transformations
- a task definition for each service
- secretsmanager secrets for the python ingestors

### Prerequisites
- Terraform installation
- AWS Account with admin access
- Docker

### How to use this project
1. Navigate to the project's github repository and click the "Use this template" button.  This will create a new repository with the same structure as this one.

1. Set up a user to run the terraform code.  This is often an admin because this is easier to manage as projects grow, but it can also be a least privilege user.

#### Terraform Setup:

1. In a terminal session where you want to run the terraform code, export the `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` environment variables from the user you created in the previous steps.

1. Set up the S3 bucket for state store.  This is a manual step because the bucket needs to be created before the terraform code is run.  Create the bucket with all public access blocked and bucket versioning enabled.

1. Set up the DynamoDB table for state locking.  Create a dynamo table.  The table should have a primary key of LockID.

1. Add the bucket name, bucket key, and dynamo table name to the terraform backend configuration in the terraform/providers.tf file.

1. Configure the variables in the terraform/terraform.tfvars file.  The project name should be descriptive and unique to the project.  The IPs to whitelist should be the IP addresses of users who will need to access redshift locally (typically the data engineers).  The tfvars file can also be used to override any of the defaults in terraform/variables.tf.

1. Run `terraform init` to initialize the terraform backend.

1. Run `terraform plan` to see what resources will be created.

1. Run `terraform apply` to create the resources.

1. The first run will download the .pem file for the bastion host.  This file is used to ssh into the bastion host to access the redshift cluster.  The file is saved in the terraform directory.

1. Once all resources are created, open a new terminal session and navigate to the terraform directory.
    ```ssh-add <your-key-pair>.pem
    ssh -A ec2-user@<your-bastion-ip> -L 5439:<your-redshift-endpoint>:5439
    ```
    (This says: Forward local port 5439 to the bastion, where is should send traffic to the Redshift cluster on port 5439)

1.  Find the redshift credentials (the secret arn should be in the UI for the cluster).  You should be able to create a connection to Redshift using localhost and those credentials.

#### AWS Setup:
1. Add any necessary secrets to the secretsmanager secrets.  There are two created for the project by default.  One for running jobs locally and one for running jobs in the ECS cluster.  The example job uses REDSHIFT_USER, REDSHIFT_HOST, REDSHIFT_PASSWORD, REDSHIFT_DATABASE, and DEFAULT_S3_BUCKET.

#### Running locally:
see: [python-ingestors](./python-ingestors/README.md) and [dbt-transformations](./dbt-transformations/README.md)

#### CI/CD:
This project uses github actions to update infrastructure and to deploy the task definitions to ECS.  The actions are triggered by creating releases and are defined in the .github/workflows directory.

In order for the actions to run, the following secrets must be added to the repository:
- AWS_ACCESS_KEY_ID
- AWS_SECRET_ACCESS_KEY
And the following variables must be set in the repository:
- AWS_REGION (the region where the resources are created)
- ECS_CLUSTER (the name of the ECS cluster)
- ECR_PYTHON_REPOSITORY (the name of the ECR repository for the python ingestors)
- ECR_DBT_REPOSITORY (the name of the ECR repository for the dbt transformations)
- PYTHON_CONTAINER (the name of the container in the ECR repository for the python ingestors)
- DBT_CONTAINER (the name of the container in the ECR repository for the dbt transformations)

#### Cleaning up:
1. Run `terraform destroy` to delete all resources.