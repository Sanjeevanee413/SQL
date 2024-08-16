-- Advanced:
 use pizzahut;

-- Calculate the percentage contribution of 
-- each pizza type to total revenue.
select * from pizza_types;

select pizza_types.category,
sum(pizzas.price * orders_details.quantity) as revenue 
from pizza_types join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
join orders_details
on orders_details.pizza_id = pizzas.pizza_id
group by pizza_types.category; 

-- now we want persentage

SELECT 
    pizza_types.category,
    ROUND(SUM(pizzas.price * orders_details.quantity) / (SELECT 
                    round (SUM(pizzas.price * orders_details.quantity),2) AS total_sales
                FROM
                    orders_details
                        JOIN
                    pizzas ON pizzas.pizza_id = orders_details.pizza_id) * 100,
            2) AS revenue
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    orders_details ON orders_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.category
ORDER BY revenue DESC; 




-- Analyze the cumulative revenue generated over time.
select orders.order_date,
sum(orders_details.quantity * pizzas.price) as revenue
from orders_details join pizzas
on orders_details.pizza_id = pizzas.pizza_id
join orders
on orders.order_id= orders_details.order_id 
group by  orders.order_date;

-- Subquery
select order_date,
sum(revenue) over (order by order_date)as cum_revenue
from
(select orders.order_date,
sum(orders_details.quantity * pizzas.price) as revenue
from orders_details join pizzas
on orders_details.pizza_id = pizzas.pizza_id
join orders
on orders.order_id= orders_details.order_id 
group by  orders.order_date) as sales;



-- Determine the top 3 most ordered pizza types 
-- based on revenue for each pizza category.

select pizza_types.category, pizza_types.name,
sum(orders_details.quantity* pizzas.price) as revenue
from pizza_types join pizzas
on pizzas.pizza_type_id = pizzas.pizza_type_id
join
orders_details
on	orders_details.pizza_id =pizzas.pizza_id
group by pizza_types.category, pizza_types.name order by revenue desc;

-- we need ranking

select category, name, revenue,
rank() over (partition by category order by revenue desc) as rn
from
(select pizza_types.category, pizza_types.name,
sum(orders_details.quantity * pizzas.price) as revenue
from pizza_types join pizzas
on pizzas.pizza_type_id = pizzas.pizza_type_id
join
orders_details
on	orders_details.pizza_id =pizzas.pizza_id
group by pizza_types.category, pizza_types.name) 
as revenue_for_each_pizza;

-- we have not directlly using where clause so we using subquery
select name, revenue
 from
(select category, name, revenue,
rank() over (partition by category order by revenue desc) as rn
from
(select pizza_types.category, pizza_types.name,
sum(orders_details.quantity * pizzas.price) as revenue
from pizza_types join pizzas
on pizzas.pizza_type_id = pizzas.pizza_type_id
join
orders_details
on	orders_details.pizza_id =pizzas.pizza_id
group by pizza_types.category, pizza_types.name) 
as a) as b
where rn<=3;
