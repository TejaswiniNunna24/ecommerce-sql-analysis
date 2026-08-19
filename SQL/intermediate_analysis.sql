use ecommerce_analysis;

-- 1. average order value

select
    round(avg(order_total), 2) as average_order_value
from (
    select
        order_id,
        sum(quantity * unit_price) as order_total
    from order_items
    group by order_id
) as order_data;


-- 2. customers whose spending is above average

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
having total_spending > (
    select avg(customer_spending)
    from (
        select
            sum(oi2.quantity * oi2.unit_price) as customer_spending
        from orders o2
        join order_items oi2
        on o2.order_id = oi2.order_id
        group by o2.customer_id
    ) as spending
)
order by total_spending desc;


-- 3. customer segmentation based on spending

select
    c.customer_id,
    c.customer_name,
    sum(oi.quantity * oi.unit_price) as total_spending,
    case
        when sum(oi.quantity * oi.unit_price) >= 50000
            then 'high value'
        when sum(oi.quantity * oi.unit_price) >= 20000
            then 'medium value'
        else 'low value'
    end as customer_segment
from customers c
join orders o
on c.customer_id = o.customer_id
join order_items oi
on o.order_id = oi.order_id
group by c.customer_id, c.customer_name
order by total_spending desc;


-- 4. top 3 products in each category based on quantity sold

with product_sales as (
    select
        p.product_id,
        p.product_name,
        p.category,
        sum(oi.quantity) as total_quantity
    from products p
    join order_items oi
    on p.product_id = oi.product_id
    group by p.product_id, p.product_name, p.category
),
ranked_products as (
    select
        *,
        dense_rank() over (
            partition by category
            order by total_quantity desc
        ) as product_rank
    from product_sales
)
select *
from ranked_products
where product_rank <= 3
order by category, product_rank;


-- 5. purchase frequency of customers

select
    c.customer_id,
    c.customer_name,
    count(o.order_id) as total_orders
from customers c
join orders o
on c.customer_id = o.customer_id
group by c.customer_id, c.customer_name
order by total_orders desc;


-- 6. category revenue contribution

with category_sales as (
    select
        p.category,
        sum(oi.quantity * oi.unit_price) as category_revenue
    from products p
    join order_items oi
    on p.product_id = oi.product_id
    group by p.category
)
select
    category,
    category_revenue,
    round(
        category_revenue * 100.0 /
        sum(category_revenue) over (),
        2
    ) as revenue_percentage
from category_sales
order by category_revenue desc;


-- 7. customers with multiple orders

select
    c.customer_id,
    c.customer_name,
    count(o.order_id) as total_orders
from customers c
join orders o
on c.customer_id = o.customer_id
group by c.customer_id, c.customer_name
having count(o.order_id) > 1
order by total_orders desc;


-- 8. customers with only one order

select
    c.customer_id,
    c.customer_name,
    count(o.order_id) as total_orders
from customers c
join orders o
on c.customer_id = o.customer_id
group by c.customer_id, c.customer_name
having count(o.order_id) = 1;


-- 9. products that have never been ordered

select
    p.*
from products p
left join order_items oi
on p.product_id = oi.product_id
where oi.product_id is null;


-- 10. revenue by state

select
    c.state,
    sum(oi.quantity * oi.unit_price) as total_revenue
from customers c
join orders o
on c.customer_id = o.customer_id
join order_items oi
on o.order_id = oi.order_id
group by c.state
order by total_revenue desc;


-- 11. average spending by customer

select
    round(avg(total_spending), 2) as average_customer_spending
from (
    select
        o.customer_id,
        sum(oi.quantity * oi.unit_price) as total_spending
    from orders o
    join order_items oi
    on o.order_id = oi.order_id
    group by o.customer_id
) as customer_data;


-- 12. order value by order

select
    o.order_id,
    o.order_date,
    sum(oi.quantity * oi.unit_price) as order_total
from orders o
join order_items oi
on o.order_id = oi.order_id
group by o.order_id, o.order_date
order by order_total desc;


-- 13. products by revenue

select
    p.product_id,
    p.product_name,
    p.category,
    sum(oi.quantity * oi.unit_price) as total_revenue
from products p
join order_items oi
on p.product_id = oi.product_id
group by p.product_id, p.product_name, p.category
order by total_revenue desc;


-- 14. customers who have not ordered recently

select
    c.customer_id,
    c.customer_name,
    max(o.order_date) as last_order_date
from customers c
left join orders o
on c.customer_id = o.customer_id
group by c.customer_id, c.customer_name
having max(o.order_date) is null
    or datediff(
        (select max(order_date) from orders),
        max(o.order_date)
    ) > 90
order by last_order_date;
