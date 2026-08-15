-- ============================================================
-- 03-querying-fundamentals / select-where-orderby.sql
-- Database: Sakila
-- ============================================================

USE sakila;

-- 1. SELECT specific columns
SELECT actor_id, first_name, last_name
FROM actor;

-- 2. SELECT all columns
SELECT *
FROM film;

-- 3. Column aliases
SELECT first_name AS actor_first_name,
       last_name AS actor_last_name
FROM actor;

-- 4. DISTINCT
SELECT DISTINCT rating
FROM film
ORDER BY rating;

-- 5. WHERE with equality
SELECT film_id, title, rating
FROM film
WHERE rating = 'PG';

-- 6. Numeric comparison
SELECT film_id, title, rental_rate
FROM film
WHERE rental_rate > 4.00;

-- 7. AND
SELECT film_id, title, rating, rental_rate
FROM film
WHERE rating = 'PG-13'
  AND rental_rate > 2.99;

-- 8. OR
SELECT film_id, title, rating
FROM film
WHERE rating = 'PG'
   OR rating = 'G';

-- 9. NOT EQUAL
SELECT film_id, title, rating
FROM film
WHERE rating <> 'R';

-- 10. BETWEEN
SELECT film_id, title, rental_rate
FROM film
WHERE rental_rate BETWEEN 2.00 AND 4.00;

-- 11. IN
SELECT film_id, title, rating
FROM film
WHERE rating IN ('PG', 'PG-13', 'G');

-- 12. LIKE - starts with
SELECT actor_id, first_name, last_name
FROM actor
WHERE first_name LIKE 'A%';

-- 13. LIKE - contains
SELECT actor_id, first_name, last_name
FROM actor
WHERE last_name LIKE '%son%';

-- 14. LIKE - ends with
SELECT actor_id, first_name, last_name
FROM actor
WHERE first_name LIKE '%a';

-- 15. IS NULL
SELECT address_id, address, address2
FROM address
WHERE address2 IS NULL;

-- 16. IS NOT NULL
SELECT address_id, address, address2
FROM address
WHERE address2 IS NOT NULL;

-- 17. ORDER BY ascending
SELECT film_id, title, rental_rate
FROM film
ORDER BY rental_rate ASC;

-- 18. ORDER BY descending
SELECT film_id, title, rental_rate
FROM film
ORDER BY rental_rate DESC;

-- 19. ORDER BY multiple columns
SELECT film_id, title, rating, rental_rate
FROM film
ORDER BY rating ASC,
         rental_rate DESC;

-- 20. ORDER BY using a column alias
SELECT title, rental_rate AS price
FROM film
ORDER BY price DESC;

-- 21. LIMIT
SELECT film_id, title, rental_rate
FROM film
ORDER BY rental_rate DESC
LIMIT 10;

-- 22. LIMIT with OFFSET
SELECT film_id, title, rental_rate
FROM film
ORDER BY rental_rate DESC
LIMIT 10 OFFSET 10;

-- 23. Date filtering using an inclusive start and exclusive end
SELECT payment_id, customer_id, amount, payment_date
FROM payment
WHERE payment_date >= '2005-06-01'
  AND payment_date < '2005-07-01'
ORDER BY payment_date;

-- 24. Combining SELECT, WHERE, ORDER BY and LIMIT
SELECT film_id, title, rating, rental_rate, length
FROM film
WHERE rating IN ('PG', 'PG-13')
  AND rental_rate >= 2.99
ORDER BY rental_rate DESC,
         length DESC
LIMIT 10;

-- 25. DISTINCT with filtering
SELECT DISTINCT special_features
FROM film
WHERE special_features IS NOT NULL
ORDER BY special_features;

-- ============================================================
-- End of select-where-orderby.sql
-- ============================================================
