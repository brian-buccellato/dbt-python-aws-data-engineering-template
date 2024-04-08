# Python Ingestors

This repository contains a collection of Python scripts that can be used to collect and ingest data into Redshift.

Prerequisites:
- python 3.x
- pip
- pipenv

### What's in this project?
#### Jobs
This directory will contain scripts for extracting and loading data into Redshift.  jobs/example_job/example.py shows how this might be done.
#### Utils
This will contain utility functionality that will build the base class for all jobs.

### Local Setup
1. Create a .env file at the root of this project with the variables found in the example.env file.

1. Run `pipenv shell && pipenv install` to install the dependencies and activate the virtual environment.

1. Run `python jobs/example_job/example.py` to run the example job.  Note- you will need to take care of creating the necessary schema and tables and DB permissioning in Redshift.  This will be true of all jobs.

### ECS Setup
1. In the AWS console, Navigate to the task definition created for the python-ingestors service.  Copy the task definition as json and paste it into ./python-ingestor-task-definition.json.  This is needed for the github action to create revisions on deployments.