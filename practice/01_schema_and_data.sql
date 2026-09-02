-- =========================================================
-- SQL PRACTICE DATASET: "NorthStar Retail" (E-commerce Store)
-- =========================================================
-- This models a realistic small online retail business.
-- Works in PostgreSQL / MySQL / SQLite with minor tweaks
-- (e.g. SERIAL vs AUTOINCREMENT vs INTEGER PRIMARY KEY).
-- Written here in generic/PostgreSQL-flavored SQL.
-- =========================================================
CREATE DATABASE northstar_retail;

DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS employees;

-- ---------------------------------------------------------
-- CUSTOMERS
-- ---------------------------------------------------------
CREATE TABLE customers (
    customer_id   INTEGER PRIMARY KEY,
    name          VARCHAR(100),
    email         VARCHAR(100),
    city          VARCHAR(50),
    country       VARCHAR(50),
    signup_date   DATE
);

INSERT INTO customers (customer_id, name, email, city, country, signup_date) VALUES
(1,  'Alice Sharma',    'alice@mail.com',    'Pokhara',    'Nepal',       '2023-01-15'),
(2,  'Bikash Thapa',    'bikash@mail.com',   'Kathmandu',  'Nepal',       '2023-02-10'),
(3,  'Chen Wei',        'chen@mail.com',     'Shanghai',   'China',       '2023-01-20'),
(4,  'Diana Cruz',      'diana@mail.com',    'Manila',     'Philippines', '2023-03-05'),
(5,  'Ethan Brown',     'ethan@mail.com',    'Sydney',     'Australia',   '2023-02-28'),
(6,  'Fatima Khan',     'fatima@mail.com',   'Lahore',     'Pakistan',    '2023-04-12'),
(7,  'George Miller',   'george@mail.com',   'London',     'UK',          '2023-01-08'),
(8,  'Hana Kobayashi',  'hana@mail.com',     'Tokyo',      'Japan',       '2023-05-01'),
(9,  'Ivan Petrov',     'ivan@mail.com',     'Moscow',     'Russia',      '2023-03-18'),
(10, 'Julia Novak',     'julia@mail.com',    'Prague',     'Czechia',     '2023-06-22'),
(11, 'Kiran Gurung',    'kiran@mail.com',    'Pokhara',    'Nepal',       '2023-07-01'),
(12, 'Lucas Silva',     'lucas@mail.com',    'Sao Paulo',  'Brazil',      '2023-02-14'),
(13, 'Mei Lin',         'mei@mail.com',      'Beijing',    'China',       '2023-08-09'),
(14, 'Noah Wilson',     'noah@mail.com',     'Toronto',    'Canada',      '2023-04-30'),
(15, 'Olivia Adams',    'olivia@mail.com',   'New York',   'USA',         '2023-01-25');

-- ---------------------------------------------------------
-- PRODUCTS
-- ---------------------------------------------------------
CREATE TABLE products (
    product_id      INTEGER PRIMARY KEY,
    product_name    VARCHAR(100),
    category        VARCHAR(50),
    price           NUMERIC(10,2),
    stock_quantity  INTEGER
);

INSERT INTO products (product_id, product_name, category, price, stock_quantity) VALUES
(1,  'Wireless Mouse',        'Electronics', 15.99, 200),
(2,  'Mechanical Keyboard',   'Electronics', 49.99, 120),
(3,  'USB-C Hub',             'Electronics', 25.50, 150),
(4,  '27-inch Monitor',       'Electronics', 189.99, 40),
(5,  'Bluetooth Headphones',  'Electronics', 59.99, 90),
(6,  'Yoga Mat',              'Fitness',     20.00, 300),
(7,  'Dumbbell Set 10kg',     'Fitness',     45.00, 60),
(8,  'Running Shoes',         'Fitness',     65.00, 80),
(9,  'Protein Powder 1kg',    'Fitness',     30.00, 150),
(10, 'Coffee Maker',          'Home',        75.00, 55),
(11, 'Non-stick Pan Set',     'Home',        40.00, 70),
(12, 'Air Purifier',          'Home',        120.00, 25),
(13, 'Desk Lamp',             'Home',        18.50, 200),
(14, 'Novel: The Silent Sea', 'Books',       12.99, 500),
(15, 'Cookbook: Fast Meals',  'Books',       22.00, 180),
(16, 'Notebook Set (3pk)',    'Stationery',  8.50, 400),
(17, 'Fountain Pen',          'Stationery',  14.00, 250),
(18, 'Backpack',              'Fashion',     55.00, 100),
(19, 'Sunglasses',            'Fashion',     35.00, 130),
(20, 'Wrist Watch',           'Fashion',     99.99, 45);

