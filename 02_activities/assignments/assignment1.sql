-- SELECT
--Question 1
SELECT * FROM customer;

--Question 2
SELECT * FROM customer ORDER BY customer_last_name ASC LIMIT 10

-- WHERE
--Question 1
SELECT * FROM customer_purchases WHERE product_id = 4 OR product_id = 5

--Question 2
SELECT *, quantity*cost_to_customer_per_qty AS price FROM customer_purchases WHERE vendor_id >= 8 AND vendor_id <= 10

-- CASE
--Question 1
SELECT product_id, product_name,
CASE 
	WHEN product_qty_type = 'unit'
		THEN 'unit'
	ELSE
		'bulk' 
END AS prod_qty_type_condensed
FROM product
--Question 2
SELECT product_id, product_name,
CASE 
	WHEN product_name like '%pepper%'
		THEN 1
	ELSE
		0
END AS pepper_flag
FROM product

-- JOIN
--Question 1
SELECT *
FROM vendor
INNER JOIN vendor_booth_assignments
ON vendor.vendor_id = vendor_booth_assignments.vendor_id
ORDER BY vendor_name ASC , market_date ASC

--END