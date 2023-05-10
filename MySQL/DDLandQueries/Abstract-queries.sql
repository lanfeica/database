-- Filename: Abstract
-- Authors: Fei Wu (040885403), Fei Lan (041055048)
-- Short description: abstract data based on queries

/*1. A simple query that pulls all columns and rows from a table*/
SELECT * FROM customer;

/*2. A query that displays a subset of columns*/
SELECT customer_name FROM customer;

/*3. A query that displays a subset of columns with a single clause (predicate) WHERE statement*/
SELECT order_number FROM orders WHERE customer_customer_ID = 1002;

/*4. A query that displays a subset of columns with a multi-clause (predicate) 
WHERE statement using AND/OR*/
SELECT order_number FROM orders 
WHERE customer_customer_ID = 1002 AND company_company_name = 'Arcu Vel Associates';

/*5. A query that performs a single table join. In other words, you are joining 2 tables.*/
SELECT order_number, customer_name
FROM orders INNER JOIN customer ON orders.customer_customer_ID = customer.customer_ID;

/*6. A query that performs a multi-table join. In other words, you are joining 3 or more tables.*/
SELECT order_number, customer_name, company_name
FROM orders INNER JOIN customer ON customer.customer_ID = orders.customer_customer_ID
			INNER JOIN company ON company.company_name = orders.company_company_name;

/*7. A query that performs an aggregate (count, min, max, sum, avg, etc.).*/
SELECT COUNT(standard_price), MIN(standard_price), MAX(standard_price), SUM(standard_price), 
AVG(IFNULL(standard_price,0)) FROM product;

/*8. A query that performs an aggregate (count, min, max, sum, avg, etc.) with a GROUP BY.*/
SELECT product_product_code, SUM(part_quantity_required)
FROM product_has_part
GROUP BY product_product_code;

/*9. A query that performs an aggregate (count, min, max, sum, avg, etc.). with a GROUP BY and 
a HAVING clause*/
SELECT product_product_code, SUM(part_quantity_required)
FROM product_has_part
GROUP BY product_product_code
HAVING SUM(part_quantity_required) >= 10;

/*10. A query that performs a subquery either as part of the WHERE clause or as a derived/virtual 
table.*/
SELECT order_number, customer_name
FROM orders INNER JOIN customer ON orders.customer_customer_ID = customer.customer_ID
WHERE (SELECT customer.customer_ID WHERE customer.customer_name = 'Chava Page');

/*11. A query that performs an aggregate with a join and a group by.*/
SELECT company_name, COUNT(order_number)
FROM orders INNER JOIN company ON company.company_name = orders.company_company_name
GROUP BY company_name;