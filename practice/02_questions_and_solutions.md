# SQL Practice: From Beginner to Advanced
### Dataset: "NorthStar Retail" — an e-commerce business

This uses one dataset throughout (see `01_schema_and_data.sql`) so you build a mental model of one real business instead of jumping between toy tables.

## The tables

| Table | What it holds |
|---|---|
| `customers` | id, name, email, city, country, signup_date |
| `products` | id, name, category, price, stock_quantity |
| `orders` | id, customer_id, order_date, status (Completed/Cancelled/Pending) |
| `order_items` | line items — order_id, product_id, quantity, unit_price |
| `employees` | id, name, department, manager_id (self-referencing), salary, hire_date |

Load `01_schema_and_data.sql` into PostgreSQL, MySQL, or SQLite (sqlite3 works with zero changes) and run every query below as you go. All queries here have been executed against the dataset, and the sample output is real — not made up.

---

## LEVEL 1 — BEGINNER
*Goal: comfort with SELECT, filtering, sorting, and basic aggregates.*

### Q1. List all customers based in Nepal, with their city.
**Real-world use:** a regional manager wants a contact list for a local marketing push.

```sql
SELECT name, city
FROM customers
WHERE country = 'Nepal';
```
**Explanation:** `WHERE` filters rows before anything is returned. String comparisons are case-sensitive in most engines, so `'Nepal'` must match exactly.

**Result:** Alice Sharma (Pokhara), Bikash Thapa (Kathmandu), Kiran Gurung (Pokhara).

---

### Q2. Find all products priced under $20, cheapest first.
**Real-world use:** building a "budget picks" section on the storefront.

```sql
SELECT product_name, price
FROM products
WHERE price < 20
ORDER BY price ASC;
```
**Explanation:** `ORDER BY ... ASC` sorts ascending (the default — you could omit `ASC`). Filtering happens before sorting.

---

### Q3. What product categories do we sell?
**Real-world use:** populating a navigation menu's category dropdown.

```sql
SELECT DISTINCT category
FROM products;
```
**Explanation:** `DISTINCT` removes duplicate values. Without it you'd get one row per product, with categories repeating.

---

### Q4. What are the 5 most expensive products?
**Real-world use:** a "premium collection" banner for the homepage.

```sql
SELECT product_name, price
FROM products
ORDER BY price DESC
LIMIT 5;
```
**Explanation:** `LIMIT` caps the row count. Always pair it with `ORDER BY` — an unordered `LIMIT` gives you an arbitrary 5 rows, not the top 5.

---

### Q5. How many orders have actually been completed (not cancelled or pending)?
**Real-world use:** a KPI dashboard tile: "Orders Fulfilled."

```sql
SELECT COUNT(*) AS completed_orders
FROM orders
WHERE status = 'Completed';
```
**Result:** 25.
**Explanation:** `COUNT(*)` counts rows matching the filter. Aliasing with `AS` gives the output column a readable name — important once this feeds a dashboard or report.

---

### Q6. Which customers signed up in January or February 2023?
**Real-world use:** identifying your "early cohort" for a loyalty-reward email.

```sql
SELECT name, signup_date
FROM customers
WHERE signup_date BETWEEN '2023-01-01' AND '2023-02-28'
ORDER BY signup_date;
```
**Explanation:** `BETWEEN` is inclusive on both ends. For dates, always double-check the boundary values match your intended range — an off-by-one here is a classic real-world bug.

---

### Q7. Find every product whose name mentions "Set" (bundles).
**Real-world use:** tagging all bundle products for a "bundle & save" campaign.

```sql
SELECT product_name
FROM products
WHERE product_name LIKE '%Set%';
```
**Explanation:** `LIKE` with `%` wildcards matches partial text. `%Set%` matches "Set" anywhere in the string. This is the SQL equivalent of a basic search box.

---

### Q8. List all Books and Stationery products.
**Real-world use:** a "back to school" promotion spanning two categories.

