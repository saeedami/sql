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

	