-- ---------------------------------------------------------
-- ORDERS
-- ---------------------------------------------------------
CREATE TABLE orders (
    order_id     INTEGER PRIMARY KEY,
    customer_id  INTEGER REFERENCES customers(customer_id),
    order_date   DATE,
    status       VARCHAR(20)  -- 'Completed', 'Cancelled', 'Pending'
);

INSERT INTO orders (order_id, customer_id, order_date, status) VALUES
(1,  1,  '2023-03-01', 'Completed'),
(2,  2,  '2023-03-03', 'Completed'),
(3,  1,  '2023-03-10', 'Completed'),
(4,  3,  '2023-03-15', 'Cancelled'),
(5,  4,  '2023-03-18', 'Completed'),
(6,  5,  '2023-03-20', 'Completed'),
(7,  6,  '2023-04-02', 'Completed'),
(8,  7,  '2023-04-05', 'Pending'),
(9,  1,  '2023-04-08', 'Completed'),
(10, 8,  '2023-04-10', 'Completed'),
(11, 9,  '2023-04-14', 'Completed'),
(12, 2,  '2023-04-16', 'Cancelled'),
(13, 10, '2023-04-20', 'Completed'),
(14, 11, '2023-04-22', 'Completed'),
(15, 3,  '2023-05-01', 'Completed'),
(16, 12, '2023-05-05', 'Completed'),
(17, 13, '2023-05-08', 'Pending'),
(18, 5,  '2023-05-10', 'Completed'),
(19, 14, '2023-05-15', 'Completed'),
(20, 15, '2023-05-18', 'Completed'),
(21, 1,  '2023-06-01', 'Completed'),
(22, 6,  '2023-06-03', 'Completed'),
(23, 7,  '2023-06-06', 'Completed'),
(24, 4,  '2023-06-10', 'Cancelled'),
(25, 8,  '2023-06-14', 'Completed'),
(26, 9,  '2023-06-18', 'Completed'),
(27, 2,  '2023-06-20', 'Completed'),
(28, 11, '2023-07-01', 'Completed'),
(29, 12, '2023-07-05', 'Completed'),
(30, 15, '2023-07-09', 'Completed');

-- ---------------------------------------------------------
-- ORDER_ITEMS  (line items within each order)
-- ---------------------------------------------------------
CREATE TABLE order_items (
    order_item_id  INTEGER PRIMARY KEY,
    order_id       INTEGER REFERENCES orders(order_id),
    product_id     INTEGER REFERENCES products(product_id),
    quantity       INTEGER,
    unit_price     NUMERIC(10,2)  -- price at time of sale
);

INSERT INTO order_items (order_item_id, order_id, product_id, quantity, unit_price) VALUES
(1,  1,  1,  2, 15.99),
(2,  1,  5,  1, 59.99),
(3,  2,  6,  1, 20.00),
(4,  2,  9,  2, 30.00),
(5,  3,  2,  1, 49.99),
(6,  4,  4,  1, 189.99),
(7,  5,  14, 3, 12.99),
(8,  5,  16, 2, 8.50),
(9,  6,  8,  1, 65.00),
(10, 6,  7,  1, 45.00),
(11, 7,  10, 1, 75.00),
(12, 8,  20, 1, 99.99),
(13, 9,  3,  2, 25.50),
(14, 9,  1,  1, 15.99),
(15, 10, 19, 2, 35.00),
(16, 11, 15, 1, 22.00),
(17, 12, 18, 1, 55.00),
(18, 13, 12, 1, 120.00),
(19, 14, 13, 3, 18.50),
(20, 15, 5,  1, 59.99),
(21, 16, 17, 4, 14.00),
(22, 17, 11, 1, 40.00),
(23, 18, 9,  1, 30.00),
(24, 18, 6,  2, 20.00),
(25, 19, 2,  1, 49.99),
(26, 20, 4,  1, 189.99),
(27, 21, 1,  3, 15.99),
(28, 22, 8,  1, 65.00),
(29, 23, 20, 1, 99.99),
(30, 24, 14, 2, 12.99),
(31, 25, 5,  2, 59.99),
(32, 26, 3,  1, 25.50),
(33, 27, 16, 5, 8.50),
(34, 28, 7,  1, 45.00),
(35, 29, 10, 1, 75.00),
(36, 30, 19, 1, 35.00),
(37, 30, 18, 1, 55.00);

