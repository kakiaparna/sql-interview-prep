-- 04-intermediate-querying / subqueries.sql
-- Database: Sakila 
USE sakila;

-- Q1: Find all films with a rental rate above the overall average
-- rental rate (nested subquery in WHERE).
SELECT film_id, title, rental_rate
FROM film
WHERE rental_rate > (SELECT AVG(rental_rate) FROM film)
ORDER BY rental_rate DESC;


-- Q2: Find the film(s) with the single highest rental rate,
-- using a subquery instead of ORDER BY + LIMIT.
SELECT film_id, title, rental_rate
FROM film
WHERE rental_rate = (SELECT MAX(rental_rate) FROM film);


-- Q3: Find all films that have been rented at least once
-- (subquery with IN, built on inventory + rental).
SELECT film_id, title
FROM film
WHERE film_id IN (
    SELECT i.film_id
    FROM inventory AS i
    INNER JOIN rental AS r ON i.inventory_id = r.inventory_id
);


-- Q4: Find all films that have never been rented (NOT IN version).
SELECT film_id, title
FROM film
WHERE film_id NOT IN (
    SELECT i.film_id
    FROM inventory AS i
    INNER JOIN rental AS r ON i.inventory_id = r.inventory_id
);


-- Q5: Find all customers who have made at least one rental,
-- using EXISTS instead of a join.
SELECT customer_id, first_name, last_name
FROM customer AS c
WHERE EXISTS (
    SELECT 1
    FROM rental AS r
    WHERE r.customer_id = c.customer_id
);


-- Q6: Find all customers who have never made a rental,
-- using NOT EXISTS (correlated subquery).
SELECT customer_id, first_name, last_name
FROM customer AS c
WHERE NOT EXISTS (
    SELECT 1
    FROM rental AS r
    WHERE r.customer_id = c.customer_id
);


-- Q7: For each customer, show their total number of rentals
-- using a correlated subquery in the SELECT list.
SELECT c.customer_id, c.first_name, c.last_name,
       (SELECT COUNT(*)
        FROM rental AS r
        WHERE r.customer_id = c.customer_id) AS rental_count
FROM customer AS c
ORDER BY rental_count DESC;


-- Q8: Find films with a rental rate greater than ANY film
-- rated 'G' (i.e., higher than at least the cheapest G-rated film).
SELECT film_id, title, rating, rental_rate
FROM film
WHERE rental_rate > ANY (
    SELECT rental_rate FROM film WHERE rating = 'G'
)
ORDER BY rental_rate;


-- Q9: Find films with a rental rate greater than ALL films rated 'G' 
-- (i.e., higher than even the most expensive G-rated film).
SELECT film_id, title, rating, rental_rate
FROM film
WHERE rental_rate > ALL (
    SELECT rental_rate FROM film WHERE rating = 'G'
)
ORDER BY rental_rate;


-- Q10: Find customers whose total payments are above the average total payment per customer 
-- (subquery in HAVING, comparing an aggregate to another aggregate).
SELECT c.customer_id, c.first_name, c.last_name,
       SUM(p.amount) AS total_paid
FROM customer AS c
INNER JOIN payment AS p ON c.customer_id = p.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING SUM(p.amount) > (
    SELECT AVG(customer_total)
    FROM (
        SELECT SUM(amount) AS customer_total
        FROM payment
        GROUP BY customer_id
    ) AS customer_totals
)
ORDER BY total_paid DESC;


-- Q11: Using a subquery in the FROM clause (a derived table), find the top 5 highest-spending stores by total revenue per store.
SELECT store_revenue.store_id, store_revenue.total_revenue
FROM (
    SELECT s.store_id, SUM(p.amount) AS total_revenue
    FROM store AS s
    INNER JOIN staff AS st ON s.store_id = st.store_id
    INNER JOIN payment AS p ON st.staff_id = p.staff_id
    GROUP BY s.store_id
) AS store_revenue
ORDER BY store_revenue.total_revenue DESC
LIMIT 5;

-- End of subqueries.sql
