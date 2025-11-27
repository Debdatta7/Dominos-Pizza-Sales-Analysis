-- Database create
CREATE DATABASE dominos;

-- Table import using "Table Data Import Wizrd"

-- Table check
SELECT * FROM customers;
SELECT * FROM order_details;
SELECT * FROM orders;
SELECT * FROM pizza_types;
SELECT * FROM pizzas;

-- Column Datatype change
ALTER TABLE orders
MODIFY COLUMN order_date DATE; 

ALTER TABLE orders
MODIFY COLUMN order_time TIME;

-- Check record counts in tables.
SELECT COUNT(*) 
FROM customers;

SELECT *
FROM order_details
WHERE quantity < 1;

-- Analysis

-- Order Volume Analysis:

# 1.What is the total number of unique orders placed so far?
SELECT COUNT(DISTINCT order_id) order_count
FROM orders;

# 2.How has this order volume changed month-over-month?
WITH monthly_orders AS
	(SELECT monthname(order_date) months,
			COUNT(order_id) order_count
            FROM orders
            GROUP BY monthname(order_date))
            
SELECT months, order_count,
LAG(order_count) OVER () prev_month,
100.0 * (order_count - LAG(order_count) OVER ()) / nullif(LAG(order_count) OVER (), 0) mom_growth_pct
FROM monthly_orders;

# 3.Can we identify peak and off-peak ordering days?
SELECT dayname(order_date) days, COUNT(DISTINCT order_id) order_count
FROM orders
GROUP BY dayname(order_date)
ORDER BY order_count DESC;

# 4. Orders by Hour of the Day
# Understand peak ordering hours to optimize staffing.
SELECT hour(order_time) order_hour, COUNT(order_id) order_count
FROM orders
GROUP BY hour(order_time)
ORDER BY order_hour;

# 5. Average Pizzas Ordered per Day
# Measure daily pizza demand consistency.
SELECT round(AVG(daily_total),0) avg_pizzas
FROM 	(SELECT o.order_date, SUM(od.quantity) daily_total
		FROM order_details od JOIN orders o 
		ON od.order_id = o.order_id
		GROUP BY o.order_date) t;

-- Revenue Analysis

# 6.Total Revenue from Pizza Sales
# Calculate total revenue from all pizza sales.
SELECT round(sum(od.quantity * p.price), 2) Revenue
FROM pizzas p JOIN order_details od
ON p.pizza_id = od.pizza_id;

# 7. Top 3 Pizzas by Revenue
# Identify pizzas generating the highest revenue.
SELECT pt.name, SUM(od.quantity * p.price) revenue
FROM order_details od JOIN pizzas p ON od.pizza_id = p.pizza_id
JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.name
ORDER BY revenue DESC
LIMIT 3;

# 8. Revenue Contribution per Pizza
# Percentage contribution of each pizza to total revenue.
SELECT  pt.name, round(SUM(od.quantity * p.price), 2) revenue,
round(100 * SUM(od.quantity * p.price) /  SUM(SUM(od.quantity * p.price)) OVER (), 2) pct_contri
FROM pizzas p JOIN order_details od ON p.pizza_id = od.pizza_id
JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.name;

# 9. Cumulative Revenue Over Time
# Monthly cumulative revenue trend since launch.
SELECT date_format(o.order_date, "%Y-%m") months, 
round(SUM(od.quantity * p.price), 2) monthly_revenue,
round(SUM(SUM(od.quantity * p.price)) OVER (ORDER BY date_format(o.order_date, "%Y-%m")), 2) cumulative_revenue
FROM order_details od JOIN orders o ON od.order_id = o.order_id
JOIN pizzas p ON od.pizza_id = p.pizza_id
GROUP BY date_format(o.order_date, "%Y-%m");

# 10. Top 3 Pizzas by Category (Revenue-Based)
# Top 3 pizzas by revenue in each category.
SELECT name, category, revenue
FROM (SELECT pt.name, pt.category, round(SUM(p.price * od.quantity), 2) revenue,
	RANK() OVER (PARTITION BY pt.category ORDER BY SUM(p.price * od.quantity) DESC) rnk
	FROM pizzas p JOIN order_details od ON p.pizza_id = od.pizza_id
	JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
	GROUP BY pt.name, pt.category) ranked_pizzas
WHERE rnk <= 3
ORDER BY category, revenue DESC;

# 11. Revenue by Pizza Size
# Revenue contribution of each pizza size (S, M, L, XL, XXL).
 SELECT p.size, round(SUM(p.price * od.quantity),2) revenue,
 round(100.0 * SUM(p.price * od.quantity) / SUM(SUM(p.price * od.quantity)) OVER (), 2) contri
 FROM pizzas p JOIN order_details od
 ON p.pizza_id = od.pizza_id
 GROUP BY p.size;
 
 -- Product & Menu Analysis

# 12. Highest-Priced Pizza
# Identify the most expensive pizza on the menu.
SELECT pt.name, pt.category, p.size, p.price
FROM pizzas p JOIN pizza_types pt
ON p.pizza_type_id = pt.pizza_type_id
ORDER BY p.price DESC;

# 13. Most Common Pizza Size Ordered
# Determine the most frequently ordered pizza size.
SELECT p.size, COUNT(od.order_id) order_count
FROM order_details od JOIN pizzas p 
ON od.pizza_id = p.pizza_id
GROUP BY p.size
ORDER BY order_count DESC;

# 14. Top 5 Most Ordered Pizza Types
# Find the top 5 pizza types based on quantity sold.
 SELECT p.pizza_type_id, SUM(od.quantity) order_count
 FROM pizzas p JOIN order_details od
 ON p.pizza_id = od.pizza_id
 GROUP BY p.pizza_type_id
 ORDER BY order_count DESC
 LIMIT 5;
 
# 15. Total Quantity by Pizza Category
# Calculate total pizzas sold in each category.
SELECT pt.category, SUM(od.quantity) total_pizzas
FROM order_details od 
JOIN pizzas p ON od.pizza_id = p.pizza_id
JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.category;

# 16. Category-Wise Pizza Distribution
# Analyze category-wise sales and percentage share.
SELECT pt.category, round(SUM(od.quantity * p.price), 2) total_sales,
			round(SUM(od.quantity * p.price) * 100 /
			(SELECT SUM(od.quantity * p.price) 
			FROM order_details od JOIN pizzas p 
            ON od.pizza_id = p.pizza_id), 2) percntage
FROM order_details od JOIN pizzas p ON od.pizza_id = p.pizza_id
JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.category;



