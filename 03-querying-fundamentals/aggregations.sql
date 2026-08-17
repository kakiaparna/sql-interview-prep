-- 03-querying-fundamentals / aggregations.sql
-- Database: Sakila 

USE sakila;

-- Q1: How many films are in the database in total?
SELECT COUNT(*) AS total_films
FROM film;


-- Q2: What are the cheapest and most expensive film rental rates?
SELECT MIN(rental_rate) AS cheapest_rate,
       MAX(rental_rate) AS most_expensive_rate
FROM film;


-- Q3: What is the average payment amount across all payments?
SELECT ROUND(AVG(amount), 2) AS avg_payment
FROM payment;


-- Q4: How many films fall under each rating (G, PG, PG-13, R, NC-17)?
SELECT rating, COUNT(*) AS film_count
FROM film
GROUP BY rating
ORDER BY film_count DESC;


-- Q5: What's the average film length for each rating category?
SELECT rating, ROUND(AVG(length), 1) AS avg_length_minutes
FROM film
GROUP BY rating
ORDER BY avg_length_minutes DESC;


-- Q6: Which film categories have more than 60 films in them?
SELECT cat.name AS category_name, COUNT(fc.film_id) AS film_count
FROM category AS cat
INNER JOIN film_category AS fc ON cat.category_id = fc.category_id
GROUP BY cat.name
HAVING COUNT(fc.film_id) > 60
ORDER BY film_count DESC;


-- Q7: For each store, how many rentals and how much total revenue has it generated?
SELECT s.store_id,
       COUNT(DISTINCT r.rental_id) AS total_rentals,
       ROUND(SUM(p.amount), 2) AS total_revenue
FROM store AS s
INNER JOIN staff AS st ON s.store_id = st.store_id
INNER JOIN payment AS p ON st.staff_id = p.staff_id
INNER JOIN rental AS r ON p.rental_id = r.rental_id
GROUP BY s.store_id;


-- Q8: How many distinct customers made a payment in June 2005?
SELECT COUNT(DISTINCT customer_id) AS distinct_paying_customers
FROM payment
WHERE payment_date >= '2005-06-01'
  AND payment_date < '2005-07-01';


-- Q9: What's the minimum, maximum, and average replacement cost of films, grouped by rating?
SELECT rating,
       MIN(replacement_cost) AS min_cost,
       MAX(replacement_cost) AS max_cost,
       ROUND(AVG(replacement_cost), 2) AS avg_cost
FROM film
GROUP BY rating
ORDER BY avg_cost DESC;


-- Q10: For each category, list all film titles as a single comma-separated string.
SELECT cat.name AS category_name,
       GROUP_CONCAT(f.title ORDER BY f.title SEPARATOR ', ') AS film_titles
FROM category AS cat
INNER JOIN film_category AS fc ON cat.category_id = fc.category_id
INNER JOIN film AS f ON fc.film_id = f.film_id
GROUP BY cat.name
ORDER BY cat.name;


-- Q11: How much does film length vary within each rating category? (standard deviation and variance of length, by rating)
SELECT rating,
       ROUND(STDDEV(length), 2) AS length_stddev,
       ROUND(VARIANCE(length), 2) AS length_variance
FROM film
GROUP BY rating
ORDER BY length_stddev DESC;

-- End of aggregations.sql