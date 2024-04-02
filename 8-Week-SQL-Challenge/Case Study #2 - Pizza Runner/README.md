> ## This case study is currently under development and will be updated soon

# Case Study #2 - Pizza Runner
<p align="center">
<img src="https://user-images.githubusercontent.com/81607668/127271856-3c0d5b4a-baab-472c-9e24-3c1e3c3359b2.png" alt="Image" width="450" height="450">

## Table of Contents
- [Tools](#tools)
- [Business Task](#business-task)
- [Datasets](#datasets)
- [Entity Relationship Diagram](#entity-relationship-diagram)
- [Data Cleaning & Transformation](#data-cleaning)
- [Case Study Questions and Solutions](#case-study-questions-and-solutions)

Please note that all the details pertaining to the case study have been obtained from [Data with Danny](https://8weeksqlchallenge.com/). 

***

## Tools

| SQL Flavor | Query Tool |
|------------|------------|
| PostgreSQL | pgAdmin 4  |

***

## Business Task

Danny, in his new venture, Pizza Runner, requires assistance in managing and optimizing his pizza delivery service. Leveraging data to track runner performance, customer preferences, and sales trends is key to growing his business.

## Datasets

All datasets exist within the pizza_runner database schema.

<details><summary>customer_orders</summary>
Customer pizza orders are captured in the `customer_orders` table with 1 row for each individual pizza that is part of the order.

* The `pizza_id` relates to the type of pizza which was ordered whilst the `exclusions` are the `ingredient_id` values which should be removed from the pizza and the `extras` are the `ingredient_id` values which need to be added to the pizza.
* Note that customers can order multiple pizzas in a single order with varying `exclusions` and `extras` values even if the pizza is the same type!
* The `exclusions` and `extras` columns will need to be cleaned up before using them in your queries.

| order_id | customer_id | pizza_id | exclusions | extras | order_time          |
|----------|-------------|----------|------------|--------|---------------------|
| 1        | 101         | 1        |            |        | 2021-01-01 18:05:02 |
| 2        | 101         | 1        |            |        | 2021-01-01 19:00:52 |
| 3        | 102         | 1        |            |        | 2021-01-02 23:51:23 |
| 3        | 102         | 2        |            | NULL   | 2021-01-02 23:51:23 |
| 4        | 103         | 1        | 4          |        | 2021-01-04 13:23:46 |
| 4        | 103         | 1        | 4          |        | 2021-01-04 13:23:46 |
| 4        | 103         | 2        | 4          |        | 2021-01-04 13:23:46 |
| 5        | 104         | 1        | null       | 1      | 2021-01-08 21:00:29 |
| 6        | 101         | 2        | null       | null   | 2021-01-08 21:03:13 |
| 7        | 105         | 2        | null       | 1      | 2021-01-08 21:20:29 |
| 8        | 102         | 1        | null       | null   | 2021-01-09 23:54:33 |
| 9        | 103         | 1        | 4          | 1, 5   | 2021-01-10 11:22:59 |
| 10       | 104         | 1        | null       | null   | 2021-01-11 18:34:49 |
| 10       | 104         | 1        | 2, 6       | 1, 4   | 2021-01-11 18:34:49 |
</details>

<details><summary>runner_orders</summary>

After each orders are received through the system - they are assigned to a runner - however not all orders are fully completed and can be cancelled by the restaurant or the customer.

The `pickup_time` is the timestamp at which the runner arrives at the Pizza Runner headquarters to pick up the freshly cooked pizzas. The `distance` and `duration` fields are related to how far and long the runner had to travel to deliver the order to the respective customer.

There are some known data issues with this table so be careful when using this in your queries - make sure to check the data types for each column in the schema SQL!

| order_id | runner_id | pickup_time         | distance | duration   | cancellation            |
|----------|-----------|---------------------|----------|------------|-------------------------|
| 1        | 1         | 2021-01-01 18:15:34 | 20km     | 32 minutes |                         |
| 2        | 1         | 2021-01-01 19:10:54 | 20km     | 27 minutes |                         |
| 3        | 1         | 2021-01-03 00:12:37 | 13.4km   | 20 mins    | NaN                     |
| 4        | 2         | 2021-01-04 13:53:03 | 23.4     | 40         | NaN                     |
| 5        | 3         | 2021-01-08 21:10:57 | 10       | 15         | NaN                     |
| 6        | 3         | null                | null     | null       | Restaurant Cancellation |
| 7        | 2         | 2020-01-08 21:30:45 | 25km     | 25mins     | null                    |
| 8        | 2         | 2020-01-10 00:15:02 | 23.4 km  | 15 minute  | null                    |
| 9        | 2         | null                | null     | null       | Customer Cancellation   |
| 10       | 1         | 2020-01-11 18:50:20 | 10km     | 10minutes  | null                    |
</details>

<details><summary>runners</summary>
  
| runner_id | registration_date |
|-----------|-------------------|
| 1         | 2021-01-01        |
| 2         | 2021-01-03        |
| 3         | 2021-01-08        |
| 4         | 2021-01-15        |
</details>

<details><summary>pizza_names</summary>

| pizza_id | pizza_name   |
|----------|--------------|
| 1        | Meat Lovers  |
| 2        | Vegetarian   |
</details>

<details><summary>pizza_recipes</summary>

| pizza_id | toppings                |
|----------|-------------------------|
| 1        | 1, 2, 3, 4, 5, 6, 8, 10 |
| 2        | 4, 6, 7, 9, 11, 12      |
</details>

<details><summary>pizza_toppings</summary>

| topping_id | topping_name |
|------------|--------------|
| 1          | Bacon        |
| 2          | BBQ Sauce    |
| 3          | Beef         |
| 4          | Cheese       |
| 5          | Chicken      |
| 6          | Mushrooms    |
| 7          | Onions       |
| 8          | Pepperoni    |
| 9          | Peppers      |
| 10         | Salami       |
| 11         | Tomatoes     |
| 12         | Tomato Sauce |
</details>

***

## Entity Relationship Diagram

![Entity Relationship Diagram](https://user-images.githubusercontent.com/74512335/131252005-8a5091d2-527b-4395-8334-a45c0331d022.png)

***

## Data Cleaning & Transformation<a name="data-cleaning"></a>
### customer_orders

The `exclusions` and `extras` columns within the `customer_orders` table need to be cleaned. We can observe that there isn't a consistent method to denote orders without either exclusions or extras.

In this business context, it's expected and understood that customers who choose not to add or remove toppings will leave those fields blank. Given that this is a deliberate decision, we will capture this using empty strings (''), thus allowing us to reserve `NULL` for cases where the data is genuinely unknown. Note that for real world applications it is important for the choice of `NULL` or empty string to align with other company or project databases and standards.

Following this rationale, and to preserve the original table, we will create a new temporary table for the following data manipulation:
* Standardize the data in the `exclusions` and `extras` columns by converting both true NULL values and literal 'null' strings to empty strings (''). 

```sql
DROP TABLE IF EXISTS temp_customer_orders;
CREATE TEMPORARY TABLE temp_customer_orders AS
    SELECT
        order_id,
        customer_id,
        pizza_id,
        CASE
            WHEN exclusions = 'null' OR exclusions IS NULL THEN ''
            ELSE exclusions
        END AS exclusions,
        CASE
            WHEN extras = 'null' OR extras IS NULL THEN ''
            ELSE extras
        END AS extras,
    order_time
FROM customer_orders;
```
#### Table Result

| order_id | customer_id | pizza_id | exclusions | extras | order_time          |
|----------|-------------|----------|------------|--------|---------------------|
| 1        | 101         | 1        |            |        | 2021-01-01 18:05:02 |
| 2        | 101         | 1        |            |        | 2021-01-01 19:00:52 |
| 3        | 102         | 1        |            |        | 2021-01-02 23:51:23 |
| 3        | 102         | 2        |            |        | 2021-01-02 23:51:23 |
| 4        | 103         | 1        | 4          |        | 2021-01-04 13:23:46 |
| 4        | 103         | 1        | 4          |        | 2021-01-04 13:23:46 |
| 4        | 103         | 2        | 4          |        | 2021-01-04 13:23:46 |
| 5        | 104         | 1        |            | 1      | 2021-01-08 21:00:29 |
| 6        | 101         | 2        |            |        | 2021-01-08 21:03:13 |
| 7        | 105         | 2        |            | 1      | 2021-01-08 21:20:29 |
| 8        | 102         | 1        |            |        | 2021-01-09 23:54:33 |
| 9        | 103         | 1        | 4          | 1, 5   | 2021-01-10 11:22:59 |
| 10       | 104         | 1        |            |        | 2021-01-11 18:34:49 |
| 10       | 104         | 1        | 2, 6       | 1, 4   | 2021-01-11 18:34:49 |

#### Key Operations
This query creates (or replaces if already existing) a temporary table named `temp_customer_orders` with cleaned data from the original `customer_orders` table.

* **DROP TABLE IF EXISTS temp_customer_orders**: Drops the existing `temp_customer_orders` table if it already exists to avoid conflicts.
*  **CREATE TEMPORARY TABLE temp_customer_orders AS**: Creates a new temporary table that holds data for the session's duration.
  * **CASE WHEN exclusions = 'null' OR exclusions IS NULL THEN '' ELSE exclusions END AS exclusions**: This statement transforms the `exclusions` field by replacing NULL or 'null' string values with an empty string.
  * **CASE WHEN extras = 'null' OR extras IS NULL THEN '' ELSE extras END AS extras**: Performs the same operation as described above, but on the `extras` column.

***

### runner_orders

The `distance`, `duration`, `pickup_time` and `cancellation` columns within the `runner_orders` table need to be cleaned. We observe the following issues:
1. The `distance` fields display units inconsistently; moreover, among those fields that include units, the format is not standardized. For example, '25km' lacks a space between the number and the unit, whereas '23.4 km' includes one.
2. There is also a discrepancy in unit notation (e.g. '32 minutes, 20  mins, 25mins, 15) in the `duration` column.
3. There is an inconsistent way to mark 'not applicable' or 'not selected' within various columns (e.g. 'null'', '', `NULL`).
4. The `distance`, `pickup_time` and `duration` fields should use float, datetime, and integer datatypes.

In order to preserve the original table, we will create a new temporary table for the following data manipulation:
* We will convert true `NULL` and the string literal 'null' to the empty string. This decision is driven by the following:
 * In the `cancellation` column, a 'null' or `NULL` value is clearly meant to signify that a cancellation did not occur rather than missing or unknown data.
 * For `pickup_time`, `duration`, and `distance` columns, the NULL values indicate non-applicable information due to order cancellations. By our logic, these fields could be  represented by either empty strings or `NULL` values, however, to simplify data handling and given that there isn't a clear advantage to creating a `NULL` state, we still opt for the empty string.
* Remove all units.
* Convert numerical fields to the appropriate data types.

```sql

```

#### Table Result



#### Key Operations


## Case Study Questions and Solutions
- [Part A. Pizza Metrics](#a-pizza-metrics)
- [Part B. Runner and Customer Experience](#b-runner-and-customer-experience)
- [Part C. Ingredient Optimisation](#c-ingredient-optimisation)
- [Part D. Pricing and Ratings](#d-pricing-and-ratings)
- [Part E. Bonus Questions](#e-bonus-questions)

***

## <a name="a-pizza-metrics"></a>Part A. Pizza Metrics

### 1. How many pizzas were ordered?<a name="q1"></a>

#### Query Result

| Total Pizzas Ordered |
|----------------------|
| Number               |

#### Key Operations

***

### 2. How many unique customer orders were made?<a name="q2"></a>

#### Query Result

| Unique Customer Orders |
|------------------------|
| Number                 |

#### Key Operations

***

### 3. How many successful orders were delivered by each runner?<a name="q3"></a>

#### Query Result

| Runner ID | Successful Orders |
|-----------|-------------------|
| ID        | Number            |

#### Key Operations

***

### 4. How many of each type of pizza was delivered?<a name="q4"></a>

#### Query Result

| Pizza Type | Number Delivered |
|------------|------------------|
| Type       | Number           |

#### Key Operations

***

### 5. How many Vegetarian and Meat Lovers were ordered by each customer?<a name="q5"></a>

#### Query Result

| Customer ID | Vegetarian | Meat Lovers |
|-------------|------------|-------------|
| ID          | Number     | Number      |

#### Key Operations

***

### 6. What was the maximum number of pizzas delivered in a single order?<a name="q6"></a>

#### Query Result

| Maximum Pizzas in Single Order |
|--------------------------------|
| Number                         |

#### Key Operations

***

### 7. For each customer, how many delivered pizzas had at least 1 change and how many had no changes?<a name="q7"></a>

#### Query Result

| Customer ID | Pizzas with Changes | Pizzas with No Changes |
|-------------|---------------------|------------------------|
| ID          | Number              | Number                 |

#### Key Operations

***

### 8. How many pizzas were delivered that had both exclusions and extras?<a name="q8"></a>

#### Query Result

| Pizzas with Both Exclusions and Extras |
|----------------------------------------|
| Number                                 |

#### Key Operations

***

### 9. What was the total volume of pizzas ordered for each hour of the day?<a name="q9"></a>

#### Query Result

| Hour of Day | Total Pizzas Ordered |
|-------------|----------------------|
| Hour        | Number               |

#### Key Operations

***

### 10. What was the volume of orders for each day of the week?<a name="q10"></a>

#### Query Result

| Day of the Week | Total Orders |
|-----------------|--------------|
| Day             | Number       |

#### Key Operations

***
***

## <a name="b-runner-and-customer-experience"></a>Part B. Runner and Customer Experience

### 1. How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)<a name="q1"></a>

#### Query Result

| Week Period | Runner Sign-ups |
|-------------|-----------------|
| Week        | Number          |

#### Key Operations

***

### 2. What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?<a name="q2"></a>

#### Query Result

| Runner ID | Average Pickup Time (min) |
|-----------|---------------------------|
| ID        | Time                      |

#### Key Operations

***

### 3. Is there any relationship between the number of pizzas and how long the order takes to prepare?<a name="q3"></a>

#### Query Result

| Number of Pizzas | Preparation Time |
|------------------|------------------|
| Number           | Time             |

#### Key Operations

***

### 4. What was the average distance travelled for each customer?<a name="q4"></a>

#### Query Result

| Customer ID | Average Distance Travelled |
|-------------|----------------------------|
| ID          | Distance                   |

#### Key Operations

***

### 5. What was the difference between the longest and shortest delivery times for all orders?<a name="q5"></a>

#### Query Result

| Longest Delivery Time | Shortest Delivery Time |
|-----------------------|------------------------|
| Time                  | Time                   |

#### Key Operations

***

### 6. What was the average speed for each runner for each delivery and do you notice any trend for these values?<a name="q6"></a>

#### Query Result

| Runner ID | Average Speed |
|-----------|---------------|
| ID        | Speed         |

#### Key Operations

***

### 7. What is the successful delivery percentage for each runner?<a name="q7"></a>

#### Query Result

| Runner ID | Successful Delivery Percentage |
|-----------|--------------------------------|
| ID        | Percentage                     |

#### Key Operations

***
***

## <a name="c-ingredient-optimisation"></a>Part C. Ingredient Optimisation

### 1. What are the standard ingredients for each pizza?<a name="q1"></a>

#### Query Result

| Pizza Type | Standard Ingredients |
|------------|----------------------|
| Type       | Ingredients          |

#### Key Operations

***

### 2. What was the most commonly added extra?<a name="q2"></a>

#### Query Result

| Extra Ingredient | Frequency |
|------------------|-----------|
| Ingredient       | Number    |

#### Key Operations

***

### 3. What was the most common exclusion?<a name="q3"></a>

#### Query Result

| Excluded Ingredient | Frequency |
|---------------------|-----------|
| Ingredient          | Number    |

#### Key Operations

***

### 4. Generate an order item for each record in the `customers_orders` table in the following format:<a name="q4"></a>
- `Meat Lovers`
- `Meat Lovers - Exclude Beef`
- `Meat Lovers - Extra Bacon`
- `Meat Lovers - Exclude Cheese, Bacon - Extra Mushroom, Peppers`

#### Query Result

| Order ID | Customized Order Item |
|----------|-----------------------|
| ID       | Order Description     |

#### Key Operations

***

### 5. Generate an alphabetically ordered comma separated ingredient list for each pizza order from the `customer_orders` table and add a 2x in front of any relevant ingredients<a name="q5"></a>
For example: `Meat Lovers: 2xBacon, Beef, ... , Salami`

#### Query Result

| Order ID | Ingredient List |
|----------|-----------------|
| ID       | List            |

#### Key Operations

***

### 6. What is the total quantity of each ingredient used in all delivered pizzas sorted by most frequent first?<a name="q6"></a>

#### Query Result

| Ingredient | Total Quantity |
|------------|----------------|
| Ingredient | Quantity       |

#### Key Operations

***
***

## <a name="d-pricing-and-ratings"></a>Part D. Pricing and Ratings

### 1. If a Meat Lovers pizza costs $12 and Vegetarian costs $10 and there were no charges for changes - how much money has Pizza Runner made so far if there are no delivery fees?<a name="q1"></a>

#### Query Result

| Total Revenue |
|---------------|
| Amount        |

#### Key Operations

***

### 2. What if there was an additional $1 charge for any pizza extras? Add cheese is $1 extra<a name="q2"></a>

#### Query Result

| Total Revenue with Extras |
|---------------------------|
| Amount                    |

#### Key Operations

***

### 3. Design a new table for a ratings system that allows customers to rate their runner - generate a schema and insert your own data for ratings for each successful customer order between 1 to 5.<a name="q3"></a>

#### Suggested Schema

| Column Name | Data Type | Description |
|-------------|-----------|-------------|
| ...         | ...       | ...         |

#### Sample Data

| customer_id | order_id | runner_id | rating |
|-------------|----------|-----------|--------|
| ID          | ID       | ID        | Rating |

#### Key Operations

***

### 4. Join all the information together to form a table for successful deliveries with the following information:<a name="q4"></a>
- customer_id
- order_id
- runner_id
- rating
- order_time
- pickup_time
- Time between order and pickup
- Delivery duration
- Average speed
- Total number of pizzas

#### Query Result

| customer_id | order_id | runner_id | rating | ... | Total Pizzas |
|-------------|----------|-----------|--------|-----|--------------|
| ID          | ID       | ID        | Rating | ... | Number       |

#### Key Operations

***

### 5. If a Meat Lovers pizza was $12 and Vegetarian $10 fixed prices with no cost for extras and each runner is paid $0.30 per kilometre traveled - how much money does Pizza Runner have left over after these deliveries?<a name="q5"></a>

#### Query Result

| Net Revenue |
|-------------|
| Amount      |

#### Key Operations

***
***

## <a name="e-bonus-questions"></a>Part E. Bonus Questions

### 1. If Danny wants to expand his range of pizzas, how would this impact the existing data design? Write an INSERT statement to demonstrate what would happen if a new Supreme pizza with all the toppings was added to the Pizza Runner menu?<a name="q1"></a>