-- ---------------------------------------------------------
-- EMPLOYEES  (for self-join / hierarchy practice)
-- ---------------------------------------------------------
CREATE TABLE employees (
    employee_id  INTEGER PRIMARY KEY,
    name         VARCHAR(100),
    department   VARCHAR(50),
    manager_id   INTEGER,          -- references employee_id (nullable for top boss)
    salary       NUMERIC(10,2),
    hire_date    DATE
);

INSERT INTO employees (employee_id, name, department, manager_id, salary, hire_date) VALUES
(1, 'Rita Adhikari',   'Executive',  NULL, 120000, '2019-01-10'),
(2, 'Sam Lowe',        'Sales',      1,    75000,  '2020-03-15'),
(3, 'Tara Basnet',     'Sales',      2,    52000,  '2021-06-01'),
(4, 'Umesh Karki',     'Sales',      2,    54000,  '2021-07-20'),
(5, 'Vera Long',       'Marketing',  1,    70000,  '2020-05-11'),
(6, 'Wendy Poon',      'Marketing',  5,    48000,  '2022-01-05'),
(7, 'Xavier Ortiz',    'Engineering',1,    98000,  '2019-11-01'),
(8, 'Yash Rai',        'Engineering',7,    65000,  '2021-02-14'),
(9, 'Zoe Kim',         'Engineering',7,    67000,  '2022-08-19'),
(10,'Aarav Shrestha',  'Engineering',7,    62000,  '2023-01-09');








-- Q1. List all customers based in Nepal, with their city.
SELECT * FROM customers;

SELECT name, city
FROM customers
WHERE country="Nepal";


-- Q2. Find all products priced under $20, cheapest first.
SELECT * FROM products;

SELECT product_name, price
FROM products
WHERE price < 20
ORDER BY price asc;

-- What product categories do we sell?
SELECT  DISTINCT category
FROM products;

-- Q4. What are the 5 most expensive products?
SELECT product_name, price
FROM products
ORDER BY price DESC LIMIT 5;

-- Q5. How many orders have actually been completed (not cancelled or pending)?
SELECT * FROM orders;
SELECT COUNT(status)
FROM orders
WHERE status = "Completed";

-- Q6. Which customers signed up in January or February 2023?
SELECT * FROM customers;
SELECT name, email, signup_date
FROM customers
WHERE signup_date between '2023-01-01' AND '2023-02-28';

-- Q7. Find every product whose name mentions "Set" (bundles).
SELECT * FROM products;
SELECT product_name
FROM products
WHERE product_name LIKE '%SET%';

-- Q8. List all Books and Stationery products.
SELECT product_name, category
FROM products
WHERE category IN ('Books', 'Stationery');


-- Q9. How many orders has each customer placed?
SELECT * FROM customers;
SELECT * FROM orders;

SELECT c.name, COUNT(o.order_id) as total_orders
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name
ORDER BY total_orders;

-- Q10. What's the total value of each completed order?
SELECT o.order_id , SUM(ot.quantity * ot.unit_price) as total_value
FROM orders o
JOIN order_items ot ON o.order_id = ot.order_id
WHERE o.status = "Completed"
GROUP BY o.order_id
order by total_value; 


-- Q11. Which product category earns the most revenue?
SELECT * FROM products;
SELECT p.category, SUM(ot.unit_price * ot.quantity) as total_revenue
FROM products as p
JOIN order_items as ot ON p.product_id = ot.product_id
JOIN orders as o ON o.order_id = ot.order_id
WHERE status = "Completed"
GROUP BY p.category
ORDER BY total_revenue DESC;

-- Q11. Which customers have never placed an order?
SELECT c.name
FROM customers as c
LEFT JOIN orders as o ON c.customer_id = o.customer_id
WHERE o.order_id is null;

-- Q13. Which customers have an average completed-order value above $100?

SELECT o.customer_id, o.status, SUM(ot.unit_price * ot.quantity) as total_cost
FROM  orders as o
JOIN order_items as ot ON o.order_id = ot.order_id
WHERE status = "COMPLETED"
GROUP BY o.customer_id
ORDER BY total_cost DESC;

