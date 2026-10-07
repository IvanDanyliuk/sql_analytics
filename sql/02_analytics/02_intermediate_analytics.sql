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