# Purrs-R-Us - An SQL project

## Project Overview

For this project, I am creating a unique scenario in which a database is designed, and a series of SQL commands are performed to demonstrate my proficiency in database management and SQL.

## Project: Purrs-R-Us, the Cat Shelter & Supply Shop

The scenario revolves around Purrs-R-Us, a hypothetical cat shelter that also operates a supply shop to support its operations. 
The shop's revenue helps fund the care of the cats awaiting adoption. 
To boost engagement and sales, the shelter has introduced a program offering discounts to customers who adopt cats, encouraging them to purchase supplies from the shop. 
This initiative is also designed to increase adoption rates by integrating the shop and shelter experience.

**This project demonstrates:**

- Database creation and normalization.
- Mechanisms for automation and data-driven decision-making, such as:
  - SQL Transactions
  - SQL Procedures
  - SQL Triggers
  - SQL Views
- Solutions for improving processes and understanding customer behaviour.

## Database Normalization

To ensure efficiency and eliminate redundancy, the database adheres to the following normalization standards:

### First Normal Form (1NF)

- Each table has a primary key, and all columns contain atomic values.
- ***Example:*** In the customer_contact table, City and Street are stored in separate columns.

### Second Normal Form (2NF)

- Non-key columns depend entirely on the primary key, avoiding partial dependencies.
- ***Example:*** Customer details are stored in a *customers* table, separate from the *cats* table, despite their relationship.

### Third Normal Form (3NF)

- Non-key columns are not transitively dependent on the primary key.
- ***Example:*** shop_orders and item_prices are kept separate to avoid dependency conflicts.

### Boyce-Codd Normal Form (BCNF)

- Functional dependencies between non-key attributes are eliminated.
- ***Example:*** In the *cats* table, *cat_id* determines *owner_id*, but since customers can own multiple cats, dependencies are managed separately.

### Fourth Normal Form (4NF)

- Multi-valued dependencies are removed. None of the tables have columns partially dependent on a composite primary key.

### Fifth Normal Form (5NF)

- Complex many-to-many relationships are decomposed into smaller tables.
- ***Example:*** An enhanced table consolidates data for user comprehension while maintaining normalized relationships across tables.

## Key Features and Solutions

### 1. Streamlined Sales Input Process

**Challenge:** Cashiers manually check item IDs, promotions, and calculate discounts, leading to inefficiencies.

***Solution:***

- An SQL procedure that allows sales orders to be input with user-friendly parameters (e.g., item descriptions).

- A trigger that automatically:

  - Populates enhanced order details.

  - Calculates order totals, discounts, and eligibility for promotions.

### 2. Stock Level Management

**Challenge:** Manual stock verification caused unexpected shortages.

***Solution:***

- Procedures are implemented to verify stock availability during order processing.

- Stock levels are automatically adjusted for successful orders.

### 3. Enhanced User Interface

**Challenge:** Overwhelming information in the *shop_orders_enhanced* table.

***Solution:***

- A user-friendly view displays essential transaction details while omitting unnecessary fields.

### 4. Customer Management

**Challenge:** Adding new customers delayed transaction processing.

***Solution:***

- New customers are automatically added to the *customer* table during order entry.

### 5. Identifying Top Spending Customers

**Challenge:** The sales team wanted to identify the top six spenders monthly.

***Solution:***

- A view displays top customers with total spend, their preferred item categories, and category contribution percentages.

### 6. Marketing Campaign Support

**Challenge:** Targeted campaigns required data on non-adopted cats and customer behaviour.

***Solution:***

- Queries provide:
  - Most frequent fur coloUrs among adopted and non-adopted cats.
  - Average ages within cat breeds.
  - Lists of customers with and without adopted cats.

### 7. Product Recall Management

**Challenge:** Identifying customers who purchased a recalled product.

***Solution:***

- Queries retrieve customer and transaction details for communication and refunds.

### 8. Customer Data Protection

**Challenge:** Customers requested selective removal of contact information.

***Solution:***

- A procedure that removes contact details without exposing other customer data.
- A query that ensures the integrity of the customer and customer_contact tables.

## Supporting Documentation

- Screenshots of tables (before and after processes) are provided.
- Images are sequentially numbered and correspond to the order of the SQL code.

## Conclusion

This project successfully demonstrates my SQL skills, including database normalization, procedure creation, automation, and data-driven insights. 
By addressing practical challenges faced by Purrs-R-Us, the project showcases the ability to design scalable and efficient database solutions tailored to real-world scenarios.
