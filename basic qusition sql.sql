create database pizzahut;
use pizzahut;

create table orders (
order_id int not null primary key,
order_date date not null,
order_time time not null
);

create table orders_details (
order_detail_id int not null primary key,
order_id int not null,
pizza_id text not null,
quantity int not null
);


-- Retrieve the total number of orders placed.-- 

SELECT COUNT(order_id) AS total_orders FROM orders;

SELECT COUNT(*) AS total_orders FROM orders;

SELECT COUNT(DISTINCT order_id) AS total_orders FROM orders;

-- Calculate the total revenue generated from pizza sales. using join query

select (orders_details.quantity*pizzas.price) as total_sales 
from orders_details join pizzas
on orders_details.pizza_id = pizzas.pizza_id;

-- now we want sum
select sum(orders_details.quantity*pizzas.price) as total_sales 
from orders_details join pizzas
on orders_details.pizza_id = pizzas.pizza_id;

-- now we want 2 decimal point round figger (control+B for beutyfy code)

SELECT 
    ROUND(SUM(orders_details.quantity * pizzas.price),
            2) AS total_sales
FROM
    orders_details
        JOIN
    pizzas ON orders_details.pizza_id = pizzas.pizza_id;
    
    -- Identify the highest-priced pizza.
select pizza_types.name, pizzas.price
from pizza_types join pizzas 
on pizza_types.pizza_type_id = pizzas.pizza_type_id;

-- new use order by query.

select pizza_types.name, pizzas.price
from pizza_types join pizzas 
on pizza_types.pizza_type_id = pizzas.pizza_type_id
order by pizzas.price desc limit 10;

-- --Identify the most common pizza size ordered.
-- first we need to count of quantity count
select quantity, count(order_detail_id)
from orders_details group by(quantity);

-- second need to count size
select pizzas.size , count(orders_details.order_detail_id)
from pizzas join orders_details
on pizzas.pizza_id= orders_details.pizza_id
group by pizzas.size;

-- last now we want count hight value using order by and limit 

select pizzas.size , count(orders_details.order_detail_id) as Order_count
from pizzas join orders_details
on pizzas.pizza_id= orders_details.pizza_id
group by pizzas.size order by Order_count desc limit 5;

-- --List the top 5 most ordered pizza types 
-- along with their quantities.
-- we need join 3 table 
select pizza_types.name,orders_details.quantity
from pizza_types join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id 
join orders_details
on orders_details.pizza_id = pizzas.pizza_id;

-- now second stap we need to sum of quantity basis of pizza name
select pizza_types.name,
sum(orders_details.quantity)
from pizza_types join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id 
join orders_details
on orders_details.pizza_id = pizzas.pizza_id 
group by pizza_types.name;

-- now we need top 5 records

select pizza_types.name,
sum(orders_details.quantity) as quantity
from pizza_types join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id 
join orders_details
on orders_details.pizza_id = pizzas.pizza_id 
group by pizza_types.name order by quantity;

select pizza_types.name,
sum(orders_details.quantity) as quantity
from pizza_types join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id 
join orders_details
on orders_details.pizza_id = pizzas.pizza_id 
group by pizza_types.name order by quantity desc limit 5;




 




