-- 1. TOP-5 most profitable products
SELECT 
  p.product_id,
  p.product_name,
  ROUND(SUM(od.unit_price * od.quantity * (1 - od.discount))::numeric, 2) AS revenue
FROM order_details od
INNER JOIN products p
ON od.product_id = p.product_id
GROUP BY p.product_id, p.product_name
ORDER BY revenue DESC
LIMIT 5;