-- ============================================================
-- 02-data-manipulation / dml.sql
-- Purpose: INSERT, UPDATE, DELETE, and UPSERT
-- ============================================================

USE sql_interview_prep;

-- ------------------------------------------------------------
-- 1. INSERT
-- ------------------------------------------------------------

INSERT INTO Departments (department_name)
VALUES ('Data Analytics');

INSERT INTO Departments (department_name)
VALUES
    ('Human Resources'),
    ('Finance'),
    ('Sales');

INSERT INTO Customers (customer_name, email, city)
VALUES ('Aparna', 'aparna@example.com', 'Hyderabad');

INSERT INTO Customers (customer_name, email, city)
VALUES
    ('Rahul', 'rahul@example.com', 'Bengaluru'),
    ('Priya', 'priya@example.com', 'Chennai'),
    ('Anil', 'anil@example.com', 'Pune');

INSERT INTO Products (product_name, category, price)
VALUES
    ('Laptop', 'Electronics', 65000.00),
    ('Keyboard', 'Accessories', 2500.00),
    ('Mouse', 'Accessories', 1200.00),
    ('Monitor', 'Electronics', 18000.00);

-- ------------------------------------------------------------
-- 2. UPDATE
-- ------------------------------------------------------------

UPDATE Customers
SET city = 'Mumbai'
WHERE email = 'rahul@example.com';

UPDATE Products
SET price = price * 1.10
WHERE category = 'Accessories';

UPDATE Customers
SET city = 'Hyderabad',
    phone_number = '9876543210'
WHERE email = 'aparna@example.com';

UPDATE Employees
SET salary = salary * 1.05
WHERE department_id = (
    SELECT department_id
    FROM Departments
    WHERE department_name = 'Data Analytics'
);

-- ------------------------------------------------------------
-- 3. DELETE
-- ------------------------------------------------------------

DELETE FROM Customers
WHERE email = 'anil@example.com'
  AND NOT EXISTS (
      SELECT 1
      FROM Orders
      WHERE Orders.customer_id = Customers.customer_id
  );

-- Example only: permanently deletes cancelled orders.
-- DELETE FROM Orders
-- WHERE status = 'Cancelled';

-- ------------------------------------------------------------
-- 4. UPSERT / ON DUPLICATE KEY UPDATE
-- ------------------------------------------------------------

INSERT INTO Customers (customer_name, email, city)
VALUES ('Aparna', 'aparna@example.com', 'Bengaluru')
ON DUPLICATE KEY UPDATE
    customer_name = VALUES(customer_name),
    city = VALUES(city);

INSERT INTO Products (product_name, category, price)
VALUES ('Laptop', 'Electronics', 70000.00)
ON DUPLICATE KEY UPDATE
    category = VALUES(category),
    price = VALUES(price);

-- ------------------------------------------------------------
-- 5. INSERT ... SELECT
-- ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS Customer_Backup (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL,
    city VARCHAR(100)
);

INSERT INTO Customer_Backup (
    customer_id,
    customer_name,
    email,
    city
)
SELECT
    customer_id,
    customer_name,
    email,
    city
FROM Customers
WHERE city = 'Hyderabad';

-- ------------------------------------------------------------
-- 6. DELETE with a condition
-- ------------------------------------------------------------

DELETE FROM Customer_Backup
WHERE city <> 'Hyderabad';

-- ------------------------------------------------------------
-- 7. Verification
-- ------------------------------------------------------------

SELECT * FROM Departments;
SELECT * FROM Customers;
SELECT * FROM Products;
SELECT * FROM Customer_Backup;
