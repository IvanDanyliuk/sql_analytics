-- 1. TOP-5 most profitable products
SELECT *
FROM order_details od
LEFT JOIN products p
ON od.product_id = p.product_id
LIMIT 20;