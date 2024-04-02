# Marts Models
### Analogy (From DBT Docs)
_This is the layer where everything comes together and we start to arrange all of our atoms (staging models) and molecules (intermediate models) into full-fledged cells that have identity and purpose. We sometimes like to call this the entity layer or concept layer, to emphasize that all our marts are meant to represent a specific entity or concept at its unique grain._

### Folder Structure
- Group by area of business concern or by department.  For example, you may want to put a directory called `finance` in the `marts` directory if you are working on sales related models.

### File Naming
- Name by entity.  Use plain english to name the file based on the concept or entity that the model represents.  For example, `users.sql` or `orders.sql`.

### Transformation Logic
In the marts layer, we focus on the following types of transformation logic, specific to the business entity or concept we are working with:
- Joins
- Aggregations
- Calculations

### Materialization
Marts models should be materialized as tables or incremental models.  This gives end users much faster performance for these models that are designed for their use and saves on the cost of recomputing the entire chain of models every time someone runs a query, script or refreshes a dashboard.  The models with the most data and compute-intensive transformations should absolutely take advantage of dbt’s excellent incremental materialization options, but rushing to make all your marts models incremental by default will introduce superfluous difficulty.  Classic post [here](https://discourse.getdbt.com/t/on-the-limits-of-incrementality/303)

### Do's
- Keep tables wide and denormalized.  Data storage in the modern warehouse is cheap and compute is expensive.  Packing everything someone might need to know about a concept is the goal here.

- Build on separate marts thoughtfully.  A common example is passing data from different marts at different grains.

### Don'ts
- Create a mart with too many joins  Do not bring together too many concepts into a single mart.  While this isn’t a hard rule, if you’re bringing together more than 4 or 5 concepts to create your mart, you may benefit from adding some intermediate models for added clarity. Two intermediate models that bring together three concepts each, and a mart that brings together those two intermediate models, will typically result in a much more readable chain of logic than a single mart with six joins.

