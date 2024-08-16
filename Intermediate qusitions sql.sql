use pizzahut;
-- Join the necessary tables to find the total quantity of each pizza category ordered.

select pizza_types.category, orders_details.quantity
from pizza_types join pizzas
on	pizza_types.pizza_type_id = pizzas.pizza_type_id
join orders_details
on orders_details.pizza_id =pizzas.pizza_id;

select pizza_types.category, sum(orders_details.quantity) as quantity
from pizza_types join pizzas
on	pizza_types.pizza_type_id = pizzas.pizza_type_id
join orders_details
on orders_details.pizza_id =pizzas.pizza_id
group by pizza_types.category order by quantity desc;


-- Determine the distribution of orders by hour of the day.
select * from orders;
select order_time from orders;

select hour(order_time) from orders;


-- we need count of orders id also
select hour(order_time) as hours, count(order_id) as order_count 
from orders
group by hour(order_time);

-- Join relevant tables to find the category-wise distribution of pizzas.
select * from pizza_types;

select category, name from pizza_types;

select category, count(name) from pizza_types
group by category;

-- Group the orders by date and calculate the average number of pizzas ordered per day.

SELECT * FROM orders;

select orders.order_date AS Order_date, sum(orders_details.quantity) as order_quantity
from orders join orders_details
on orders.order_id = orders_details.order_id
group by Order_date;

-- we need total average over all day 
-- so we using subquer 

select avg(sum_Of_quantity) as Avg_Pizza_ordered_per_day from
(select orders.order_date AS Order_date, sum(orders_details.quantity) as sum_Of_quantity
from orders join orders_details
on orders.order_id = orders_details.order_id
group by Order_date) as order_quantity;

-- round fig value

select round(avg(sum_Of_quantity),0) as Avg_Pizza_ordered_per_day from
(select orders.order_date AS Order_date, sum(orders_details.quantity) as sum_Of_quantity
from orders join orders_details
on orders.order_id = orders_details.order_id
group by Order_date) as order_quantity;

-- Determine the top 3 most ordered pizza types based on revenue.
-- we need to jion 2 tabale
-- revenue = price*quantity

select * from pizza_types;
select * from pizzas;
select * from orders_details;

select pizza_types.name, 
orders_details.quantity * pizzas.price as revenue
from pizza_types join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
join orders_details
on orders_details.pizza_id = pizzas.pizza_id;

-- now we need to sum 
select pizza_types.name, 
sum(orders_details.quantity * pizzas.price) as revenue
from pizza_types join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
join orders_details
on orders_details.pizza_id = pizzas.pizza_id
group by pizza_types.name;

-- top 5 revenue

select pizza_types.name, 
sum(orders_details.quantity * pizzas.price) as revenue
from pizza_types join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
join orders_details
on orders_details.pizza_id = pizzas.pizza_id
group by pizza_types.name order by revenue limit 5;






