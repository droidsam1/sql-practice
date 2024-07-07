
--before
-- Planning Time: 0.571 ms
-- Execution Time: 254.485 ms

-- remove subquery
SET search_path TO Bank;
EXPLAIN ANALYZE
SELECT C.first_name, C.last_name, COUNT(T.id) AS transaction_count from transaction T
                                                                            JOIN Account A ON A.id = T.account_id and A.balance::numeric < 5000
                                                                            JOIN CUSTOMER C ON C.id = A.customer_id
where T.date > '2020-01-01' and T.date < '2020-01-31'
GROUP BY C.first_name, C.last_name ORDER BY transaction_count DESC;
-- after
-- Planning Time: 0.545 ms
-- Execution Time: 90.418 ms

-- add an index
CREATE INDEX idx_transaction_date ON transaction(date);

--after
-- Planning Time: 0.251 ms
-- Execution Time: 76.630 ms