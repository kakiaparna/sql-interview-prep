-- 04-intermediate-querying / set-operations.sql
-- Database: Sakila
-- Note: INTERSECT and EXCEPT require MySQL 8.0.31 or later.

USE sakila;

-- Q1: Build one combined contact list of all customer emails and
-- all staff emails, with duplicates automatically removed (UNION).
SELECT email FROM customer
UNION
SELECT email FROM staff;


-- Q2: Same combined contact list as Q1, but keep duplicates instead
-- of removing them, to compare row counts (UNION ALL).
SELECT email FROM customer
UNION ALL
SELECT email FROM staff;


-- Q3: Find customer_ids who have rented from BOTH store 1 AND
-- store 2 (INTERSECT of two customer_id sets).
SELECT r.customer_id
FROM rental AS r
INNER JOIN staff AS s ON r.staff_id = s.staff_id
WHERE s.store_id = 1
INTERSECT
SELECT r.customer_id
FROM rental AS r
INNER JOIN staff AS s ON r.staff_id = s.staff_id
WHERE s.store_id = 2;


-- Q4: Find customer_ids who rented from store 1 but have NEVER
-- rented from store 2 at all (EXCEPT).
SELECT r.customer_id
FROM rental AS r
INNER JOIN staff AS s ON r.staff_id = s.staff_id
WHERE s.store_id = 1
EXCEPT
SELECT r.customer_id
FROM rental AS r
INNER JOIN staff AS s ON r.staff_id = s.staff_id
WHERE s.store_id = 2;


-- Q5: Build a combined watchlist of "premium-priced" films
-- (rental_rate > 4.00) and "long-duration" films (length > 150
-- minutes), with overlapping films listed only once (UNION).
SELECT film_id, title FROM film WHERE rental_rate > 4.00
UNION
SELECT film_id, title FROM film WHERE length > 150;


-- Q6: Same combined watchlist as Q5, but keep both entries for
-- any film that qualifies on both conditions (UNION ALL) —
-- compare row count against Q5 to see the overlap size.
SELECT film_id, title FROM film WHERE rental_rate > 4.00
UNION ALL
SELECT film_id, title FROM film WHERE length > 150;


-- Q7: Find films that are BOTH premium-priced AND long-duration
-- (INTERSECT) — the actual overlap between the two watchlists.
SELECT film_id, title FROM film WHERE rental_rate > 4.00
INTERSECT
SELECT film_id, title FROM film WHERE length > 150;


-- Q8: Find films that are premium-priced but NOT long-duration
-- (EXCEPT) — isolates the "expensive but short" films.
SELECT film_id, title FROM film WHERE rental_rate > 4.00
EXCEPT
SELECT film_id, title FROM film WHERE length > 150;

-- End of set-operations.sql