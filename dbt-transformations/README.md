# DBT Transformations
This directory contains DBT (data build tool) projects which are used to normalize, organize and prepare data for analysis.

Prerequisites:
- python 3.x
- pip
- pipenv

### What's in this project?
The `data_warehouse` project, which builds on the example job in the python ingestors directory.  The project is meant to be a very primitive example that walks through DBT best practices.

### Local Setup
1. Set the following variables in a a new terminal session:
    ```
    DBT_ENV_SECRET_REDSHIFT_DB_NAME
    DBT_ENV_SECRET_REDSHIFT_HOST
    DBT_ENV_SECRET_REDSHIFT_PASSWORD
    DBT_ENV_SECRET_REDSHIFT_USER
    DBT_PROFILES_DIR
    ```
    The profiles directory should be the location of the profiles.yml file on your local machine.
1. Run `pipenv shell && pipenv install` to install the dependencies and activate the virtual environment.

1. run `dbt debug` to test the connection to the redshift cluster (you will need the port forwarding set up as described in the project root [README](../README.md)).

### Project Structure
As mentioned, the `data_warehouse` project is structured to be a simplistic example based on DBT best practices.  However, in order to fully appreciate how to properly structure a DBT project, follow the readme's in the individual stages of the pipeline.
- [staging](./data_warehouse/models/staging/README.md)
- [intermediate](./data_warehouse/models/intermediate/readme.md)
- [marts](./data_warehouse/models/marts/readme.md)

### ECS Setup
1. In the AWS console, Navigate to the task definition created for the dbt-transformations service.  Copy the task definition as json and paste it into ./dbt-transformations-task-definition.json.  This is needed for the github action to create revisions on deployments.
