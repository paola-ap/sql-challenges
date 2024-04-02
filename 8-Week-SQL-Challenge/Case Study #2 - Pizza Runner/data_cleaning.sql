/******************************************************************
** Data with Danny's 8 Week SQL Challenge - Pizza Runner
** Description: Data Cleaning
** SQL Flavor: PostgreSQL
******************************************************************/

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

DROP TABLE IF EXISTS temp_runner_orders;
CREATE TEMPORARY TABLE temp_runner_orders AS
    SELECT
        order_id,
        runner_id,
        CASE
            WHEN pickup_time = 'null' THEN NULL
            ELSE pickup_time::TIMESTAMP
        END AS pickup_time,
        CASE
            WHEN distance = 'null' THEN NULL
            ELSE regexp_replace(distance, '[^0-9.]', '', 'g')::FLOAT
        END AS distance,
        CASE
            WHEN duration = 'null' THEN NULL
            ELSE regexp_replace(duration, '[^0-9.]', '', 'g')::INTEGER
        END AS duration,
        CASE
            WHEN cancellation = 'null' OR cancellation IS NULL THEN ''
            ELSE cancellation
        END AS cancellation
FROM runner_orders;
