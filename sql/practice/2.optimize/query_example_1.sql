-- Exercise 1: Optimize Retrieval of Large Datasets
-- Objective: Optimize a query that retrieves all transactions for a specific customer that have occurred in december of  2020, ensuring the query can handle large datasets efficiently.
SET search_path TO bank;
SELECT *
FROM Transaction
WHERE account_id IN (SELECT id
                     FROM Account
                     WHERE customer_id = (SELECT id
                                          FROM Customer
                                          WHERE first_name = 'Paul'
                                            AND last_name = 'Panaitescu'))
  AND date > '2020-12-01'


------------------------- analyze --------------------------------
EXPLAIN ANALYSE
SELECT *
FROM Transaction
WHERE account_id IN (SELECT id
                     FROM Account
                     WHERE customer_id = (SELECT id
                                          FROM Customer
                                          WHERE first_name = 'Paul'
                                            AND last_name = 'Panaitescu'))
  AND date > '2020-12-01';
-- Planning Time: 0.253 ms
-- Execution Time: 134.881 ms


---------------------- optimization ------------------------------
EXPLAIN ANALYSE
SELECT T.id, T.account_id, T.description, T.amount, T.date
FROM Transaction T
         JOIN bank.account A on T.account_id = A.id
         JOIN bank.customer C on C.id = A.customer_id
WHERE C.first_name = 'Paul'
  AND C.last_name = 'Panaitescu'
  AND T.date > '2020-12-01';

CREATE INDEX first_and_last_name_index ON CUSTOMER(first_name, last_name );
--Planning Time: 0.619 ms
-- Execution Time: 81.806 ms
