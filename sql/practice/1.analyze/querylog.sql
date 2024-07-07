
SET search_path TO Bank;

-- 👇 This should NOT appear in the slow query log
-- fast query example
SELECT * FROM loan WHERE id = 1;

-- 👇 This should appear in the slow query log
--slow query example
-- find  the customers who have made the most transactions in January 2020 and have an account balance of less than $5000
EXPLAIN ANALYZE
SELECT C.first_name, C.last_name, COUNT(T.id) AS transaction_count from transaction T
    JOIN Account A ON A.id = T.account_id
    JOIN CUSTOMER C ON C.id = A.customer_id
where T.date > '2020-01-01' and T.date < '2020-01-31'
AND C.id IN (
    SELECT customer_id
    FROM Account
    WHERE balance::numeric < 5000
)
GROUP BY C.first_name, C.last_name ORDER BY transaction_count DESC;

----extreme slow query
-- SELECT C.first_name, C.last_name, AVG(L.amount_paid) AS average_loan, COUNT(T.id) AS transaction_count
-- FROM Customer C
--          JOIN Account A ON C.id = A.customer_id
--          JOIN Loan L ON A.id = L.account_id
--          JOIN Transaction T ON A.id = T.account_id
-- WHERE C.id IN (
--     SELECT customer_id
--     FROM Account
--     WHERE balance::numeric < 5000
-- )
--   AND L.start_date BETWEEN '2020-01-01' AND '2020-12-31'
--   AND T.date > '2020-01-01'
-- GROUP BY C.first_name, C.last_name;