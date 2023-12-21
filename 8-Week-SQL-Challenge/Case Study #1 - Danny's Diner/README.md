# Case Study #1 - Danny's Diner 
<p align="center">
<img src="https://user-images.githubusercontent.com/81607668/127727503-9d9e7a25-93cb-4f95-8bd0-20b87cb4b459.png" alt="Image" width="450" height="450">

## Table of Contents
- [Business Task](#business-task)
- [Datasets](#datasets)
- [Entity Relationship Diagram](#entity-relationship-diagram)
- [Case Study Questions and Solutions](#case-study-questions-and-solutions)

Please note that all the details pertaining to the case study have been obtained from [Data with Danny](https://8weeksqlchallenge.com/case-study-1/). 

***

## Business Task

Danny’s Diner is in need of your assistance to help the restaurant stay afloat - the restaurant has captured some very basic data from their few months of operation but have no idea how to use their data to help them run the business.

Danny wants to use the data to answer a few simple questions about his customers, especially about their visiting patterns, how much money they’ve spent and also which menu items are their favourite. 

***

## Datasets

Danny has shared with you 3 key datasets for this case study:

<details><summary>Sales</summary>

| customer_id | order_date | product_id |
|-------------|------------|------------|
| A           | 2021-01-01 | 1          |
| A           | 2021-01-01 | 2          |
| A           | 2021-01-07 | 2          |
| A           | 2021-01-10 | 3          |
| A           | 2021-01-11 | 3          |
| A           | 2021-01-11 | 3          |
| B           | 2021-01-01 | 2          |
| B           | 2021-01-02 | 2          |
| B           | 2021-01-04 | 1          |
| B           | 2021-01-11 | 1          |
| B           | 2021-01-16 | 3          |
| B           | 2021-02-01 | 3          |
| C           | 2021-01-01 | 3          |
| C           | 2021-01-01 | 3          |
| C           | 2021-01-07 | 3          |
</details>
 
<details><summary>Menu</summary>

| product_id | product_name | price |
|------------|--------------|-------|
| 1          | sushi        | 10    |
| 2          | curry        | 15    |
| 3          | ramen        | 12    |
</details>

<details><summary>Members</summary>

| customer_id | join_date  |
|-------------|------------|
| A           | 2021-01-07 |
| B           | 2021-01-09 |

</details>

***

## Entity Relationship Diagram

![image](https://user-images.githubusercontent.com/81607668/127271130-dca9aedd-4ca9-4ed8-b6ec-1e1920dca4a8.png)

***

## Case Study Questions and Solutions

### 1. What is the total amount each customer spent at the restaurant?

```sql
SELECT
    customer_id,
    SUM(price) AS total_sales
FROM sales
INNER JOIN menu USING(product_id)
GROUP BY customer_id
ORDER BY customer_id ASC;
```
#### Query Result

| customer_id | total_sales |
| ----------- | ----------- |
| A           | 76          |
| B           | 74          |
| C           | 36          |

#### Key Operations
This query calculates the total sales amount per customer by summing up the prices of the products each customer has purchased.

 * **INNER JOIN**: Merges sales and menu tables on matching `product_id` to pair each sale with its product price.
 * **GROUP BY** `customer_id`: Organizes the data into distinct groups per customer in order to be able to calculate the total sales for each individual customer.
 * **SUM(price)**: Aggregates the prices of products purchased by each customer to get their total spend.

***

### 2. How many days has each customer visited the restaurant?

```sql
SELECT
    customer_id,
    COUNT(DISTINCT order_date) AS customer_visits
FROM sales
GROUP BY customer_id
ORDER BY customer_id ASC;
```
#### Query Result

| customer_id | customer_visits |
| ----------- | --------------- |
| A           | 4               |
| B           | 6               |
| C           | 2               |

#### Key Operations
This query calculates the number of distinct visits per customer by counting the unique order dates associated with each customer.

 * **COUNT(DISTINCT order_date)**: Aggregates the unique dates on which each customer has placed an order.
 * **GROUP BY** `customer_id`: Organizes the data into distinct groups per customer in order to be able to calculate the number of distinct visits on a per-customer basis.

***

### 3. How many days has each customer visited the restaurant?

```sql
-- First aggregate products by customer and order date
WITH product_orders AS (
    SELECT
        customer_id,
        order_date,
        STRING_AGG(product_name, ', ') AS products_ordered
    FROM sales
    INNER JOIN menu USING(product_id)
    GROUP BY customer_id, order_date
)
-- Filter orders by earliest order date
SELECT
    customer_id,
    order_date AS earliest_order_date,
    products_ordered
FROM product_orders
WHERE (customer_id, order_date) IN (
    SELECT
        customer_id,
        MIN(order_date)
    FROM product_orders
    GROUP BY customer_id
)
ORDER BY customer_id ASC;
```
#### Query Result

| customer_id | earliest_order_date | products_ordered |
|-------------|---------------------|------------------|
| A           | 2021-01-01          | sushi, curry     |
| B           | 2021-01-01          | curry            |
| C           | 2021-01-01          | ramen, ramen     |

#### Key Operations
This query identifies the first set of products ordered by each customer along with the date of these initial orders.

* **WITH product_orders**: This Common Table Expression (CTE) is used as a temporary result set for further processing. It aggregates products ordered by customers on each order date.
  * **INNER JOIN**: Pairs each sale with its respective product name.
  * **STRING_AGG(product_name, ', ')**: Concatenates the names of products ordered into a single string, separated by commas, for each order. We aggregate the products because at times multiple products were purchased on the same day, and we are not provided timestamps to determine the order of the sales.
  * **GROUP BY customer_id, order_date**: Organizes the data into groups for each combination of customer and order date to facilitate aggregation of product names.
* **WHERE** Clause with Subquery: Filters the records to only include the earliest order for each customer. This is done using a subquery that selects the minimum `order_date` for each `customer_id` from the `product_orders` CTE.

***

### 4. What is the most purchased item on the menu and how many times was it purchased by all customers?

```sql
SELECT
    product_name,
    COUNT(*) AS purchase_count
FROM sales
INNER JOIN menu USING(product_id)
GROUP BY product_name
ORDER BY purchase_count DESC
LIMIT 1;
```
#### Query Result

| product_name | total_orders |
|--------------|--------------|
| ramen        | 8            |

#### Key Operations
This query identifies the most popular product based on the number of times it has been ordered.

* **INNER JOIN**: Merges `sales` and `menu` tables in order to link the `product_id` to the `product_name`.
* **COUNT(*)**: Counts the total number of sales for each product. The `COUNT(*)` function is applied to each group of `product_name`.
* **GROUP BY product_name**: Groups the data by `product_name`, which is necessary for the `COUNT(*)` function to calculate the number of purchases for each product separately.
* **ORDER BY purchase_count DESC**: Sorts the results in descending order based on the `purchase_count`.
* **LIMIT 1**: The query limits the output to just the top row of the sorted list. Since the list is sorted by purchase count in descending order, this means the query will return only the product with the highest purchase count.

***

### 5. Which item was the most popular for each customer?

```sql
WITH product_sales AS (
    SELECT
        customer_id,
        product_name,
        COUNT(*) AS order_count
    FROM sales
    INNER JOIN menu USING(product_id)
    GROUP BY customer_id, product_name
)
SELECT
    customer_id,
    product_name,
    order_count
FROM product_sales
WHERE (customer_id, order_count) IN (
    SELECT
        customer_id,
        MAX(order_count)
    FROM product_sales
    GROUP BY customer_id
)
ORDER BY customer_id ASC;
```

#### Query Result

| customer_id | product_name | order_count |
|-------------|--------------|-------------|
| A           | ramen        | 3           |
| B           | sushi        | 2           |
| B           | curry        | 2           |
| B           | ramen        | 2           |
| C           | ramen        | 3           |

#### Key Operations
This query identifies each customer's most frequently ordered product along with the number of times it was ordered. It accomplishes this through a combination of a Common Table Expression (CTE), subquery, and aggregation functions.

* **WITH product_sales AS**: The query begins with a CTE named `product_sales`, a temporary table that stores the number of times each customer has ordered each product.
  * **INNER JOIN**: Merges `sales` and `menu` tables in order to link the `product_id` to the `product_name`.
  * **COUNT(*) AS order_count**: Within this CTE, the query calculates the total number of orders (`order_count`) per product per customer using the `COUNT(*)` function.
  * **GROUP BY customer_id, product_name**: The data is grouped by both `customer_id` and `product_name`. This step is needed for the `COUNT` function to compute the order count for each specific product for each customer.
* **WHERE Clause with Subquery**:
  * The core of this query lies in its WHERE clause, which uses a subquery to filter out the desired records. The subquery selects the maximum `order_count` for each `customer_id` from the `product_sales` CTE. 
  * The use of `(customer_id, order_count) IN` with the subquery ensures that for each customer, only their most frequently ordered product is selected. This is determined by matching the `customer_id` with their highest `order_count`.
* **ORDER BY customer_id ASC**: Finally, the results are ordered by `customer_id` in ascending order. 

***
