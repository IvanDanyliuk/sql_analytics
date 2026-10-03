-- 1. CREATE TABLES
-- 1.1. Reference tables 
CREATE TABLE categories (
  category_id   INT PRIMARY KEY,
  category_name VARCHAR(50) NOT NULL,
  description   TEXT
);

CREATE TABLE customers (
  customer_id VARCHAR(5) PRIMARY KEY,
  company_name VARCHAR(100) NOT NULL,
  contact_name  VARCHAR(100),
  contact_title VARCHAR(50),
  city  VARCHAR(50),
  country VARCHAR(50)
);

CREATE TABLE shippers (
  shipper_id INT PRIMARY KEY,
  company_name  VARCHAR(100) NOT NULL
);


-- 1.2. Employees
CREATE TABLE employees (
  employee_id   INT PRIMARY KEY,
  employee_name   VARCHAR(100) NOT NULL,
  title   VARCHAR(50),
  city    VARCHAR(50),
  country VARCHAR(50),
  reports_to  INT,
  CONSTRAINT  fk_employees_reports_to
    FOREIGN KEY (reports_to) REFERENCES employees(employee_id)
);


-- 1.3. Products
CREATE TABLE products (
  product_id  INT PRIMARY KEY,
  product_name  VARCHAR(100) NOT NULL,
  quantity_per_unit   VARCHAR(50),
  unit_price NUMERIC(10, 2),
  discontinued SMALLINT DEFAULT 0,
  category_id INT,
  CONSTRAINT fk_products_categories 
    FOREIGN KEY (category_id) REFERENCES categories(category_id)
);


-- 1.4. Orders
CREATE TABLE orders (
  order_id INT PRIMARY KEY,
  customer_id VARCHAR(5),
  employee_id INT,
  order_date DATE,
  required_date DATE,
  shipped_date DATE,
  shipper_id INT,
  freight NUMERIC(10, 2) DEFAULT 0,
  CONSTRAINT fk_orders_customers
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
  CONSTRAINT fk_orders_employees 
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id),
  CONSTRAINT fk_orders_shippers 
    FOREIGN KEY (shipper_id) REFERENCES shippers(shipper_id)
);


-- 1.5. Order Details
CREATE TABLE order_details (
  order_id INT NOT NULL,
  product_id INT NOT NULL,
  unit_price NUMERIC(10, 2) DEFAULT 0,
  quantity SMALLINT NOT NULL DEFAULT 0,
  discount NUMERIC(10, 2) DEFAULT 0,
  PRIMARY KEY (order_id, product_id),
  CONSTRAINT fk_order_details_orders 
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
  CONSTRAINT fk_order_details_products 
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);


-- 2. PASTE DATA TO CREATED TABLES
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