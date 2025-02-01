--section 2
--COALESCE
---Q1
SELECT 
product_name|| ', ' || coalesce(product_size,"")|| ' (' || coalesce(product_qty_type,"UNIT" )|| ')'
FROM product;

--Windowed Functions
---Q1

SELECT customer_id,(row_number() OVER ( PARTITION by customer_id order by	market_date) )as customer_visits, market_date   FROM customer_purchases;

----Q2
WITH new_table as(
	SELECT 
	customer_id,(row_number() OVER ( PARTITION by customer_id ORDER by	market_date DESC) )as customer_visits, 
	market_date FROM customer_purchases)
SELECT customer_id,  market_date as last_visit from new_table where customer_visits=1 ;

----Q3

SELECT *,(count() OVER ( PARTITION by product_id ,customer_id) )as product_purchase_count FROM customer_purchases;

--String manipulations
---Q1

SELECT product_name, 

	CASE
		WHEN instr(product_name,'-') !=0 THEN
			replace(substr(product_name,instr(product_name,'-')+1,length(product_name)),' ','')
		ELSE
			NULL
	END
as description FROM product;

--UNION
---Q1

with date_sales as (SELECT market_date, sum(quantity*cost_to_customer_per_qty)  as sales from customer_purchases GROUP by market_date)

select max(sales) as 'min/max', market_date from date_sales
UNION
select min(sales)as 'min/max', market_date from date_sales;

--section3
--Cross Join
---Q1
WITH customers_total AS (
    SELECT COUNT(*) AS customer_count FROM customer
),
vendor_product_prices AS (
    SELECT 
        product_id,
		vendor_name, 
        original_price AS price
    FROM vendor_inventory 
    JOIN vendor ON vendor_inventory.vendor_id = vendor.vendor_id
),
result AS (
	SELECT 
		DISTINCT vendor_product_prices.vendor_name, vendor_product_prices.price * 5 * customers_total.customer_count AS total_revenue
	FROM vendor_product_prices 
	CROSS JOIN customers_total 
	ORDER BY vendor_product_prices.vendor_name, vendor_product_prices.product_id
	)
SELECT vendor_name,sum(total_revenue) from result GROUP by vendor_name;
--INSERT
---Q1
CREATE TABLE IF NOT EXISTS product_units AS
SELECT *, snapshot_timestamp
FROM product
WHERE product_qty_type = 'unit';
---Q2
INSERT INTO product_units (product_id, product_name, product_size, product_category_id, product_qty_type, snapshot_timestamp)
VALUES (7, 'Apple Pie', '10"', '3','unit', '2012-05-06 12:48:00');
--DELETE
---Q1
DELETE FROM product_units
WHERE product_name = 'Apple Pie'
AND snapshot_timestamp < (
    SELECT MAX(snapshot_timestamp)
    FROM product_units
    WHERE product_name = 'Apple Pie'
);
--UPDATE
---Q1
ALTER TABLE product_units
ADD COLUMN current_quantity INT;
