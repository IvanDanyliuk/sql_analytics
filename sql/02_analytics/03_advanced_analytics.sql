-- 1. Monthly revenue and running total
WITH monthly_revenue AS (
  SELECT
    DATE_TRUNC('month', o.order_date)::date AS order_month,
    ROUND(SUM(od.unit_price * od.quantity * (1 - od.discount))::numeric, 2) AS monthly_revenue
  FROM orders o
  JOIN order_details od
  ON o.order_id = od.order_id
  GROUP BY DATE_TRUNC('month', o.order_date)::date
)
SELECT 
  order_month,
  monthly_revenue,
  SUM(monthly_revenue) OVER(ORDER BY order_month ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_total_revenue
FROM monthly_revenue
ORDER BY order_month;

-- 2. Top-2 most expensive products per category
WITH product_ranking AS (
  SELECT
    p.product_id,
    c.category_id,
    c.category_name,
    p.product_name,
    p.unit_price,
    DENSE_RANK() OVER(PARTITION BY p.category_id ORDER BY p.unit_price DESC) AS product_rank
  FROM products p
  JOIN categories c
  ON p.category_id = c.category_id
)
SELECT
  *
FROM product_ranking
WHERE product_rank IN(1, 2)
ORDER BY category_name, product_rank, product_name;

-- 3. Days between repeat purchases
WITH orders_with_lag AS (
  SELECT
    customer_id,
    order_id,
    order_date,
    LAG(order_date) OVER(PARTITION BY customer_id ORDER BY order_date, order_id) AS previous_order_date
  FROM orders
),
order_intervals AS (
  SELECT
    customer_id,
    order_id,
    order_date,
    previous_order_date,
    (order_date - previous_order_date) AS days_since_last_order
  FROM orders_with_lag
  WHERE previous_order_date IS NOT NULL
)
SELECT
  c.customer_id,
  c.company_name,
  COUNT(oi.order_id) + 1 AS total_orders,
  ROUND(AVG(oi.days_since_last_order), 1) AS avg_days_between_orders,
  MIN(oi.days_since_last_order) AS min_days_between_orders,
  MAX(oi.days_since_last_order) AS max_days_between_orders
FROM order_intervals oi
JOIN customers c
ON oi.customer_id = c.customer_id
GROUP BY c.customer_id, c.company_name
ORDER BY avg_days_between_orders ASC;