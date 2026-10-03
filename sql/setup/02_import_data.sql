/*
  Since we have set up foreign keys, data must be loaded in a strict order — 
  from reference tables to dependent tables. If you attempt to load the `orders` 
  table before the `customers` table, Postgres will throw a key constraint error.
*/

COPY categories(category_id, category_name, description)
FROM 'C:\Users\ivand\OneDrive\Документы\Data Science\projects\sql-analytics\datasets\categories.csv'
DELIMITER ',' CSV HEADER;

COPY customers(customer_id, company_name, contact_name, contact_title, city, country)
FROM 'C:\Users\ivand\OneDrive\Документы\Data Science\projects\sql-analytics\datasets\customers.csv'
DELIMITER ',' CSV HEADER;

COPY shippers(shipper_id, company_name)
FROM 'C:\Users\ivand\OneDrive\Документы\Data Science\projects\sql-analytics\datasets\shippers.csv'
DELIMITER ',' CSV HEADER;

COPY employees(employee_id, employee_name, title, city, country, reports_to)
FROM 'C:\Users\ivand\OneDrive\Документы\Data Science\projects\sql-analytics\datasets\employees.csv'
DELIMITER ',' CSV HEADER;

COPY products(product_id, product_name, quantity_per_unit, unit_price, discontinued, category_id)
FROM 'C:\Users\ivand\OneDrive\Документы\Data Science\projects\sql-analytics\datasets\products.csv'
DELIMITER ',' CSV HEADER;

COPY orders(order_id, customer_id, employee_id, order_date, required_date, shipped_date, shipper_id, freight)
FROM 'C:\Users\ivand\OneDrive\Документы\Data Science\projects\sql-analytics\datasets\orders.csv'
DELIMITER ',' CSV HEADER;

COPY order_details(order_id, product_id, unit_price, quantity, discount)
FROM 'C:\Users\ivand\OneDrive\Документы\Data Science\projects\sql-analytics\datasets\order_details.csv'
DELIMITER ',' CSV HEADER;