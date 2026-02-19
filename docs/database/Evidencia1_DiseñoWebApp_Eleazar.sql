-- =========================================================
-- Halcon - LO1 Database (Option 2 - Normalized)
-- MySQL 8+
-- =========================================================

DROP DATABASE IF EXISTS halcon_lo1;
CREATE DATABASE halcon_lo1
  DEFAULT CHARACTER SET utf8mb4
  DEFAULT COLLATE utf8mb4_unicode_ci;

USE halcon_lo1;

-- =========================================================
-- 1) Departments (Roles)
-- =========================================================
CREATE TABLE departments (
  department_id INT AUTO_INCREMENT PRIMARY KEY,
  code ENUM('ADMIN','SALES','PURCHASING','WAREHOUSE','ROUTE') NOT NULL,
  name VARCHAR(50) NOT NULL,
  UNIQUE KEY uq_departments_code (code)
) ENGINE=InnoDB;

-- =========================================================
-- 2) Users (Employees)
-- =========================================================
CREATE TABLE users (
  user_id INT AUTO_INCREMENT PRIMARY KEY,
  department_id INT NOT NULL,
  username VARCHAR(50) NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  full_name VARCHAR(120) NOT NULL,
  email VARCHAR(120) NOT NULL,
  is_active TINYINT(1) NOT NULL DEFAULT 1,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  UNIQUE KEY uq_users_username (username),
  UNIQUE KEY uq_users_email (email),
  KEY idx_users_department (department_id),

  CONSTRAINT fk_users_department
    FOREIGN KEY (department_id) REFERENCES departments(department_id)
    ON UPDATE CASCADE
    ON DELETE RESTRICT
) ENGINE=InnoDB;

-- =========================================================
-- 3) Customers
-- =========================================================
CREATE TABLE customers (
  customer_id INT AUTO_INCREMENT PRIMARY KEY,
  customer_number VARCHAR(20) NOT NULL,  -- Unique number assigned arbitrarily
  legal_name VARCHAR(150) NOT NULL,      -- Name or company name
  trade_name VARCHAR(150) NULL,          -- Optional commercial name
  phone VARCHAR(30) NULL,
  email VARCHAR(120) NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

  UNIQUE KEY uq_customers_customer_number (customer_number),
  KEY idx_customers_legal_name (legal_name)
) ENGINE=InnoDB;

-- =========================================================
-- 4) Customer Fiscal Data (1:1 with customer)
-- =========================================================
CREATE TABLE customer_fiscal_data (
  fiscal_id INT AUTO_INCREMENT PRIMARY KEY,
  customer_id INT NOT NULL,
  rfc VARCHAR(13) NOT NULL,
  razon_social VARCHAR(150) NOT NULL,
  regimen VARCHAR(100) NULL,
  uso_cfdi VARCHAR(50) NULL,
  domicilio_fiscal TEXT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

  UNIQUE KEY uq_fiscal_customer (customer_id),

  CONSTRAINT fk_fiscal_customer
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
    ON UPDATE CASCADE
    ON DELETE RESTRICT
) ENGINE=InnoDB;

-- =========================================================
-- 5) Addresses (Delivery)
-- =========================================================
CREATE TABLE addresses (
  address_id INT AUTO_INCREMENT PRIMARY KEY,
  street VARCHAR(180) NOT NULL,
  city VARCHAR(80) NOT NULL,
  state VARCHAR(80) NOT NULL,
  zip_code VARCHAR(10) NOT NULL,
  references VARCHAR(255) NULL
) ENGINE=InnoDB;

-- =========================================================
-- 6) Orders
-- =========================================================
CREATE TABLE orders (
  order_id INT AUTO_INCREMENT PRIMARY KEY,
  invoice_number VARCHAR(30) NOT NULL,          -- consecutive invoice number in business process
  customer_id INT NOT NULL,
  delivery_address_id INT NOT NULL,
  order_datetime DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  notes TEXT NULL,

  status ENUM('ORDERED','IN_PROCESS','IN_ROUTE','DELIVERED') NOT NULL DEFAULT 'ORDERED',

  -- logical delete
  is_deleted TINYINT(1) NOT NULL DEFAULT 0,
  deleted_at DATETIME NULL,

  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  UNIQUE KEY uq_orders_invoice_number (invoice_number),
  KEY idx_orders_customer (customer_id),
  KEY idx_orders_status (status),
  KEY idx_orders_datetime (order_datetime),
  KEY idx_orders_is_deleted (is_deleted),
  KEY idx_orders_customer_invoice (customer_id, invoice_number),

  CONSTRAINT fk_orders_customer
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,

  CONSTRAINT fk_orders_address
    FOREIGN KEY (delivery_address_id) REFERENCES addresses(address_id)
    ON UPDATE CASCADE
    ON DELETE RESTRICT
) ENGINE=InnoDB;

-- =========================================================
-- 7) Evidence Photos (Uploaded by Route)
-- =========================================================
CREATE TABLE order_evidence_photos (
  photo_id INT AUTO_INCREMENT PRIMARY KEY,
  order_id INT NOT NULL,
  type ENUM('LOADED_UNIT','DELIVERED_EVIDENCE') NOT NULL,
  file_url VARCHAR(255) NOT NULL,
  uploaded_by_user_id INT NOT NULL,
  uploaded_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

  KEY idx_photos_order (order_id),
  KEY idx_photos_uploader (uploaded_by_user_id),
  KEY idx_photos_type (type),

  CONSTRAINT fk_photos_order
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,

  CONSTRAINT fk_photos_uploader
    FOREIGN KEY (uploaded_by_user_id) REFERENCES users(user_id)
    ON UPDATE CASCADE
    ON DELETE RESTRICT
) ENGINE=InnoDB;

-- =========================================================
-- Seed data: Departments + Default Admin user
-- =========================================================
INSERT INTO departments (code, name) VALUES
('ADMIN','Administration'),
('SALES','Sales'),
('PURCHASING','Purchasing'),
('WAREHOUSE','Warehouse'),
('ROUTE','Route');

-- Default Admin (password_hash is a placeholder, replace in implementation)
-- Use bcrypt/argon2 hash in real app.
INSERT INTO users (department_id, username, password_hash, full_name, email)
SELECT d.department_id, 'admin', 'CHANGE_ME_HASH', 'Default Admin', 'admin@halcon.local'
FROM departments d
WHERE d.code = 'ADMIN';
