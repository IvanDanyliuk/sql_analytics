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