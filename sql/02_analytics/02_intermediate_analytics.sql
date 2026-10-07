-- 1. Average order processing and dispatch time
SELECT
  s.shipper_id,
  s.company_name,
  COUNT(o.order_id) AS orders_by_company,
  ROUND(AVG(o.shipped_date::date - o.order_date::date), 0) AS avg_order_delay,
  MAX(o.shipped_date::date - o.order_date::date) AS max_order_delay
FROM orders o
INNER JOIN shippers s
ON o.shipper_id = s.shipper_id
WHERE o.shipped_date IS NOT NULL
GROUP BY s.shipper_id, s.company_name
ORDER BY orders_by_company DESC;

-- 2. Churn and inactive customers
WITH customer_orders AS (
  SELECT
    c.customer_id,
    c.company_name,
    c.country,
    COUNT(o.order_id) AS orders_by_customer
  FROM customers c
  LEFT JOIN orders o
  ON c.customer_id = o.customer_id
  GROUP BY 
    c.customer_id, 
    c.company_name, 
    c.country
)
SELECT
  customer_id,
  company_name,
  country,
  CASE
    WHEN orders_by_customer = 0 THEN 'Passive customer (zero-orders)'
    WHEN orders_by_customer = 1 THEN 'One-time customer (1 order)'
    ELSE 'Regular customer'
  END AS customer_segment
FROM customer_orders
ORDER BY orders_by_customer DESC;

-- 3. Products priced above category average
WITH category_avg_prices AS (
  SELECT
    category_id,
    ROUND(AVG(unit_price)::numeric, 2) AS avg_category_price
  FROM products
  GROUP BY category_id
)
SELECT
  p.product_id,
  p.product_name,
  c.category_name,
  p.unit_price,
  cap.avg_category_price,
  ROUND((p.unit_price -cap.avg_category_price)::numeric, 2) AS price_difference
FROM products p
INNER JOIN categories c
ON p.category_id = c.category_id
INNER JOIN category_avg_prices cap
ON c.category_id = cap.category_id
WHERE p.unit_price > cap.avg_category_price
ORDER BY c.category_name, p.unit_price DESC;