/*1.Cities in Argentina*/
SELECT  city.city AS "City"
FROM city
INNER JOIN country USING (country_id)
WHERE country.country='Argentina';

/*2.Number of Cities per Country*/
SELECT country.country AS "Country", COUNT(city.city_id) AS "Number of cities"
FROM city
INNER JOIN country USING (country_id)
GROUP BY  country.country;

/*3.Actors last name, whose first name is MENA*/
SELECT actor.last_name AS "Actor"
FROM actor
WHERE actor.first_name='MENA';

/*4.Actors first and last name, whose last name starts with MO*/
SELECT actor.first_name AS "First Name", actor.last_name AS "Last Name"
FROM actor
WHERE actor.last_name LIKE 'MO%';

/*5.Staffs email leaving in city Lethbridge*/
SELECT staff.email AS "E-mail"
FROM staff
INNER JOIN address USING (address_id)
INNER JOIN city USING (city_id)
WHERE city.city='Lethbridge';

/*6.Addresses name (in district Andhra Pradesh with postal code 75474 or 40899) or in city Tarsus*/
SELECT address.address AS "Address"
FROM address
INNER JOIN citY USING (city_id)
WHERE address.district='Andhra Pradesh' AND address.postal_code IN ('75474', '40899') OR city.city='Tarsus';

/*7.Addresses name in district Alberta without a postal code*/
SELECT address.address AS "Address"
FROM address
WHERE address.postal_code IS NULL AND address.district='Alberta';

/*8.Addresses name in district Alberta without a postal code and without a phone number*/
SELECT address.address AS "Address"
FROM address
WHERE address.district='Alberta' AND address.postal_code IS NULL AND address.phone IS NULL;

/*9.Rentals datetime for the customers with id 459, 408, 549, 269, 37, 44, 535*/
SELECT rental.rental_date AS "Date"
FROM rental
INNER JOIN customer USING (customer_id)
WHERE customer.customer_id IN ('459','408', '549', '269', '37', '44', '535');

/*10.Number of rentals that never returned to a store*/
SELECT COUNT(rental.rental_id) AS "Not Returned"
FROM rental
WHERE rental.return_date IS NULL;

/*11.Number of rentals returned the same day*/
SELECT COUNT(rental.rental_id) AS "Retuned", rental.rental_date AS "Date"
FROM rental
WHERE rental.return_date IS NOT NULL
ORDER BY rental.return_date;

/*12.Number of firms per rating*/
SELECT COUNT(film.film_id) AS "Films" ,film.rating AS "Rating"
FROM film
GROUP BY film.rating;

/*13.The rating with the maximum number of films*/
SELECT COUNT(film.film_id) AS "Most Films", film.rating AS "Rating"
FROM film
GROUP BY film.rating
ORDER BY film.rating DESC
LIMIT 1;

/*14.Films name and their rating with rental rate between 0 to 3 and length less or equal to 47*/
SELECT film.title AS "Film", film.rating AS "Rating"
FROM film
WHERE film.rental_rate BETWEEN 0 AND 3 AND film.length<=47;

/*15.Number of films per month, rent to a customer by the staff member Mike Hillyer on 2020*/
SELECT COUNT(rental.rental_id) AS "Films"
FROM  rental
INNER JOIN staff USING (staff_id)
WHERE staff.first_name='Mike' AND staff.last_name='Hillyer' AND YEAR(rental.rental_date)='2020'
ORDER BY MONTH(rental.rental_date) DESC;


/*16.Films title and actors full name of film's rating G or PG or PG-13 or R and film's special features contain ‘deleted
scenes’ and actor's last name length is 6 or more characters*/
SELECT film.title AS "Film", CONCAT(actor.first_name ,' ',actor.last_name) AS "Actor"
FROM film
INNER JOIN film_actor USING (film_id)
INNER JOIN actor USING (actor_id)
WHERE film.rating IN ('G','PG','PG-13','R') AND film.special_features='deleted scenes' AND LENGTH(actor.last_name)=6;

/*17.Films title and rental date and rental rate and replacement cost that are rented by inactive customers that live in
the country “Virgin Islands, U.S.”*/
SELECT film.title AS "Film", rental.rental_date AS "Date", film.rental_rate AS "Rate", film.replacement_cost AS "Cost"
FROM film
INNER JOIN inventory USING (film_id)
INNER JOIN rental USING (inventory_id)
INNER JOIN customer USING (customer_id)
INNER JOIN address USING (address_id)
INNER JOIN city USING (city_id)
INNER JOIN country USING (country_id)
WHERE customer.active = FALSE AND country.country='Virgin Islands, U.S.';

