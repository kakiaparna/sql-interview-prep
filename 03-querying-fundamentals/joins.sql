-- 03-querying-fundamentals / joins.sql
-- Database: Sakila 

USE sakila;

-- Q1: List every film with the language it's available in.
SELECT f.film_id, f.title, l.name AS language_name
FROM film AS f
INNER JOIN language AS l ON f.language_id = l.language_id;


-- Q2: For every customer, show their full address, city, and country.
SELECT c.customer_id, c.first_name, c.last_name,
       a.address, ci.city, co.country
FROM customer AS c
INNER JOIN address AS a ON c.address_id = a.address_id
INNER JOIN city AS ci ON a.city_id = ci.city_id
INNER JOIN country AS co ON ci.country_id = co.country_id;


-- Q3: For every customer, show how many times they've rented —
-- including customers who have never rented (0, not excluded).
SELECT c.customer_id, c.first_name, c.last_name,
       COUNT(r.rental_id) AS rental_count
FROM customer AS c
LEFT JOIN rental AS r ON c.customer_id = r.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY rental_count DESC, c.customer_id;


-- Q4: Find customers who have never made a rental at all.
SELECT c.customer_id, c.first_name, c.last_name
FROM customer AS c
LEFT JOIN rental AS r ON c.customer_id = r.customer_id
WHERE r.rental_id IS NULL;


-- Q5: Find pairs of actors who share the same last name.
SELECT a1.actor_id AS actor1_id,
       CONCAT(a1.first_name, ' ', a1.last_name) AS actor1_name,
       a2.actor_id AS actor2_id,
       CONCAT(a2.first_name, ' ', a2.last_name) AS actor2_name,
       a1.last_name
FROM actor AS a1
INNER JOIN actor AS a2
  ON a1.last_name = a2.last_name
 AND a1.actor_id < a2.actor_id
ORDER BY a1.last_name, a1.actor_id, a2.actor_id;


-- Q6: List every film that has no actors assigned, AND every actor
-- who isn't assigned to any film (MySQL has no FULL OUTER JOIN,
-- so it's simulated with LEFT JOIN + RIGHT JOIN combined via UNION).
SELECT f.film_id, f.title, NULL AS actor_id, 'unmatched film' AS note
FROM film AS f
LEFT JOIN film_actor AS fa ON f.film_id = fa.film_id
WHERE fa.actor_id IS NULL

UNION

SELECT NULL AS film_id, NULL AS title, a.actor_id, 'unmatched actor' AS note
FROM actor AS a
LEFT JOIN film_actor AS fa ON a.actor_id = fa.actor_id
WHERE fa.film_id IS NULL;


-- Q7: Find the total amount each customer has paid, highest first.
SELECT c.customer_id, c.first_name, c.last_name,
       SUM(p.amount) AS total_paid
FROM customer AS c
INNER JOIN payment AS p ON c.customer_id = p.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_paid DESC;


-- Q8: Find customers who have rented more than 30 times.
SELECT c.customer_id, c.first_name, c.last_name,
       COUNT(r.rental_id) AS rental_count
FROM customer AS c
INNER JOIN rental AS r ON c.customer_id = r.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING COUNT(r.rental_id) > 30
ORDER BY rental_count DESC;


-- Q9: List all rentals made in June 2005, with customer and film info.
SELECT r.rental_id, r.rental_date,
       c.customer_id, c.first_name, c.last_name,
       f.title
FROM rental AS r
INNER JOIN customer AS c ON r.customer_id = c.customer_id
INNER JOIN inventory AS i ON r.inventory_id = i.inventory_id
INNER JOIN film AS f ON i.film_id = f.film_id
WHERE r.rental_date >= '2005-06-01'
  AND r.rental_date < '2005-07-01'
ORDER BY r.rental_date;


-- Q10: List PG-rated films that are currently stocked, along with
-- which store holds each copy.
SELECT f.film_id, f.title, f.rating,
       i.inventory_id, i.store_id
FROM film AS f
INNER JOIN inventory AS i ON f.film_id = i.film_id
WHERE f.rating = 'PG'
ORDER BY f.title, i.inventory_id;

-- End of joins.sql