# Halcon - Order Tracking Web Application (LO1)

## Problem description
“Halcon” is a construction material distributor that needs a web application to automate internal processes and allow customers to track orders.

Customers must be able to check an order from a main screen by entering:
- Customer Number
- Invoice Number

The system must display:
- Current order status (Ordered, In process, In route, Delivered)
- If status is **Delivered**, show the delivery evidence photo.

## Objective
Build a web application that:
1) Allows customers to track their order status using Customer Number + Invoice Number.
2) Provides an administrative dashboard for company personnel to manage orders and users by role.
3) Enforces the order life cycle and role-based permissions (especially photo upload by Route department).

## Roles / Actors
- **Admin**: default system user; creates users and assigns roles.
- **Sales**: creates orders when a customer calls; registers customer data and invoice number.
- **Purchasing**: manages purchase of materials when items are not in stock.
- **Warehouse**: prepares orders, updates status to "In process" and then "In route"; coordinates with Purchasing if stock is missing.
- **Route**: uploads photo evidence of loaded unit and delivery (unloaded material); updates status to "Delivered".
- **Customer**: cannot register; only checks order status using Customer Number and Invoice Number.

## Order statuses (life cycle)
1. **Ordered**: created by Sales.
2. **In process**: managed by Warehouse (and Purchasing if stock is missing).
3. **In route**: order loaded and ready for distribution.
4. **Delivered**: delivered to customer; evidence photo available.

## LO1 Scope (Deliverable)
This repository contains the **analysis and project start** for Learning Outcome 1:
- Methodology selection and justification
- Diagrams: BPMN, Use Case, Activity, Class diagram
- Database selection and ER diagram (entities, attributes, relationships)

> Note: Implementation (full functional web app) will be addressed in later learning outcomes / stages.

## Proposed technologies (can change)
- Frontend: (proposed) HTML/CSS/JavaScript or React
- Backend: (proposed) Node.js + Express OR PHP
- Database: (proposed) MySQL or PostgreSQL
- Authentication: role-based access control (RBAC)
- Storage for photos: local storage (development) + cloud storage (optional later)

## How to run (pending)
This project is currently in the analysis/design stage (LO1).  
Execution instructions will be added once the initial application skeleton is implemented.

## Project documentation
All LO1 diagrams and database design will be stored in:

- BPMN, Use Case, Activity, Class diagrams:
  - `docs/diagramas/`

- Database (ERD + notes):
  - `docs/database/`

## Repository structure
