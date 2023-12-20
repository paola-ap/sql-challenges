# Case Study #1 - Danny's Diner 
<p align="center">
<img src="https://user-images.githubusercontent.com/81607668/127727503-9d9e7a25-93cb-4f95-8bd0-20b87cb4b459.png" alt="Image" width="450" height="450">

## Table of Contents
- [Business Task](#business-task)
- [Datasets](#dataset)
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
```
```
#### Result
```
```
#### Explanation
