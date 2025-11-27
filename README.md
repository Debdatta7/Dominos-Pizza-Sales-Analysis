![bg](

📌 Project Overview

This project focuses on analyzing Domino’s Pizza sales data using SQL to uncover trends in customer behavior, order patterns, pricing, and revenue distribution.
The analysis demonstrates the use of aggregations, joins, CTEs, window functions, ranking functions, and date/time operations for real-world business insights.


🎯 Objectives

Database Setup – Create and populate tables for orders, order details, pizzas, pizza types, and customers.

Data Cleaning – Identify and remove null or inconsistent records.

Exploratory Analysis – Study order trends, customer behavior, and product performance.

Business Analysis – Answer stakeholder-driven questions to support decision-making.


🗂️ Database Structure

The project uses a relational schema consisting of:

orders – order-level information (order_id, custId, date & time)

order_details – details of items per order

pizzas – pizza variations with size & price

pizza_types – pizza name and category

customers – customer demographics


🧰 Techniques Used

SQL features applied include:

JOIN, GROUP BY, HAVING

CTE for modular queries

Window functions (LAG, running totals, ranking)

Date & time functions (DAYNAME, HOUR)


📊 Analysis & Key Insights
1️⃣ Order Volume

Total unique orders computed using: COUNT(DISTINCT order_id)

Monthly trends evaluated with window functions (LAG)

Insight: Seasonal spikes observed during festive periods.


2️⃣ Peak Ordering Days

Weekend orders (Fri–Sat) dominate.

Stronger customer engagement on weekends.


3️⃣ Total Revenue

Calculated using SUM(quantity * price)

Acts as baseline for category- and product-level comparisons.


4️⃣ Highest-Priced Pizza

Identified using ORDER BY price DESC

Premium large pizzas—especially Supreme & Classic Deluxe—top the pricing tier.


5️⃣ Most Common Pizza Size

Medium (M) and Large (L) sizes were the most ordered.

Practical implication: Stock priority for M/L sizes.


6️⃣ Top 5 Most Ordered Pizza Types

These pizzas contribute significantly to sales volume.

Indicates strong brand favorites and customer loyalty.


7️⃣ Category-Wise Performance

Top quantity categories: Classic, Veggie

Top revenue categories: Deluxe, Supreme (due to higher prices)


8️⃣ Order Timing Trends

Peak hours: 6 PM – 9 PM

Aligns with dinner timings → useful for staffing logistics.


9️⃣ Average Pizzas Ordered Per Day

Derived using average of daily totals

Helps track consistency & inventory requirements


🔟 Top Revenue-Generating Pizzas

Based on page 3 table (image):

The Thai Chicken Pizza – 43,434.25

The Barbecue Chicken Pizza – 42,768

The California Chicken Pizza – 41,409.5
Others include Classic Deluxe, Hawaiian, Pepperoni, Sicilian, etc.


1️⃣1️⃣ Revenue Distribution by Size

From the size-revenue table (page 3 image):

M: 30.49%

L: 45.89%

S: 21%

XL & XXL contribute < 2%


1️⃣2️⃣ Cumulative Revenue Trend

As shown in the monthly cumulative chart (page 3):

Revenue rises steadily across the year.

Clear spikes during promotional periods.


📈 Sample Output Visuals (from report)
🔹 Top Revenue Pizzas (Page 3)

Table includes revenue for top-selling pizzas such as Thai Chicken, Barbecue Chicken, Classic Deluxe, etc.

🔹 Revenue Distribution by Size (Page 3)

Shows % contribution of each pizza size (M, L, S, XL, XXL).

🔹 Cumulative Monthly Revenue (Page 3)

Displays month-by-month running total for 2015.

💡 Business Recommendations

Based on insights observed across the analysis:

Promote peak-hour offers (6–9 PM) to maximize revenue.

Inventory optimization: Prioritize Medium & Large pizzas.

Boost high-margin categories: Deluxe & Supreme pizzas.

Seasonal campaigns: Target historically high-order months.

Customer retention: Reward frequent buyers of top-selling pizzas.
