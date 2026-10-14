-- 1. Orders from 2015
SELECT
  o.order_id,
  c.company_name,
  e.employee_name,
  o.order_date
FROM orders o
JOIN customers c
ON o.customer_id = c.customer_id
JOIN employees e
ON o.employee_id = e.employee_id
WHERE EXTRACT(YEAR FROM o.order_date) = 2015;

-- 2. Active customers
SELECT
  o.customer_id,
  c.company_name,
  COUNT(o.order_id) AS orders_by_customer
FROM orders o
JOIN customers c
ON o.customer_id = c.customer_id
GROUP BY o.customer_id, c.company_name
HAVING COUNT(o.order_id) > 10
ORDER BY orders_by_customer DESC;

-- 3. The cheapest item of the category
WITH ranked_products AS (
  SELECT
    c.category_id,
    c.category_name,
    p.product_id,
    p.product_name,
    p.unit_price,
    ROW_NUMBER() OVER(PARTITION BY p.category_id ORDER BY p.unit_price ASC) AS product_rank
  FROM products p
  JOIN categories c
  ON p.category_id = c.category_id
)
SELECT
  category_name,
  product_id,
  product_name,
  unit_price
FROM ranked_products
WHERE product_rank = 1;

-- 4. Average freight price
SELECT
  s.shipper_id,
  s.company_name,
  ROUND(AVG(o.freight)::numeric, 2) AS avg_freight_price
FROM orders o
JOIN shippers s
ON o.shipper_id = s.shipper_id
GROUP BY s.shipper_id, s.company_name
ORDER BY avg_freight_price DESC;

-- 5. Popular categories
SELECT
  c.category_id,
  c.category_name,
  COUNT(p.product_id) AS product_number
FROM categories c
JOIN products p
ON c.category_id = p.category_id
GROUP BY c.category_id, c.category_name
HAVING COUNT(p.product_id) > 8
ORDER BY product_number DESC;

-- 6. Products that are more expensive than the average market price
SELECT
  product_id,
  product_name,
  unit_price
FROM products
WHERE unit_price > (
  SELECT AVG(unit_price) FROM products
)
ORDER BY unit_price DESC;
