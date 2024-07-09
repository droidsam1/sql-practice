# Common areas for Optimization

1. **Indexing**: Look for Seq Scans where you expect Index Scans
2. **Joins**: Nested loops are OK for small datasets, Hash joins or merge joins might be more
   efficient for larger tables
    1. Ensure indexes are present on the columns used for joining tables
    2. Place the table with the least number of rows first to filter as early as possible
    3. Reduce rows early applying filters as soon as possible
    4. Use the appropriate type of join
    5. Partitioning for very large tables
3. **Filtering**:  Ensure filters are applied as early as possible to reduce the number of rows processed
4. **Sorting**: They can be expensive, avoid sorting if possible
5. **Aggregations**: Hash-based aggregation is faster than sort-based aggregation

If the query is used frequently and the data does not change often, consider using a materialized
   view

## Other notes

1. **Avoid SELECT '*'** : SELECT * is highly inefficient
2. **Inner joins vs. WHERE clause**: WHERE clause creates the CROSS join/ CARTESIAN product for merging tables. CARTESIAN product of two tables takes a lot of time.
3. **IN versus EXISTS**:
   IN operator is more costly than EXISTS regarding scans, especially when the subquery result is a large dataset. So, we should try to use EXISTS rather than IN to fetch results with a subquery.

Resources:

* https://planetscale.com/learn/courses/mysql-for-developers/indexes/introduction-to-indexes?autoplay=1
* https://planetscale.com/learn/courses/database-scaling/scaling/db-and-query-tuning?autoplay=1
* https://www.analyticsvidhya.com/blog/2021/10/a-detailed-guide-on-sql-query-optimization/