-- 1. TOP-5 most profitable products
SELECT 
  p.product_id,
  p.product_name,
  ROUND(SUM(od.unit_price * od.quantity * (1 - od.discount))::numeric, 2) AS revenue
FROM order_details od
INNER JOIN products p
ON od.product_id = p.product_id
GROUP BY 
  p.product_id, 
  p.product_name
ORDER BY revenue DESC
LIMIT 5;

-- 2. Managers efficiency
SELECT
  e.employee_id,
  e.employee_name,
  e.title,
  COUNT(DISTINCT o.order_id) AS number_of_orders_per_employee,
  ROUND(SUM(od.unit_price * od.quantity * (1 - od.discount))::numeric, 2) AS revenue_by_employee,
  ROUND((SUM(od.unit_price * od.quantity * (1 - od.discount)) / COUNT(DISTINCT o.order_id))::numeric, 2) AS avg_order_amount
FROM employees e
LEFT JOIN orders o
ON e.employee_id = o.employee_id
LEFT JOIN order_details od
ON o.order_id = od.order_id
GROUP BY 
  e.employee_id, 
  e.employee_name, 
  e.title
ORDER BY revenue_by_employee DESC;

-- 3. Sales geography
SELECT
  c.country,
  ROUND(SUM(od.unit_price * od.quantity * (1 - od.discount))::numeric, 2) AS revenue,
  COUNT(DISTINCT c.customer_id) AS unique_customers
FROM orders o
LEFT JOIN order_details od
ON o.order_id = od.order_id
LEFT JOIN customers c
ON o.customer_id = c.customer_id
GROUP BY c.country
ORDER BY revenue DESC;