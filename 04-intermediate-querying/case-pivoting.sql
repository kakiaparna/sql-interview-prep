-- 04-intermediate-querying / case-pivoting.sql
-- Database: Sakila 

USE sakila;

-- Q1: Categorize each film as 'Short', 'Medium', or 'Long' based
-- on its length in minutes (simple CASE).
SELECT film_id, title, length,
       CASE
           WHEN length < 60 THEN 'Short'
           WHEN length BETWEEN 60 AND 120 THEN 'Medium'
           ELSE 'Long'
       END AS length_category
FROM film;


-- Q2: Categorize each film into a pricing tier based on its
-- rental rate (CASE with multiple conditions).
SELECT film_id, title, rental_rate,
       CASE
           WHEN rental_rate <= 0.99 THEN 'Budget'
           WHEN rental_rate <= 2.99 THEN 'Standard'
           ELSE 'Premium'
       END AS pricing_tier
FROM film;


-- Q3: For each customer, count how many rentals were returned
-- late vs on-time, using CASE inside an aggregate function.
SELECT c.customer_id, c.first_name, c.last_name,
       SUM(CASE WHEN DATEDIFF(r.return_date, r.rental_date) > f.rental_duration
                THEN 1 ELSE 0 END) AS late_returns,
       SUM(CASE WHEN DATEDIFF(r.return_date, r.rental_date) <= f.rental_duration
                THEN 1 ELSE 0 END) AS on_time_returns
FROM customer AS c
INNER JOIN rental AS r ON c.customer_id = r.customer_id
INNER JOIN inventory AS i ON r.inventory_id = i.inventory_id
INNER JOIN film AS f ON i.film_id = f.film_id
WHERE r.return_date IS NOT NULL
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY late_returns DESC;


-- Q4: List films ordered by rating, but in a custom business order
-- (G first, then PG, PG-13, R, NC-17) instead of alphabetical
-- (CASE used inside ORDER BY).
SELECT film_id, title, rating
FROM film
ORDER BY CASE rating
             WHEN 'G' THEN 1
             WHEN 'PG' THEN 2
             WHEN 'PG-13' THEN 3
             WHEN 'R' THEN 4
             WHEN 'NC-17' THEN 5
         END;


-- Q5: Label each film with a nested category — first by rating
-- (Family / Mature), then by length within that group
-- (nested CASE).
SELECT film_id, title, rating, length,
       CASE
           WHEN rating IN ('G', 'PG') THEN
               CASE WHEN length < 90 THEN 'Family - Short' ELSE 'Family - Long' END
           ELSE
               CASE WHEN length < 90 THEN 'Mature - Short' ELSE 'Mature - Long' END
       END AS film_label
FROM film;


-- Q6: For each store, show the count of rentals broken out into
-- separate columns by film rating (manual pivot using CASE + GROUP BY).
SELECT s.store_id,
       SUM(CASE WHEN f.rating = 'G' THEN 1 ELSE 0 END) AS g_count,
       SUM(CASE WHEN f.rating = 'PG' THEN 1 ELSE 0 END) AS pg_count,
       SUM(CASE WHEN f.rating = 'PG-13' THEN 1 ELSE 0 END) AS pg13_count,
       SUM(CASE WHEN f.rating = 'R' THEN 1 ELSE 0 END) AS r_count,
       SUM(CASE WHEN f.rating = 'NC-17' THEN 1 ELSE 0 END) AS nc17_count
FROM rental AS r
INNER JOIN inventory AS i ON r.inventory_id = i.inventory_id
INNER JOIN film AS f ON i.film_id = f.film_id
INNER JOIN store AS s ON i.store_id = s.store_id
GROUP BY s.store_id;


-- Q7: Build a cross-tab of film counts per category, split into
-- rating columns side by side (cross-tab pivot).
SELECT cat.name AS category_name,
       SUM(CASE WHEN f.rating = 'G' THEN 1 ELSE 0 END) AS g_films,
       SUM(CASE WHEN f.rating = 'PG' THEN 1 ELSE 0 END) AS pg_films,
       SUM(CASE WHEN f.rating = 'PG-13' THEN 1 ELSE 0 END) AS pg13_films,
       SUM(CASE WHEN f.rating = 'R' THEN 1 ELSE 0 END) AS r_films,
       SUM(CASE WHEN f.rating = 'NC-17' THEN 1 ELSE 0 END) AS nc17_films
FROM category AS cat
INNER JOIN film_category AS fc ON cat.category_id = fc.category_id
INNER JOIN film AS f ON fc.film_id = f.film_id
GROUP BY cat.name
ORDER BY cat.name;


-- Q8: Show total revenue per store, split into separate columns
-- for each year payments were made (conditional aggregation pivot).
SELECT s.store_id,
       SUM(CASE WHEN YEAR(p.payment_date) = 2005 THEN p.amount ELSE 0 END) AS revenue_2005,
       SUM(CASE WHEN YEAR(p.payment_date) = 2006 THEN p.amount ELSE 0 END) AS revenue_2006
FROM store AS s
INNER JOIN staff AS st ON s.store_id = st.store_id
INNER JOIN payment AS p ON st.staff_id = p.staff_id
GROUP BY s.store_id;

-- End of case-pivoting.sql