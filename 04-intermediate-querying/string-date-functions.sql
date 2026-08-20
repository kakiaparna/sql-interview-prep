-- 04-intermediate-querying / string-date-functions.sql
-- Database: Sakila 

USE sakila;

-- Q1: List each customer's full name as a single column
-- (CONCAT).
SELECT customer_id, CONCAT(first_name, ' ', last_name) AS full_name
FROM customer;


-- Q2: List all film categories in uppercase, and all customer
-- emails in lowercase (UPPER / LOWER).
SELECT UPPER(name) AS category_upper
FROM category;

SELECT customer_id, LOWER(email) AS email_lower
FROM customer;


-- Q3: Show the first 5 characters of every film title
-- (SUBSTRING).
SELECT film_id, title, SUBSTRING(title, 1, 5) AS title_snippet
FROM film;


-- Q4: Find films whose title is longer than 20 characters
-- (LENGTH).
SELECT film_id, title, LENGTH(title) AS title_length
FROM film
WHERE LENGTH(title) > 20
ORDER BY title_length DESC;


-- Q5: Generate a URL-friendly version of each film title by
-- replacing spaces with underscores (REPLACE).
SELECT film_id, title, REPLACE(title, ' ', '_') AS title_slug
FROM film;


-- Q6: Find all films whose title starts with 'A'
-- (LIKE).
SELECT film_id, title
FROM film
WHERE title LIKE 'A%'
ORDER BY title;


-- Q7: Find all films whose title contains a number
-- (REGEXP).
SELECT film_id, title
FROM film
WHERE title REGEXP '[0-9]';


-- Q8: For every completed rental, calculate how many days the
-- customer kept the film (DATEDIFF).
SELECT rental_id, customer_id, rental_date, return_date,
       DATEDIFF(return_date, rental_date) AS days_rented
FROM rental
WHERE return_date IS NOT NULL
ORDER BY days_rented DESC;


-- Q9: For every rental, calculate the expected return date based
-- on the film's rental duration (DATE_ADD).
SELECT r.rental_id, r.rental_date, f.rental_duration,
       DATE_ADD(r.rental_date, INTERVAL f.rental_duration DAY) AS expected_return_date
FROM rental AS r
INNER JOIN inventory AS i ON r.inventory_id = i.inventory_id
INNER JOIN film AS f ON i.film_id = f.film_id;


-- Q10: Display each rental date in a readable 'DD-Mon-YYYY'
-- format instead of the default MySQL date format (DATE_FORMAT).
SELECT rental_id, rental_date,
       DATE_FORMAT(rental_date, '%d-%b-%Y') AS formatted_date
FROM rental;


-- Q11: Count how many rentals happened in each month of 2005
-- (YEAR / MONTH extraction).
SELECT YEAR(rental_date) AS rental_year,
       MONTH(rental_date) AS rental_month,
       COUNT(*) AS total_rentals
FROM rental
WHERE YEAR(rental_date) = 2005
GROUP BY YEAR(rental_date), MONTH(rental_date)
ORDER BY rental_month;


-- Q12: For completed rentals, calculate the exact number of hours
-- between rental_date and return_date (TIMESTAMPDIFF).
SELECT rental_id, rental_date, return_date,
       TIMESTAMPDIFF(HOUR, rental_date, return_date) AS hours_rented
FROM rental
WHERE return_date IS NOT NULL
ORDER BY hours_rented DESC
LIMIT 20;

-- End of string-date-functions.sql