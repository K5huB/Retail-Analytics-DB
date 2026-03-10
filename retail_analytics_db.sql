CREATE DATABASE retail__analytics;
USE retail__analytics;
/*
this is an rdb containing retail
information on customers, products
purchased, customer orders and
quantitative info on orders
*/
CREATE TABLE customers (
	cust_id INT PRIMARY KEY,
    fname VARCHAR(30),
    lname VARCHAR(30),
    city VARCHAR(30),
    signup_date DATE
    );
    
CREATE TABLE products (
	prod_id INT PRIMARY KEY,
    prod_name VARCHAR(30),
    category VARCHAR(30),
    price DECIMAL(10,2)
    );
    
CREATE TABLE orders (
	order_id INT PRIMARY KEY,
    cust_id INT,
    order_date DATE
    );
    
CREATE TABLE orderItems (
	order_item_id INT PRIMARY KEY,
    order_id INT,
    prod_id INT,
    quantity INT
    );
    
INSERT INTO customers (cust_id, fname, lname, city, signup_date)
VALUES 
(1,'Alex','Johnson','New York','2023-01-10'),
(2,'Maria','Lopez','Chicago','2023-02-15'),
(3,'Chris','Kim','Seattle','2023-03-05'),
(4,'Taylor','Brown','Austin','2023-04-12'),
(5,'Jordan','White','Boston','2023-05-18'),
(6,'Sam','Green','Denver','2023-06-02'),
(7,'Olivia','Clark','San Diego','2023-06-15'),
(8,'Liam','Scott','Dallas','2023-07-01'),
(9,'Emma','Hall','Atlanta','2023-07-18'),
(10,'Noah','Adams','Phoenix','2023-08-03'),
(11,'Ava','Baker','Miami','2023-08-22'),
(12,'Ethan','Nelson','Portland','2023-09-05'),
(13,'Sophia','Carter','San Jose','2023-09-18'),
(14,'Mason','Mitchell','Detroit','2023-10-02'),
(15,'Isabella','Perez','Las Vegas','2023-10-21'),
(16,'Logan','Roberts','Nashville','2023-11-04'),
(17,'Mia','Turner','Charlotte','2023-11-18'),
(18,'Lucas','Phillips','Minneapolis','2023-12-01'),
(19,'Amelia','Campbell','Philadelphia','2023-12-12'),
(20,'James','Parker','San Antonio','2023-12-28');

INSERT INTO products (prod_id, prod_name, category, price)
VALUES
(1,'Laptop','Electronics',1200),
(2,'Wireless Mouse','Electronics',40),
(3,'Office Chair','Furniture',300),
(4,'Standing Desk','Furniture',600),
(5,'Notebook','Office Supplies',10),
(6,'Keyboard','Electronics',80),
(7,'Monitor','Electronics',350),
(8,'Desk Lamp','Furniture',45),
(9,'Printer','Electronics',250),
(10,'Backpack','Accessories',70),
(11,'Tablet','Electronics',500),
(12,'Phone Charger','Electronics',25),
(13,'Water Bottle','Accessories',20),
(14,'Planner','Office Supplies',15),
(15,'Whiteboard','Office Supplies',120),
(16,'External Hard Drive','Electronics',150),
(17,'Desk Organizer','Office Supplies',35),
(18,'Gaming Chair','Furniture',450),
(19,'Bluetooth Speaker','Electronics',120),
(20,'USB Hub','Electronics',30);

INSERT INTO orders (order_id, cust_id, order_date)
VALUES
(101,1,'2024-01-10'),
(102,2,'2024-01-15'),
(103,3,'2024-02-01'),
(104,1,'2024-02-10'),
(105,4,'2024-02-15'),
(106,5,'2024-02-22'),
(107,6,'2024-03-02'),
(108,7,'2024-03-10'),
(109,8,'2024-03-18'),
(110,9,'2024-03-25'),
(111,10,'2024-04-01'),
(112,11,'2024-04-08'),
(113,12,'2024-04-15'),
(114,13,'2024-04-22'),
(115,14,'2024-05-03'),
(116,15,'2024-05-10'),
(117,16,'2024-05-18'),
(118,17,'2024-05-25'),
(119,18,'2024-06-01'),
(120,19,'2024-06-10');

