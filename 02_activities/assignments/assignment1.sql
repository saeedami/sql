-- SELECT
--Question 1
SELECT * FROM customer;

--Question 2
SELECT * FROM customer ORDER BY customer_last_name ASC LIMIT 10;

-- WHERE
--Question 1
SELECT * FROM customer_purchases WHERE product_id = 4 OR product_id = 5;

--Question 2
SELECT *, quantity*cost_to_customer_per_qty AS price FROM customer_purchases WHERE vendor_id >= 8 AND vendor_id <= 10;

SELECT *, quantity*cost_to_customer_per_qty AS price FROM customer_purchases WHERE vendor_id BETWEEN 8  AND 10 ;

-- CASE
--Question 1
SELECT product_id, product_name,
CASE 
	WHEN product_qty_type = 'unit'
		THEN 'unit'
	ELSE
		'bulk' 
END AS prod_qty_type_condensed
FROM product;
--Question 2
SELECT product_id, product_name,
CASE 
	WHEN product_name like '%pepper%'
		THEN 1
	ELSE
		0
END AS pepper_flag
FROM product;

-- JOIN
--Question 1
SELECT *
FROM vendor
INNER JOIN vendor_booth_assignments
ON vendor.vendor_id = vendor_booth_assignments.vendor_id
ORDER BY vendor_name ASC , market_date ASC;

-- Aggregation
--Question 1
SELECT count(booth_number) FROM vendor_booth_assignments group by vendor_id;

--Question 2
SELECT sum(quantity*cost_to_customer_per_qty) AS total_spending, customer_last_name, customer_first_name  FROM customer INNER JOIN customer_purchases on customer.customer_id=customer_purchases.customer_id GROUP BY customer.customer_id HAVING(total_spending>2000) ORDER By customer_last_name, customer_first_name;

-- Temp Table
--Question 1
CREATE TEMP TABLE temp_new_vendor(vendor_id INT, vendor_name VARCHAR(45), vendor_type VARCHAR(45), vendor_owner_first_name VARCHAR(45), vendor_owner_last_name VARCHAR(45));
INSERT INTO temp_new_vendor (vendor_id , vendor_name , vendor_type , vendor_owner_first_name , vendor_owner_last_name ) SELECT vendor_id , vendor_name , vendor_type , vendor_owner_first_name , vendor_owner_last_name  FROM vendor;
INSERT INTO temp_new_vendor (vendor_id , vendor_name , vendor_type , vendor_owner_first_name , vendor_owner_last_name ) VALUES (10, 'Thomass Superfood Store', 'Fresh Focused', 'Thomas', 'Rosenthal');
SELECT * FROM temp_new_vendor;

-- Date
--Question 1
SELECT customer_id, strftime('%m',market_date) AS month,strftime('%Y',market_date) AS year FROM customer_purchases;

--Question 2
SELECT sum(quantity*cost_to_customer_per_qty) AS spending ,customer_id, strftime('%m',market_date) AS month,strftime('%Y',market_date) AS year FROM customer_purchases WHERE month='04' AND year='2022' GROUP BY customer_id;
