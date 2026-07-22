use sakila;
show tables;

-- 1) All films with PG-13 films with rental rate of 2.99 or lower
SELECT * FROM film WHERE rating='PG-13' AND rental_rate<=2.99;

-- 2) All films that have deleted scenes
SELECT * FROM film WHERE special_features LIKE '%Deleted Scenes%';

-- 3) All active customers
SELECT * FROM customer WHERE active=1;

-- 4) Names of customers who rented a movie on 26th July 2005
SELECT CONCAT(c.first_name ," " , c.last_name) AS NAME 
FROM customer c JOIN rental r on c.customer_id=r.customer_id 
WHERE r.rental_date LIKE '2005-07-26%';

-- 5) Distinct names of customers who rented a movie on 26th July 2005
SELECT DISTINCT CONCAT(c.first_name ," " , c.last_name) AS NAME 
FROM customer c JOIN rental r on c.customer_id=r.customer_id 
WHERE r.rental_date LIKE '2005-07-26%';

-- 6) How many rentals we do on each day?
SELECT date(rental_date) as date, COUNT(*) FROM rental GROUP BY date;

-- 7) All Sci-fi films in our catalogue
SELECT title 
FROM film f JOIN film_category fc ON f.film_id=fc.film_id
JOIN category c ON fc.category_id = c.category_id 
WHERE c.name='Sci-Fi';

-- 8) Customers and how many movies they rented from us so far?
SELECT c.customer_id, CONCAT(c.first_name ," " , c.last_name) AS NAME, COUNT(*) 
FROM customer c 
JOIN rental r ON c.customer_id=r.customer_id 
GROUP BY c.customer_id;

-- 9) Which movies should we discontinue from our catalogue (less than 2 lifetime rentals)
WITH low_rentals AS (
    SELECT inventory_id, COUNT(*)
    FROM rental r
    GROUP BY inventory_id
    HAVING COUNT(*) <= 1 )
SELECT low_rentals.inventory_id, i.film_id, f.title
FROM low_rentals
JOIN inventory i ON i.inventory_id = low_rentals.inventory_id
JOIN film f ON f.film_id=i.film_id;

-- 10) Which movies are not returned yet?
SELECT f.title, r.rental_id FROM film f 
JOIN inventory i ON f.film_id=i.film_id
JOIN rental r ON r.inventory_id = i.inventory_id
WHERE r.return_date IS NULL;


-- H1) How many distinct last names we have in the data?
SELECT COUNT(DISTINCT last_name) FROM customer;

-- H2) How much money and rentals we make for Store 1 by day?  
SELECT s.store_id, DATE(r.rental_date) AS day, COUNT(r.rental_id), SUM(p.amount) 
FROM payment p 
JOIN rental r ON p.rental_id = r.rental_id
JOIN inventory i ON i.inventory_id = r.inventory_id
JOIN store s ON s.store_id=i.store_id
WHERE s.store_id=1
GROUP BY s.store_id, day;
