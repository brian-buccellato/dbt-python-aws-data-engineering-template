# Intermediate Models
### Analogy (From DBT Docs)
_Once we’ve got our atoms ready to work with, we’ll set about bringing them together into more intricate, connected molecular shapes. The intermediate layer is where these molecules live, creating varied forms with specific purposes on the way towards the more complex proteins and cells we’ll use to breathe life into our data products._

### Folder Structure
- Subdirectories Should be based on area of business concern. For example, you may want to put a directory called `finance` in the `intermediate` directory if you are working on sales related models.

### File Naming
- Names should be more focused on the language describing the transformation.  In general, `int_[entity]s_[verbs].sql` is a good naming convention.  For our example above, we might do something like `int_sales_aggregated_to_user.sql`.  There are also cases where your intermediate models will operate at the source level and may be named like `int_shopify__sales_aggregated_to_user`.

### Transformation Logic
In the intermediate layer, we focus on the following types of transformation logic:
- Groupings
- Aggregations
- Pivoting models to a different grain

### Materialization
Intermediate models should be materialized either ephemerally or as views.  Ephemeral materialization is the simplest route and will keep unnecessary models out of your warehouse.  However, ephemerals are basically just interpolations of CTEs and thus not directly queryable (although the models that `ref()` them can "query" them as if they were tables/views), making them more difficult to debug.  Materializing your models as views in a dedicated schema with specific permissions gives added insight and makes for easier troubleshooting with the tradeoff of added complexity in both setup and warehouse space.