INSERT INTO orderItems (order_item_id, order_id, prod_id, quantity)
VALUES
(1,101,1,1),
(2,101,2,2),
(3,102,3,1),
(4,103,2,3),
(5,104,4,1),
(6,105,5,10),
(7,106,7,1),
(8,106,6,1),
(9,107,8,2),
(10,108,9,1),
(11,109,10,1),
(12,110,11,1),
(13,111,12,3),
(14,112,13,4),
(15,113,14,2),
(16,114,15,1),
(17,115,16,1),
(18,116,17,2),
(19,117,18,1),
(20,118,19,2),
(21,119,20,3),
(22,120,1,1),
(23,120,3,1),
(24,119,7,1);

SELECT * FROM customers;
SELECT * FROM products;
SELECT * FROM orders;
SELECT * FROM orderItems; -- each line returns all aspects of each table in the database

SELECT c.fname, c.lname, p.price * oi.quantity AS totalSpent
FROM customers c
JOIN orders o ON c.cust_id = o.cust_id
JOIN orderItems oi ON o.order_id = oi.order_id
JOIN products p ON oi.prod_id = p.prod_id; -- this block returns each customer's full name and their total amount spent

SELECT p.prod_name, SUM(oi.quantity) AS totalQuant
FROM products p
JOIN orderItems oi
ON p.prod_id = oi.prod_id
GROUP BY p.prod_name
ORDER BY totalQuant DESC
LIMIT 3; -- this block returns the quantity of each item ordered

SELECT p.category, ROUND(SUM(p.price * oi.quantity)) AS monthlyRev
FROM products p
JOIN orderItems oi
ON p.prod_id = oi.prod_id
GROUP BY p.category
ORDER BY monthlyRev DESC; -- this block returns the monthly revenue for each product category

SELECT c.cust_id, c.lname, c.fname, ROUND(SUM(p.price * oi.quantity)) AS monthlyRev
FROM customers c
JOIN orders o
	ON c.cust_id = o.cust_id
JOIN orderItems oi
	ON o.order_id = oi.order_id
JOIN products p
	ON oi.prod_id = p.prod_id
GROUP BY c.cust_id, c.lname, c.fname
HAVING monthlyRev > 1000
ORDER BY monthlyRev DESC; -- this block returns the customers with >1000 in monthly spending

SELECT c.cust_id, c.fname, c.lname, COUNT(DISTINCT o.order_id) AS ordersPlaced, ROUND(SUM(p.price * oi.quantity) / COUNT(DISTINCT o.order_id), 2) AS avgValue
FROM customers c
JOIN orders o
	ON c.cust_id = o.cust_id
JOIN orderItems oi
	ON o.order_id = oi.order_id
JOIN products p
	ON oi.prod_id = p.prod_id
GROUP BY c.cust_id, c.lname, c.fname
ORDER BY avgValue DESC; -- this block returns customer information, # of orders each placed and their avg order spending

SELECT c.city, COUNT(DISTINCT o.order_id) AS ordersPlaced, ROUND(SUM(p.price * oi.quantity) / COUNT(DISTINCT c.city), 2) AS cityTotals
FROM customers c
JOIN orders o
	ON c.cust_id = o.cust_id
JOIN orderItems oi
	ON oi.order_id = o.order_id
JOIN products p
	ON oi.prod_id = p.prod_id
GROUP BY c.city
ORDER BY cityTotals DESC; -- this block returns cities, orders placed in each city and totals in each city

SELECT o.order_id, o.order_date, c.fname, c.lname, ROUND(SUM(p.price * oi.quantity), 2) AS orderRev
FROM customers c
JOIN orders o
	ON c.cust_id = o.cust_id
JOIN orderItems oi
	ON o.order_id = oi.order_id
JOIN products p
	ON oi.prod_id = p.prod_id
GROUP BY o.order_id, o.order_date
ORDER BY order_id DESC; -- this block returns order info, client names and total order revenue

SELECT category, COUNT(DISTINCT p.category) AS categOrders, COUNT(DISTINCT oi.quantity) AS categTotals
FROM products p
JOIN orderItems oi
	on p.prod_id = oi.prod_id
GROUP BY category
ORDER BY categTotals; -- this block returns product categories, distinct category orders and total category sales