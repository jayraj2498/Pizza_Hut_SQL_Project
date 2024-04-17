select * from pizzas ;
select * from pizza_types ;
select * from orders ;
select * from order_details ; 


-- Q1 Retrieve the total number of orders placed  

select count(order_id) as total_orders from orders ;   

-- Q2 Calculate the total revenue generated from pizza sales.

select 
round(sum(order_details.quantity * pizzas.price),2) as Total_revenue_generated
from order_details join pizzas 
on pizzas.pizza_id = order_details.pizza_id ;


-- Q3  Identify the highest-priced pizza. 

SELECT 
pizza_id, price
FROM pizzas
WHERE price = (SELECT MAX(price) FROM pizzas); 

-- or  

select 
pizza_types.name , pizzas.price  as pizza_price
from pizza_types join pizzas 
on pizza_types.pizza_type_id = pizzas.pizza_type_id 
order by pizzas.price desc limit 1 ; 


-- Q4  Identify the most common pizza ordered in Quantity . 

select quantity , count(order_details_id) 
from order_details
group by quantity ;


-- Identify the most common pizza size ordered. 

select pizzas.size , count(order_details.order_details_id) as pizza_count
from pizzas join order_details 
on pizzas.pizza_id = order_details.pizza_id
group by  pizzas.size 
order by pizza_count desc ; 

-- Q5 List the top 5 most ordered pizza types along with their quantities.

select  pizza_types.name , sum(order_details.quantity) as order_Quantity
from pizza_types
join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id 
join order_details
on order_details.pizza_id = pizzas.pizza_id 
group by pizza_types.name 
order by order_Quantity desc   
limit 5 ; 


-- Q6.Join the necessary tables to :
-- find the total quantity of each pizza category ordered.

select 
pizza_types.category , sum(order_details.quantity) as pizzas_quantity
from pizza_types join pizzas 
on pizza_types.pizza_type_id = pizzas.pizza_type_id 
join order_details 
on order_details.pizza_id = pizzas.pizza_id 
group by pizza_types.category 
order by pizzas_quantity desc ;  

-- Q7. Determine the distribution of orders by hour of the day.
-- how many order we get wrt hour in a day 

select hour(order_time) as hours, count(order_id) as order_per_hour
from orders 
group by hours
order by hours asc ; 

-- Q8. Join relevant tables to find the category-wise distribution of pizzas.

select  category , count(name ) as count_pizza_categories 
from  pizza_types 
group by category;

-- Q9. Group the orders by date and calculate the  number of pizzas 
-- ordered per day.

select orders.order_date as Perdate, sum(order_details.quantity) as Quantity_per_day
from orders  join order_details
on orders.order_id = order_details.order_id 
group by Perdate
; 

-- Q10. Group the orders by date and calculate the average number of pizzas 
-- ordered per day.

select round(avg(Quantity_per_day),2) as avg_pizzas_per_day
from 
(select orders.order_date as Perdate, sum(order_details.quantity) as Quantity_per_day
from orders  join order_details
on orders.order_id = order_details.order_id 
group by Perdate ) as order_Quantity 
; 

-- Q.11 Determine the top 3 most ordered pizza types based on revenue.

select pizza_types.name as pizza_name, sum(order_details.quantity*pizzas.price) as revenue 
from pizza_types join pizzas 
on pizza_types.pizza_type_id = pizzas.pizza_type_id 
join order_details 
on order_details.pizza_id = pizzas.pizza_id 
group by pizza_name  
order by revenue desc 
limit 3; 

-- Q12.Calculate the percentage contribution of each pizza type to total revenue.


WITH t1 AS (
    SELECT pizza_types.category AS pizza_category, 
           SUM(order_details.quantity * pizzas.price) AS revenue 
    FROM pizza_types 
    JOIN pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id 
    JOIN order_details ON order_details.pizza_id = pizzas.pizza_id 
    GROUP BY pizza_category 
    ORDER BY revenue DESC 
)
SELECT pizza_category, 
	   revenue ,
       round((revenue / (SELECT SUM(revenue) FROM t1) * 100),2) AS revenue_percentage
FROM t1; 


-- Q 13 Analyze the cumulative revenue generated over time.
-- everday how much revenue is generated and incresed wrt perday  



select order_date,
sum(revenue) over (order by order_date) as cumulative_revenue
from 
(select orders.order_date , 
sum(order_details.quantity * pizzas.price) as revenue 
from order_details join pizzas 
on order_details.pizza_id = pizzas.pizza_id 
join orders 
on orders.order_id = order_details.order_id 
group by orders.order_date) as sales ; 