```sql
SELECT product_name, category
FROM products
WHERE category IN ('Books', 'Stationery');
```
**Explanation:** `IN` is shorthand for chained `OR` conditions (`category = 'Books' OR category = 'Stationery'`). Cleaner and faster to read once you have 3+ values.

---

## LEVEL 2 — INTERMEDIATE
*Goal: combining tables with JOINs, grouping data, and reasoning about missing/related data.*

### Q9. How many orders has each customer placed?
**Real-world use:** flagging your most frequent shoppers for a loyalty program.

```sql
SELECT c.name, COUNT(o.order_id) AS total_orders
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name
ORDER BY total_orders DESC;
```
**Explanation:** The `JOIN` links each customer to their orders. `GROUP BY` collapses multiple order rows into one row per customer, and `COUNT` tallies them. Note: you group by `customer_id` (the unique key), not just `name` — two customers could theoretically share a name.

---

### Q10. What's the total value of each completed order?
**Real-world use:** generating order receipts / invoice totals.

```sql
SELECT o.order_id, SUM(oi.quantity * oi.unit_price) AS order_total
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.status = 'Completed'
GROUP BY o.order_id
ORDER BY order_total DESC;
```
**Explanation:** Each order can have several line items (rows in `order_items`), so you multiply `quantity × unit_price` per line, then `SUM` across all lines for that order. This pattern — join, compute per row, aggregate per group — covers a huge share of real reporting work.

---

### Q11. Which product category earns the most revenue?
**Real-world use:** deciding which category to feature more prominently, or negotiate better supplier terms for.

```sql
SELECT p.category, SUM(oi.quantity * oi.unit_price) AS revenue
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
JOIN orders o ON oi.order_id = o.order_id
WHERE o.status = 'Completed'
GROUP BY p.category
ORDER BY revenue DESC;
```
**Result:** Electronics ($702.37) leads, Books ($60.97) trails.
**Explanation:** A three-table join. Only `Completed` orders count as real revenue — cancelled orders shouldn't be counted, which is a very common real-world gotcha (always ask "does status/state affect whether this row should count?").

---

### Q12. Which customers have never placed an order?
**Real-world use:** targeting a "we miss you — here's 10% off" email at people who signed up but never bought anything.

```sql
SELECT c.name
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;
```
**Explanation:** `LEFT JOIN` keeps every customer row even if there's no matching order; unmatched orders show up as `NULL`. Filtering on `o.order_id IS NULL` isolates customers with zero orders. In this dataset every customer has ordered at least once — that empty result is itself the useful answer (100% of signups have converted at least once).

---

### Q13. Which customers have an average completed-order value above $100?
**Real-world use:** identifying "high-value" customers for a VIP tier.

```sql
SELECT c.name, AVG(order_totals.order_total) AS avg_order_value
FROM customers c
JOIN (
    SELECT o.order_id, o.customer_id, SUM(oi.quantity * oi.unit_price) AS order_total
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    WHERE o.status = 'Completed'
    GROUP BY o.order_id
) order_totals ON c.customer_id = order_totals.customer_id
GROUP BY c.customer_id, c.name
HAVING AVG(order_totals.order_total) > 100
ORDER BY avg_order_value DESC;
```
**Explanation:** This introduces a **subquery** (the inner `SELECT`) that first computes one row per order, which the outer query then averages per customer. `HAVING` is like `WHERE`, but it filters *after* aggregation — you can't write `WHERE AVG(...) > 100` because `WHERE` runs before `GROUP BY` produces the average.

---

### Q14. Which products have never actually sold?
**Real-world use:** dead-stock report for inventory/purchasing decisions.

```sql
SELECT p.product_name
FROM products p
LEFT JOIN order_items oi ON p.product_id = oi.product_id
WHERE oi.order_item_id IS NULL;
```
**Explanation:** Same "anti-join" pattern as Q12, applied to products instead of customers. In this dataset every product has sold at least once — which is a real, useful finding (no dead stock right now), not a broken query.

---

