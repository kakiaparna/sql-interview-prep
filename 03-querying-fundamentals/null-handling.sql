-- 03-querying-fundamentals / null-handling.sql
-- Database: Sakila 

USE sakila;

-- Q1: Find all rentals that haven't been returned yet.
SELECT rental_id, customer_id, rental_date, return_date
FROM rental
WHERE return_date IS NULL;


-- Q2: Find all rentals that have been returned.
SELECT rental_id, customer_id, rental_date, return_date
FROM rental
WHERE return_date IS NOT NULL;


-- Q3: List rentals showing 'Not Returned' instead of a blank value wherever return_date is NULL.
SELECT rental_id, customer_id, rental_date,
       COALESCE(return_date, 'Not Returned') AS return_status
FROM rental;


-- Q4: List customer addresses, showing 'N/A' wherever the secondary address line (address2) is missing.
SELECT address_id, address,
       IFNULL(address2, 'N/A') AS address_line_2
FROM address;


-- Q5: Find addresses where the secondary address line is either NULL or an empty string (two different ways of "missing" data).
SELECT address_id, address, address2
FROM address
WHERE address2 IS NULL OR address2 = '';


-- Q6: Compare COUNT(*) vs COUNT(return_date) on the rental table to see how NULLs are handled differently by each.
SELECT COUNT(*) AS total_rentals,
       COUNT(return_date) AS returned_rentals
FROM rental;


-- Q7: Use NULLIF to avoid a divide-by-zero error when calculating the ratio of replacement cost to rental rate for each film.
SELECT film_id, title, replacement_cost, rental_rate,
       replacement_cost / NULLIF(rental_rate, 0) AS cost_to_rate_ratio
FROM film;


-- Q8: Find pairs of addresses that have the exact same address2 value, using the NULL-safe equality operator so that two NULLs are correctly treated as "equal" instead of unknown.
SELECT a1.address_id AS address1_id, a2.address_id AS address2_id,
       a1.address2
FROM address AS a1
INNER JOIN address AS a2
  ON a1.address2 <=> a2.address2
 AND a1.address_id < a2.address_id
LIMIT 20;


-- Q9: List all rentals ordered by return_date, and observe where NULL values (not-yet-returned rentals) land in the sort order.
SELECT rental_id, customer_id, return_date
FROM rental
ORDER BY return_date ASC
LIMIT 20;

-- End of null-handling.sql