SELECT c.name, AVG(t.total_cost) as avg_total_cost
FROM customers as c
JOIN (
SELECT o.customer_id, o.status, SUM(ot.unit_price * ot.quantity) as total_cost
FROM  orders as o
JOIN order_items as ot ON o.order_id = ot.order_id
WHERE status = "COMPLETED"
GROUP BY o.customer_id, o.order_id
ORDER BY o.customer_id DESC) as t ON c.customer_id = t.customer_id
GROUP BY c.customer_id, c.name
HAVING AVG(total_cost) > 100
ORDER BY avg_total_cost desc;


-- Q14. Which products have never actually sold?
SELECT p.product_name
FROM products as p
LEFT JOIN order_items as ot ON p.product_id = ot.product_id
WHERE ot.order_item_id = NULL;


-- Q15. What's the headcount and average salary per department?

SELECT department, COUNT(*) as headhount, ROUND(AVG(salary), 2) as avg_salary 
FROM employees
GROUP BY department
ORDER BY avg_salary DESC;


-- Q16. What percentage of orders were cancelled vs. completed vs. pending?
SELECT status, COUNT(*) as orders,(COUNT(*)/ (SELECT count(*) FROM ORDERS)) *100 as perct
FROM orders
GROUP BY status
ORDER BY perct desc;


-- Q17. Rank customers by total spend.
SELECT c.name, SUM(ot.quantity * ot.unit_price) as total_spend,
RANK() OVER (ORDER BY SUM(ot.quantity * ot.unit_price) DESC) as spend_rank
FROM customers as c
JOIN orders as o ON c.customer_id = o.customer_id
JOIN order_items as ot ON o.order_id = ot.order_id
WHERE o.status = "Completed"
GROUP BY c.customer_id, c.name
ORDER BY spend_rank;


-- Q18. Show monthly revenue and a running (cumulative) total across the year.
SELECT month(o.order_date) as d_ate,
SUM(ot.quantity * ot.unit_price) as monthy_revenue,
SUM(SUM(ot.quantity * ot.unit_price)) OVER (ORDER BY month(o.order_date)) as running_total
FROM orders as o
JOIN order_items as ot ON o.order_id = ot.order_id
GROUP BY d_ate
ORDER BY d_ate;



-- Q19. What are the top 2 best-selling products in each category?
WITH product_revenue as (
SELECT p.category, p.product_name, SUM(ot.quantity * ot.unit_price) as total_revenue
FROM products as p
JOIN order_items as ot ON p.product_id = ot.product_id
JOIN orders as o ON ot.order_id = o.order_id
WHERE o.status = "Completed"
GROUP BY p.category, p.product_name),
ranked as (
SELECT *,
RANK() OVER (PARTITION BY category ORDER BY total_revenue DESC) as rnk
FROM product_revenue)
SELECT category, product_name, total_revenue, rnk
FROM ranked
WHERE rnk <= 2
ORDER BY category, rnk;


-- Q22. Which customers spent more than the average customer (completed orders only)?

WITH spends as(
SELECT c.customer_id, c.name, sum(ot.quantity * ot.unit_price) as total_spend
FROM customers as c
JOIN orders as o ON o.customer_id = c.customer_id
JOIN order_items as ot ON ot.order_id = o.order_id
WHERE o.status = "Completed"
GROUP BY c.customer_id, c.name)

SELECT customer_id, name, total_spend
FROM spends
WHERE total_spend > (SELECT AVG(total_spend) FROM spends)
ORDER BY total_spend DESC;


-- Q20. Find any employees who earn more than their own manager.
SELECT * from employees;

SELECT e.name as employee, e.department, e.salary, m.name as manager, m.department, m.salary
FROM employees as e
JOIN employees as m ON e.employee_id = m.employee_id
WHERE e.salary > m.salary;

-- Q21. What share of customers placed more than one completed order (repeat-purchase rate)?
WITH order_count as (
SELECT customer_id, COUNT(*) as n
FROM orders
WHERE status = "Completed"
GROUP BY customer_id)
SELECT
(SUM(CASE WHEN n > 1 THEN 1 ELSE 0 END) / COUNT(*)) * 100 AS perc
FROM order_count;

-- Q23 (bonus — no window functions). Find the second-most-expensive product in each category.
SELECT category, product_name, price
FROM products p1
WHERE 1 = (
SELECT COUNT(*)
FROM products as p2
WHERE p1.category = p2.category and p2.price > p1.price
)
ORDER BY category;


