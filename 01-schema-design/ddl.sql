-- SQL Interview Prep
-- 01-schema-design / ddl.sql
-- MySQL 8.0.42

CREATE DATABASE IF NOT EXISTS sql_interview_prep;
USE sql_interview_prep;

-- CREATE TABLES

CREATE TABLE IF NOT EXISTS Departments (
    department_id INT AUTO_INCREMENT PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS Employees (
    emp_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    department_id INT,
    salary DECIMAL(10,2) NOT NULL,
    manager_id INT,
    hire_date DATE NOT NULL,
    CONSTRAINT chk_employee_salary CHECK (salary >= 0),
    CONSTRAINT fk_employee_department
        FOREIGN KEY (department_id) REFERENCES Departments(department_id)
        ON UPDATE CASCADE ON DELETE SET NULL,
    CONSTRAINT fk_employee_manager
        FOREIGN KEY (manager_id) REFERENCES Employees(emp_id)
        ON UPDATE CASCADE ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS Customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    city VARCHAR(100),
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS Products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(150) NOT NULL,
    category VARCHAR(100) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    CONSTRAINT chk_product_price CHECK (price >= 0)
);

CREATE TABLE IF NOT EXISTS Orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    order_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(30) NOT NULL DEFAULT 'Pending',
    amount DECIMAL(12,2) NOT NULL,
    CONSTRAINT chk_order_amount CHECK (amount >= 0),
    CONSTRAINT chk_order_status
        CHECK (status IN ('Pending', 'Completed', 'Cancelled')),
    CONSTRAINT fk_order_customer
        FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE IF NOT EXISTS Order_Items (
    order_item_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    CONSTRAINT chk_order_item_quantity CHECK (quantity > 0),
    CONSTRAINT chk_order_item_price CHECK (unit_price >= 0),
    CONSTRAINT fk_order_item_order
        FOREIGN KEY (order_id) REFERENCES Orders(order_id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_order_item_product
        FOREIGN KEY (product_id) REFERENCES Products(product_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT uq_order_product UNIQUE (order_id, product_id)
);

-- ALTER TABLE PRACTICE
-- These are examples only. Uncomment and run individually.

-- ALTER TABLE Customers ADD COLUMN phone_number VARCHAR(25);
-- ALTER TABLE Customers MODIFY COLUMN phone_number VARCHAR(30);
-- ALTER TABLE Customers RENAME COLUMN phone_number TO contact_number;
-- ALTER TABLE Products ADD CONSTRAINT uq_product_name UNIQUE (product_name);

-- DROP PRACTICE
-- DROP TABLE Order_Items;
-- DROP TABLE Orders;
-- DROP TABLE Products;
-- DROP TABLE Customers;
-- DROP TABLE Employees;
-- DROP TABLE Departments;
-- DROP DATABASE sql_interview_prep;

-- TRUNCATE PRACTICE
-- TRUNCATE TABLE Order_Items;
