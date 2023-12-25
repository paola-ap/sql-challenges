# Case Study #1 - Danny's Diner 
<p align="center">
<img src="https://user-images.githubusercontent.com/81607668/127727503-9d9e7a25-93cb-4f95-8bd0-20b87cb4b459.png" alt="Image" width="450" height="450">

## Table of Contents
- [Tools](#tools)
- [Business Task](#business-task)
- [Datasets](#datasets)
- [Entity Relationship Diagram](#entity-relationship-diagram)
- [Case Study Questions and Solutions](#case-study-questions-and-solutions)
  - [Question 1](#1-what-is-the-total-amount-each-customer-spent-at-the-restaurant)
  - [Question 2](#2-how-many-days-has-each-customer-visited-the-restaurant)
  - [Question 3](#3-how-many-days-has-each-customer-visited-the-restaurant)
  - [Question 4](#4-what-is-the-most-purchased-item-on-the-menu-and-how-many-times-was-it-purchased-by-all-customers)
  - [Question 5](#5-which-item-was-the-most-popular-for-each-customer)
  - [Question 6](#6-which-item-was-purchased-first-by-each-customer-after-they-became-a-member)
  - [Question 7](#7-which-item-was-purchased-just-before-the-customer-became-a-member)
  - [Question 8](#8-what-is-the-total-items-and-amount-spent-for-each-member-before-they-became-a-member)
  - [Question 9](#q9)
  - [Question 10](#q10)
  - [Bonus Question 1](#bonus-1-join-all-the-things)
  - [Bonus Question 2](#bonus-2-rank-all-the-things)


Please note that all the details pertaining to the case study have been obtained from [Data with Danny](https://8weeksqlchallenge.com/case-study-1/). 

***

## Tools

| SQL Flavor | Query Tool |
|------------|------------|
| PostgreSQL | pgAdmin 4  |

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
This query identifies each customer's most frequently ordered product along with the number of times it was ordered. It accomplishes this through a combination of a CTE, subquery, and aggregation functions.

* **WITH product_sales AS**: The query begins with a CTE named `product_sales`, a temporary table that stores the number of times each customer has ordered each product.
  * **INNER JOIN**: Merges `sales` and `menu` tables in order to link the `product_id` to the `product_name`.
  * **COUNT(*) AS order_count**: Within this CTE, the query calculates the total number of orders (`order_count`) per product per customer using the `COUNT(*)` function.
  * **GROUP BY customer_id, product_name**: The data is grouped by both `customer_id` and `product_name`. This step is needed for the `COUNT` function to compute the order count for each specific product for each customer.
* **WHERE Clause with Subquery**:
  * The core of this query lies in its WHERE clause, which uses a subquery to filter out the desired records. The subquery selects the maximum `order_count` for each `customer_id` from the `product_sales` CTE. 
  * The use of `(customer_id, order_count) IN` with the subquery ensures that for each customer, only their most frequently ordered product is selected. This is determined by matching the `customer_id` with their highest `order_count`.
* **ORDER BY customer_id ASC**: Finally, the results are ordered by `customer_id` in ascending order. 

***

### 6. Which item was purchased first by each customer after they became a member?

```sql
WITH member_sales AS (
    SELECT
        customer_id,
        product_name,
        order_date,
        join_date,
        DENSE_RANK() OVER (PARTITION BY customer_id ORDER BY order_date ASC)
            AS order_rank
    FROM sales
    INNER JOIN menu USING(product_id)
    INNER JOIN members USING(customer_id)
    WHERE sales.order_date >= members.join_date
)
SELECT
    customer_id,
    product_name,
    order_date,
    join_date
FROM member_sales
WHERE order_rank = 1
ORDER BY customer_id ASC;
```
#### Query Result

| customer_id | product_name | order_date | join_date |
|-------------|--------------|------------|-----------|
| A           | curry        | 2021-01-07 | 2021-01-07|
| B           | sushi        | 2021-01-11 | 2021-01-09|

#### Key Operations
This SQL query is designed to find each customer's first purchase from the time they became a member. It uses a combination of a CTE, window function, and multiple joins.

* **WITH member_sales AS**: The query begins with a CTE named `product_sales`, a temporary table that stores the orders made by customers after becoming members, ranking them by the order date for each customer.
  * **INNER JOINs**:
    * Joins `sales` and `menu` tables on `product_id` to link each `product_id` with the corresponding product name.
    * Joins `sales` and `members` tables on `customer_id` to exclude non-members and associate each sale with the members’ `join_date`.
  * **WHERE sales.order_date >= members.join_date**: Filters out sales that occurred before the customer became a member, ensuring that only purchases made during the membership period are considered.
  * **DENSE_RANK() OVER (PARTITION BY customer_id ORDER BY order_date ASC) AS order_rank**: Assigns a rank to each food order for a customer, based on the order date, with the earliest order getting the rank 1. The `PARTITION BY` clause ensures that this ranking is done separately for each customer.
* **WHERE order_rank = 1**: Filters the `member_sales` CTE to only include the first order (rank 1) for each customer since becoming a member.

***

### 7. Which item was purchased just before the customer became a member?

```sql
WITH pre_membership_sales AS (
    SELECT
        customer_id,
        product_name,
        order_date,
        join_date,
        DENSE_RANK() OVER (PARTITION BY customer_id ORDER BY order_date DESC)
            AS latest_order_rank
    FROM sales
    INNER JOIN menu USING(product_id)
    INNER JOIN members USING(customer_id)
    WHERE order_date < join_date
)
SELECT
    customer_id,
    STRING_AGG(product_name, ', '),
    order_date,
    join_date
FROM pre_membership_sales
WHERE latest_order_rank = 1
GROUP BY customer_id, order_date, join_date;
```

#### Query Result
| customer_id | product_name | order_date | join_date  |
|-------------|--------------|------------|------------|
| A           | sushi, curry | 2021-01-01 | 2021-01-07 |
| B           | sushi        | 2021-01-04 | 2021-01-09 |


#### Key Operations
This query uses a structure similar to that of question 6 to identify each customer's last non-member order before joining the loyalty program.

* **WITH pre_membership_sales AS**: Similar to the `member_sales` CTE in the previous query, `pre_membership_sales` constructs a temporary table. However, in this case, it captures orders placed by customers before their membership began. The orders are sorted in reverse chronological order (most recent first) for each customer.
  * **WHERE order_date < join_date**: A key difference in this query lies in the WHERE clause: `WHERE order_date < join_date` selects sales transactions that occurred prior to the customer's membership start date.
  * **DENSE_RANK() OVER (PARTITION BY customer_id ORDER BY order_date DESC) AS latest_order_rank**: Assigns a rank to each order for a customer, with the most recent order before joining the membership getting the rank of 1. This contrasts with the previous query, where the earliest order after joining received the rank 1.
* **WHERE latest_order_rank = 1**: Isolates the last order of each customer before they became a member.
* **GROUP BY customer_id, order_date, join_date**: Ensures that the data is organized in order to use the `STRING_AGG` function to combine all products ordered on the same day into a single row.

***

### 8. What is the total items and amount spent for each member before they became a member?

```sql
SELECT
    customer_id,
    COUNT(*) AS item_count,
    SUM(price) AS pre_member_total_spend
FROM sales
INNER JOIN members USING(customer_id)
INNER JOIN menu USING(product_id)
WHERE order_date < join_date
GROUP BY customer_id
ORDER BY customer_id;
```

| customer_id | item_count | pre_member_total_spend |
|-------------|------------|------------------------|
| A           | 2          | 25                     |
| B           | 3          | 40                     |

#### Key Operations
This query calculates the total number of items purchased and the total amount spent by each customer before they became a member.

* **INNER JOINs**:
  * The query first joins the `sales` table with the `members` table on `customer_id`. This join links each sale to the corresponding customer's membership information.
  * It then joins the `sales` table with the `menu` table on `product_id`. This second join brings in the price details for each product sold.
* **WHERE order_date < join_date**: Filters the dataset to only include sales that occurred before a customer's membership start date (`join_date`).
* **COUNT(*) AS item_count**: Counts the total number of items for each customer.
* **SUM(price) AS pre_member_total_spend**: Calculates the total amount spent by each customer on these purchases. 
* **GROUP BY customer_id**: Groups the results by `customer_id` to ensure that the item count and total spend calculations are specific to each individual customer.

***

### 9. If each $1 spent equates to 10 points and sushi has a 2x points multiplier, how many points would each customer have?<a name="q9"></a>

```sql
WITH order_points AS (
    SELECT
        customer_id,
        CASE
            WHEN product_name = 'sushi' THEN price * 20
            ELSE price * 10
        END AS points
    FROM sales
    INNER JOIN menu USING(product_id)
)
SELECT
    customer_id,
    SUM(points) AS total_points
FROM order_points
GROUP BY customer_id
ORDER BY customer_id;
```

#### Query Result

| customer_id | total_points |
|-------------|--------------|
| A           | 860          |
| B           | 940          |
| C           | 360          |

#### Key Operations
This query calculates total reward points for each customer based on their purchases, with a higher point value assigned to sushi orders.

* **WITH order_points AS**: Creates a temporary table to calculate the points each customer earns from their purchases.
  * **INNER JOIN** between the `sales` and `menu` tables on `product_id`: Links each sale with the corresponding product details.
  * **CASE WHEN**: Applies conditional logic to calculate the points earned based on the type of product purchased.
      - **If product_name = sushi**: For sushi, the query multiplies the price by 20, as each $1 spent on sushi earns 20 points.
      - **Else (Other Products)**: For all other products, each $1 spent earns 10 points, resulting in the price being multiplied by 10.
* **SUM(points) AS total_points**: Calculates the total points earned by each customer. 
* **GROUP BY customer_id**: Groups the results by `customer_id` to ensure that the point calculations are specific to each customer.

***

### 10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi. How many points do customer A and B have at the end of January?<a name="q10"></a>

```sql
SELECT
    customer_id,
    SUM(CASE
        -- Orders before joining yield no points
        WHEN order_date < join_date THEN 0
        
        -- During the first week of membership, 2x points on all items
        WHEN DATE(order_date) <= DATE(join_date) + INTERVAL '6 DAYS' THEN price * 20

         -- After the first week, 2x points only on sushi 
        WHEN (product_name = 'sushi') THEN price * 20
      
        -- Regular points for non-sushi items after the first week
        ELSE price * 10
    END) AS total_points
FROM members
INNER JOIN sales USING(customer_id)
INNER JOIN menu USING(product_id)
WHERE order_date <= '2021-01-31'
GROUP BY customer_id
ORDER BY customer_id ASC;
```

#### Query Result
| customer_id | total_points |
|-------------|--------------|
| A           | 1020         |
| B           | 320          |

#### Key Operations
This query calculates the loyalty points earned by customers, taking into account membership status, a promotional period for new members, and type of product purchased.

* **SELECT Clause with CASE Statement**: Computes the total points earned by each customer using a `SUM` function combined with a `CASE` statement.
  * **Orders Before Membership**: If an order date is before the join date, no points are awarded (`WHEN order_date < join_date THEN 0`).
  * **First Week of Membership**: During the first week after joining, customers earn double points (20 points per dollar spent) on all items: (`WHEN DATE(order_date) <= DATE(join_date) + INTERVAL '6 DAYS' THEN price * 20`). The interval `DATE(join_date) + INTERVAL '6 DAYS'` is used to define the first week because the range is inclusive of both the start and end dates. By adding 6 days, the total duration covers a 7-day period (the join date plus the subsequent 6 days).
  * **Sushi After First Week**: After the first week of membership, only sushi orders continue to earn double points (`WHEN (product_name = 'sushi') THEN price * 20`).
  * **Regular Points for Non-Sushi Items After First Week**: For non-sushi items after the first week of membership, the standard points rate (10 points per dollar) applies (`ELSE price * 10`).
* **WHERE Clause**: Limits the data to orders placed on or before '2021-01-31' as required by the problem statement.

***
> ## The remaining questions are currently under development and will be added soon


### Bonus 1: Join All The Things

Create a table with `customer_id`, `order_date`, `product_name`, `price`, and `member` columns, populating the `member` column with `N` for purchases made before becoming a member and `Y` for those made after joining the loyalty program.

Example:

| customer_id | order_date  | product_name | price | member |
|-------------|-------------|--------------|-------|--------|
| A           | 2021-01-01  | curry        | 15    | N      |
| A           | 2021-01-01  | sushi        | 10    | N      |
...

```sql
```

#### Query Result


#### Key Operations


***

### Bonus 2: Rank All The Things

Danny also requires further information about the ranking of customer products, but he purposely does not need the ranking for non-member purchases so he expects null ranking values for the records when customers are not yet part of the loyalty program.

Example:

| customer_id | order_date | product_name | price | member | ranking |
|-------------|------------|--------------|-------|--------|---------|
| A           | 2021-01-01 | curry        | 15    | N      | null    |
| A           | 2021-01-01 | sushi        | 10    | N      | null    |
...

```sql
```

#### Query Result

#### Key Operations
