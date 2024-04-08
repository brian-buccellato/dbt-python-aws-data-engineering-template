# Staging Models
### Analogy (From DBT Docs)
_The staging models will be the atomic building blocks of our data warehouse.   If our source system data is a soup of raw energy and quarks, then you can think of the staging layer as condensing and refining this material into the individual atoms we’ll later build more intricate and useful structures with._

### Folder Structure
- Subdirectories should be based on source system.  For example, if you have a source system called `salesforce`, you should have a directory called `salesforce` in the `staging` directory.

### File Naming
- Names should be unique and correspond to the model they are creating.  For example, if you are creating a staging model for `salesforce` based on account level data, the file should be named `stg_salesforce__accounts.sql`.  OR generally `stg_[source]__[entity]s.sql`.
- Plural Model Names:  Always use plural model names.

### Transformation Logic
The most standard types of transformation logic in a staging model are:
- Type Casting:  Casting data types to the appropriate type.
- Renaming: Renaming columns to be more user friendly, follow conventions/standards, or to avoid reserved words etc.
- BASIC Computation: Thinks like cents to dollars, or concatenating fields.
- Categorizing: Using conditional logic to group values into buckets or boolean values.
- ### DO NOT:
  - Aggregate:  Do not aggregate data in staging models.
  - Join:  Do not join tables in staging models.

### Materialization
Materialize Staging models as Views:
Staging models are not intended to be final artifacts themselves, but rather building blocks for later models, staging models should typically be materialized as views for two key reasons:

- Any downstream model (discussed more in marts) referencing our staging models will always get the freshest data possible from all of the component views it’s pulling together and materializing

- It avoids wasting space in the warehouse on models that are not intended to be queried by data consumers, and thus do not need to perform as quickly or efficiently

### Reference
https://docs.getdbt.com/best-practices/how-we-structure/2-staging