use ecommerce_analysis;

-- 1. total number of customers

select count(*) as total_customers
from customers;


-- 2. total number of products

select count(*) as total_products
from products;


-- 3. total number of orders

select count(*) as total_orders
from orders;


-- 4. total quantity sold

select sum(quantity) as total_quantity_sold
from order_items;


-- 5. total revenue

select sum(quantity * unit_price) as total_revenue
from order_items;


-- 6. average product price

select round(avg(price), 2) as average_product_price
from products;


-- 7. orders by status

select
    order_status,
    count(*) as order_count
from orders
group by order_status
order by order_count desc;


-- 8. customers by gender

select
    gender,
    count(*) as customer_count
from customers
group by gender
order by customer_count desc;


-- 9. products by category

select
    category,
    count(*) as product_count
from products
group by category
order by product_count desc;


-- 10. revenue by category

select
    p.category,
    sum(oi.quantity * oi.unit_price) as category_revenue
from products p
join order_items oi
on p.product_id = oi.product_id
group by p.category
order by category_revenue desc;


-- 11. top 10 products by quantity sold

select
    p.product_id,
    p.product_name,
    sum(oi.quantity) as total_quantity
from products p
join order_items oi
on p.product_id = oi.product_id
group by p.product_id, p.product_name
order by total_quantity desc
limit 10;


-- 12. top 10 customers by spending

select
    c.customer_id,
    c.customer_name,
    sum(oi.quantity * oi.unit_price) as total_spending
from customers c
join orders o
on c.customer_id = o.customer_id
join order_items oi
on o.order_id = oi.order_id
group by c.customer_id, c.customer_name
order by total_spending desc
limit 10;


-- 13. orders by month

select
    date_format(order_date, '%Y-%m') as month,
    count(*) as total_orders
from orders
group by month
order by month;


-- 14. revenue by month

select
    date_format(o.order_date, '%Y-%m') as month,
    sum(oi.quantity * oi.unit_price) as monthly_revenue
from orders o
join order_items oi
on o.order_id = oi.order_id
group by month
order by month;


-- 15. payment methods used

select
    payment_method,
    count(*) as payment_count
from payments
group by payment_method
order by payment_count desc;
