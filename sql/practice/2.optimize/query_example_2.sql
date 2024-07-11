--Exercise 2: Improve Aggregation Query Performance
-- Objective: Optimize a query that calculates the total balance for each branch, including branches with no accounts.  Initial Query:
SET search_path TO bank;
SELECT b.name, COALESCE(SUM(CAST(a.balance AS DECIMAL)), 0) AS total_balance
FROM Branch b
         LEFT JOIN Account a ON b.id = a.customer_id
GROUP BY b.name;

------------------------- analyze --------------------------------

EXPLAIN  ANALYSE
SELECT b.name, COALESCE(SUM(CAST(a.balance AS DECIMAL)), 0) AS total_balance
FROM Branch b
         LEFT JOIN Account a ON b.id = a.customer_id
GROUP BY b.name;

-- Planning Time: 0.487 ms
-- JIT:
--   Functions: 48
-- "  Options: Inlining false, Optimization false, Expressions true, Deforming true"
-- "  Timing: Generation 5.336 ms, Inlining 0.000 ms, Optimization 2.458 ms, Emission 72.026 ms, Total 79.820 ms"
-- Execution Time: 2499.720 ms

SELECT
    tablename,
    indexname,
    indexdef
FROM
    pg_indexes
WHERE
    tablename = 'account';

---------------------- optimization ------------------------------
CREATE INDEX  customer_id_index ON account(customer_id);

EXPLAIN  ANALYSE
SELECT b.name, COALESCE(SUM(a.balance), 0) AS total_balance
FROM Branch b
         LEFT JOIN Account a ON b.id = a.customer_id
GROUP BY b.name;

-- Planning Time: 0.261 ms
-- JIT:
--   Functions: 48
-- "  Options: Inlining false, Optimization false, Expressions true, Deforming true"
-- "  Timing: Generation 5.077 ms, Inlining 0.000 ms, Optimization 3.460 ms, Emission 75.988 ms, Total 84.525 ms"
-- Execution Time: 2536.505 ms

ALTER TABLE account ALTER COLUMN balance TYPE NUMERIC USING balance::numeric;

-- Planning Time: 0.525 ms
-- JIT:
--   Functions: 48
-- "  Options: Inlining false, Optimization false, Expressions true, Deforming true"
-- "  Timing: Generation 2.573 ms, Inlining 0.000 ms, Optimization 2.021 ms, Emission 54.469 ms, Total 59.062 ms"
-- Execution Time: 2385.267 ms

-- Correct join condition and add another index
CREATE INDEX  branch_id_index ON customer(branch_id);

EXPLAIN ANALYZE
SELECT b.name, COALESCE(SUM(a.balance), 0) AS total_balance
FROM Branch b
         LEFT JOIN Customer c ON b.id = c.branch_id
         LEFT JOIN Account a ON c.id = a.customer_id
GROUP BY b.name;

-- Planning Time: 0.782 ms
-- JIT:
--   Functions: 72
-- "  Options: Inlining false, Optimization false, Expressions true, Deforming true"
-- "  Timing: Generation 3.639 ms, Inlining 0.000 ms, Optimization 1.793 ms, Emission 56.479 ms, Total 61.910 ms"
-- Execution Time: 2639.120 ms