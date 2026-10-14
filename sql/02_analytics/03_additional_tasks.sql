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

-- 7. Products per category
SELECT
  c.category_id,
  c.category_name,
  COUNT(p.product_id) AS products_number
FROM products p
JOIN categories c
ON p.category_id = c.category_id
GROUP BY c.category_id, c.category_name
ORDER BY products_number DESC;

-- 8. Active cities
SELECT 
  c.city,
  COUNT(o.order_id) AS orders_num
FROM orders o
JOIN customers c
ON o.customer_id = c.customer_id
GROUP BY c.city
HAVING COUNT(o.order_id) > 10
ORDER BY orders_num DESC;

-- 9. Manager ranking by number of orders
SELECT
  e.employee_id,
  e.employee_name,
  COUNT(o.order_id) AS orders_num
FROM orders o
JOIN employees e
ON o.employee_id = e.employee_id
GROUP BY e.employee_id, e.employee_name
ORDER BY orders_num DESC;

-- 10. Customers from Germany
SELECT
  o.order_id,
  o.order_date,
  c.company_name,
  c.country,
  c.city
FROM orders o
JOIN customers c
ON o.customer_id = c.customer_id
WHERE c.country = 'Germany'
ORDER BY o.order_date DESC;

-- 11. Top categories by products sold
SELECT 
  c.category_id,
  c.category_name,
  SUM(od.quantity) AS products_sold_by_category
FROM products p
JOIN categories c
ON p.category_id = c.category_id
JOIN order_details od
ON od.product_id = p.product_id
GROUP BY c.category_id, c.category_name
HAVING SUM(od.quantity) > 500
ORDER BY products_sold_by_category DESC;

-- 12. The most expensive product by category
WITH products_ranked_by_price_per_category AS (
  SELECT
    c.category_id,
    c.category_name,
    p.product_id,
    p.product_name,
    p.unit_price,
    DENSE_RANK() OVER(PARTITION BY c.category_id ORDER BY p.unit_price DESC) AS rank
  FROM products p
  JOIN categories c
  ON p.category_id = c.category_id
)
SELECT 
  category_id,
  category_name,
  product_id,
  product_name,
  unit_price
FROM products_ranked_by_price_per_category
WHERE rank = 1;