### Q15. What's the headcount and average salary per department?
**Real-world use:** HR budget planning / compensation benchmarking.

```sql
SELECT department, COUNT(*) AS headcount, ROUND(AVG(salary), 2) AS avg_salary
FROM employees
GROUP BY department
ORDER BY avg_salary DESC;
```
**Explanation:** No join needed here — everything lives in one table. `ROUND(x, 2)` keeps currency output clean instead of showing long decimals.

---

### Q16. What percentage of orders were cancelled vs. completed vs. pending?
**Real-world use:** operations dashboard — is our cancellation rate creeping up?

```sql
SELECT status,
       COUNT(*) AS cnt,
       ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM orders), 1) AS pct
FROM orders
GROUP BY status;
```
**Explanation:** The subquery `(SELECT COUNT(*) FROM orders)` computes the grand total once, independent of the grouping, so each status can be expressed as a share of *all* orders rather than just its own group. Using `100.0` (not `100`) forces floating-point division so you don't accidentally get integer division truncating to 0.

---

## LEVEL 3 — ADVANCED
*Goal: window functions, CTEs, self-joins, and multi-step analytical questions — the kind that show up in real analyst/BI work and SQL interviews.*

### Q17. Rank customers by total spend.
**Real-world use:** a leaderboard for a "top spender of the month" reward.

```sql
SELECT c.name,
       SUM(oi.quantity * oi.unit_price) AS total_spent,
       RANK() OVER (ORDER BY SUM(oi.quantity * oi.unit_price) DESC) AS spend_rank
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.status = 'Completed'
GROUP BY c.customer_id, c.name
ORDER BY spend_rank;
```
**Explanation:** `RANK() OVER (...)` is a **window function** — unlike `GROUP BY`, it doesn't collapse rows; it adds a computed column while keeping every row. `RANK` gives tied values the same rank and skips the next number (1, 2, 2, 4...). Use `DENSE_RANK()` instead if you want no gaps (1, 2, 2, 3...).

---

### Q18. Show monthly revenue and a running (cumulative) total across the year.
**Real-world use:** the classic "revenue growth" chart finance teams ask for every board meeting.

```sql
SELECT strftime('%Y-%m', o.order_date) AS month,
       SUM(oi.quantity * oi.unit_price) AS monthly_revenue,
       SUM(SUM(oi.quantity * oi.unit_price)) OVER (ORDER BY strftime('%Y-%m', o.order_date)) AS running_total
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.status = 'Completed'
GROUP BY month
ORDER BY month;
```
**Explanation:** `strftime('%Y-%m', ...)` buckets dates by month (in PostgreSQL use `TO_CHAR(order_date, 'YYYY-MM')` or `DATE_TRUNC('month', order_date)`; in MySQL use `DATE_FORMAT`). The outer `SUM(...) OVER (ORDER BY month)` is a running total — it adds each month's revenue to everything before it. Note the *nested aggregation*: `SUM()` computes monthly totals first via `GROUP BY`, then the window function sums those monthly sums.

---

### Q19. What are the top 2 best-selling products in each category?
**Real-world use:** deciding which 2 products per category to feature in an email campaign — a "best of each department" digest.

```sql
WITH product_revenue AS (
    SELECT p.category, p.product_name,
           SUM(oi.quantity * oi.unit_price) AS revenue
    FROM order_items oi
    JOIN products p ON oi.product_id = p.product_id
    JOIN orders o ON oi.order_id = o.order_id
    WHERE o.status = 'Completed'
    GROUP BY p.category, p.product_name
),
ranked AS (
    SELECT *,
           RANK() OVER (PARTITION BY category ORDER BY revenue DESC) AS rnk
    FROM product_revenue
)
SELECT category, product_name, revenue, rnk
FROM ranked
WHERE rnk <= 2
ORDER BY category, rnk;
```
**Explanation:** This is where CTEs (`WITH ... AS (...)`) shine — they let you break a hard problem into named, readable steps instead of one tangled query. `PARTITION BY category` is the key idea: it makes `RANK()` restart from 1 *within each category*, instead of ranking across the whole table. This "top-N per group" pattern is one of the most common real-world SQL interview questions.

