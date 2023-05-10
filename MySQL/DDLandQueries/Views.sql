-- Filename: Views
-- Authors: Fei Wu (040885403), Fei Lan (041055048)
-- Short description: abstract complex queries and hide data structures

DROP VIEW IF EXISTS view1;
DROP VIEW IF EXISTS view2;

/*1. A dynamic view for query 4 in the previous task
A query that displays a subset of columns with a multi-clause (predicate) WHERE statement using AND/OR*/
CREATE VIEW view1 AS 
SELECT order_number FROM orders 
WHERE customer_customer_ID = 1002 AND company_company_name = 'Arcu Vel Associates';

/*2. A materialized view for query 9 in the previous task
A query that performs an aggregate (count, min, max, sum, avg, etc.). with a GROUP BY and 
a HAVING clause*/
CREATE VIEW view2 AS
SELECT product_product_code, SUM(part_quantity_required)
FROM product_has_part
GROUP BY product_product_code
HAVING SUM(part_quantity_required) >= 10;