/*18.Customer's full name with maximum number of rentals*/
SELECT CONCAT(first_name,' ',last_name) AS "Full Name"
FROM customer
INNER JOIN rental USING (customer_id)
GROUP BY rental.customer_id
ORDER BY COUNT(rental.customer_id) DESC
LIMIT 1;

/*19.Customer's full name with maximum amount of the total payments*/
SELECT CONCAT(first_name,' ',last_name) AS "Full Name"
FROM customer
INNER JOIN payment USING (customer_id)
GROUP BY payment.customer_id
ORDER BY SUM(payment.amount) DESC
LIMIT 1;

/*20.Number of unique customers that returned a film in 5 days or more*/
SELECT DISTINCT COUNT(customer.customer_id) AS "Number of customers"
FROM customer
INNER JOIN rental USING (customer_id)
WHERE rental.return_date > (SELECT DATE_ADD(rental.rental_date, INTERVAL 5 DAY));

/*21.Films title rent by customer with last name Williams*/
SELECT film.title AS "Film"
FROM film
INNER JOIN inventory USING (film_id)
INNER JOIN rental USING (inventory_id)
INNER JOIN customer USING (customer_id)
WHERE customer.last_name='Williams';

/*22.Total length of the unique films rent by customers whose first name start with G and the returned date happened
on the first 6 months of 2020*/
SELECT DISTINCT SUM(film.length) AS "Total Length"
FROM film
INNER JOIN inventory USING (film_id)
INNER JOIN rental USING (inventory_id)
INNER JOIN customer USING (customer_id)
WHERE customer.first_name LIKE 'G%' /*AND rental.return_date BETWEEN '01-01-2020' AND '30-06-2020'*/;


/*23.Films title that actor's first name matches the customer's first name rent a film*/
SELECT film.title AS "Film"
FROM film
WHERE EXISTS (SELECT actor.actor_id FROM actor
INNER JOIN film_actor ON actor.actor_id=film_actor.actor_id
INNER JOIN film ON film_actor.film_id=film.film_id
INNER JOIN inventory ON film.film_id=inventory.film_id
INNER JOIN store ON inventory.store_id=store.store_id
INNER JOIN customer ON store.store_id=customer.store_id
WHERE actor.first_name=customer.first_name);

/*24.Total number of rentals and total amount of rentals per store id, store city, film’s category name for the whole year
2020 per month name*/
SELECT SUM(payment.amount) AS "Total amount of rentals", COUNT(rental.rental_id) AS "Number of rentals",
store.store_id AS "Store", city.city AS "City", MONTH(rental.rental_date) AS "Month", category.name AS "Category"
FROM payment
INNER JOIN rental USING (rental_id)
INNER JOIN inventory USING (inventory_id)
INNER JOIN store USING (store_id)
INNER JOIN address USING (address_id)
INNER JOIN city USING (city_id),
film, film_category, category
WHERE inventory.film_id=film.film_id AND film.film_id=film_category.film_id AND film_category.category_id=category.category_id
/*AND YEAR(rental.rental_date) = '2020'*/
GROUP BY store.store_id,
city.city,
category.name
ORDER BY MONTH(rental.rental_date) ASC;

/*25.Store id and store city with the maximum amount of rentals for each film’s category name for the whole year 2020
per month name*/
SELECT store.store_id AS "Store", city.city AS "City", COUNT(rental.rental_id) AS "Total Rentals", MONTH(rental.rental_date) AS "Month",
category.name AS "Category"
FROM city
INNER JOIN address USING (city_id)
INNER JOIN store USING (address_id)
INNER JOIN inventory USING (store_id)
INNER JOIN rental USING (inventory_id),
film, film_category, category
WHERE inventory.film_id = film.film_id AND film.film_id = film_category.film_id AND film_category.category_id = category.category_id
/*AND YEAR(rental.rental_date) = '2020'*/
GROUP BY (SELECT MAX("Total Rentals") LIMIT 1),
category.name
ORDER BY MONTH(rental.rental_date) ASC;