---

### Q20. Find any employees who earn more than their own manager.
**Real-world use:** an HR/compensation audit flag — pay compression or inversion is worth investigating.

```sql
SELECT e.name AS employee, e.salary, m.name AS manager, m.salary AS manager_salary
FROM employees e
JOIN employees m ON e.manager_id = m.employee_id
WHERE e.salary > m.salary;
```
**Explanation:** A **self-join** — the same table joined to itself under two aliases (`e` for employee, `m` for their manager), using `manager_id` to link a row to another row in the same table. This dataset has no inversions, which is a legitimate, useful "all clear" result for an audit query.

---

### Q21. What share of customers placed more than one completed order (repeat-purchase rate)?
**Real-world use:** a core retention metric — are people coming back, or is growth all first-time buyers?

```sql
WITH order_counts AS (
    SELECT customer_id, COUNT(*) AS n
    FROM orders
    WHERE status = 'Completed'
    GROUP BY customer_id
)
SELECT
  ROUND(100.0 * SUM(CASE WHEN n > 1 THEN 1 ELSE 0 END) / COUNT(*), 1) AS pct_repeat_customers
FROM order_counts;
```
**Result:** 64.3% of purchasing customers came back for a second (or more) completed order.
**Explanation:** `CASE WHEN ... THEN 1 ELSE 0 END` turns a condition into a number you can `SUM`, a very common trick for computing rates/percentages in one query. The CTE first collapses orders down to "orders per customer," and the outer query then classifies and counts those customers.

---

### Q22. Which customers spent more than the average customer (completed orders only)?
**Real-world use:** defining an "above-average" customer segment on the fly, without hardcoding a dollar threshold that goes stale as the business grows.

```sql
WITH spend AS (
  SELECT c.customer_id, c.name, SUM(oi.quantity * oi.unit_price) AS total_spent
  FROM customers c
  JOIN orders o ON c.customer_id = o.customer_id
  JOIN order_items oi ON o.order_id = oi.order_id
  WHERE o.status = 'Completed'
  GROUP BY c.customer_id, c.name
)
SELECT name, total_spent
FROM spend
WHERE total_spent > (SELECT AVG(total_spent) FROM spend)
ORDER BY total_spent DESC;
```
**Explanation:** A **correlated-style comparison against an aggregate** — the CTE computes spend per customer once, and the outer query compares each customer to the average of that *same* CTE. This pattern (compute a metric, then compare individuals to the group average) generalizes to almost any "who's above/below average" business question.

---

### Q23 (bonus — no window functions). Find the second-most-expensive product in each category.
**Real-world use:** useful when working with an older database engine or a BI tool that doesn't support window functions.

```sql
SELECT category, product_name, price
FROM products p1
WHERE 1 = (
    SELECT COUNT(*)
    FROM products p2
    WHERE p2.category = p1.category AND p2.price > p1.price
)
ORDER BY category;
```
**Explanation:** A **correlated subquery** — for every product `p1`, it counts how many other products in the *same category* (`p2.category = p1.category`) cost more. If exactly one product beats it, `p1` is the second-highest. This is the classic "pre-window-function" way of solving ranking problems, and it's worth knowing both approaches since older systems or certain SQL dialects still lean on this style.

---

## How to keep practicing

1. Modify the dataset: add 10 more orders, a new "Toys" category, or a customer with no orders, then re-run every query above and predict the new output before running it.
2. Rewrite each `RANK()`/`PARTITION BY` query using `ROW_NUMBER()` and `DENSE_RANK()` and compare the outputs.
3. Try translating the SQLite-specific `strftime` calls into PostgreSQL (`DATE_TRUNC`) or MySQL (`DATE_FORMAT`) syntax if you plan to work in those engines.
4. Write your own question — e.g. "which country generates the most revenue?" — and solve it using the join/aggregate patterns from Level 2.
