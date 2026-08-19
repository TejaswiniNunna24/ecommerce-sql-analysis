use ecommerce_analysis;

-- 1. top 3 customers by spending

select
    c.customer_id,
    c.customer_name,
    sum(oi.quantity * oi.unit_price) as total_spending,
    rank() over (
        order by sum(oi.quantity * oi.unit_price) desc
    ) as spending_rank
from customers c
join orders o
on c.customer_id = o.customer_id
join order_items oi
on o.order_id = oi.order_id
group by c.customer_id, c.customer_name
order by spending_rank
limit 3;


-- 2. top 3 products in each category

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
    select *,
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


-- 3. running monthly revenue

with monthly_sales as (
    select
        date_format(o.order_date, '%Y-%m') as month,
        sum(oi.quantity * oi.unit_price) as monthly_revenue
    from orders o
    join order_items oi
    on o.order_id = oi.order_id
    group by month
)
select
    month,
    monthly_revenue,
    sum(monthly_revenue) over (
        order by month
    ) as running_revenue
from monthly_sales
order by month;


-- 4. month-over-month revenue growth

with monthly_sales as (
    select
        date_format(o.order_date, '%Y-%m') as month,
        sum(oi.quantity * oi.unit_price) as monthly_revenue
    from orders o
    join order_items oi
    on o.order_id = oi.order_id
    group by month
),
monthly_growth as (
    select
        month,
        monthly_revenue,
        lag(monthly_revenue) over (
            order by month
        ) as previous_monthly_revenue
    from monthly_sales
)
select
    month,
    monthly_revenue,
    previous_monthly_revenue,
    round(
        (monthly_revenue - previous_monthly_revenue) * 100.0
        / nullif(previous_monthly_revenue, 0),
        2
    ) as growth_percentage
from monthly_growth
order by month;


-- 5. highest-spending customer in each state

with customer_state_sales as (
    select
        c.state,
        c.customer_id,
        c.customer_name,
        sum(oi.quantity * oi.unit_price) as total_spending
    from customers c
    join orders o
    on c.customer_id = o.customer_id
    join order_items oi
    on o.order_id = oi.order_id
    group by c.state, c.customer_id, c.customer_name
),
ranked_customers as (
    select *,
           dense_rank() over (
               partition by state
               order by total_spending desc
           ) as customer_rank
    from customer_state_sales
)
select
    state,
    customer_id,
    customer_name,
    total_spending
from ranked_customers
where customer_rank = 1
order by state;


-- 6. category revenue percentage

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


-- 7. customers spending above the average customer spending

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
            o2.customer_id,
            sum(oi2.quantity * oi2.unit_price) as customer_spending
        from orders o2
        join order_items oi2
        on o2.order_id = oi2.order_id
        group by o2.customer_id
    ) as spending
)
order by total_spending desc;


-- 8. customer segmentation

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


-- 9. customers who have not ordered in the last 90 days

select
    c.customer_id,
    c.customer_name,
    max(o.order_date) as last_order_date
from customers c
join orders o
on c.customer_id = o.customer_id
group by c.customer_id, c.customer_name
having datediff(
    (select max(order_date) from orders),
    max(o.order_date)
) > 90
order by last_order_date;


-- 10. payment success rate

select
    round(
        sum(case
            when payment_status = 'success' then 1
            else 0
        end) * 100.0 / count(*),
        2
    ) as payment_success_rate
from payments;


-- 11. order status percentage

select
    order_status,
    count(*) as order_count,
    round(
        count(*) * 100.0 / (select count(*) from orders),
        2
    ) as percentage
from orders
group by order_status
order by order_count desc;


-- 12. revenue by state with ranking

with state_sales as (
    select
        c.state,
        sum(oi.quantity * oi.unit_price) as total_revenue
    from customers c
    join orders o
    on c.customer_id = o.customer_id
    join order_items oi
    on o.order_id = oi.order_id
    group by c.state
)
select
    state,
    total_revenue,
    rank() over (
        order by total_revenue desc
    ) as state_rank
from state_sales
order by state_rank;


-- 13. monthly average order value

with order_values as (
    select
        o.order_id,
        o.order_date,
        sum(oi.quantity * oi.unit_price) as order_total
    from orders o
    join order_items oi
    on o.order_id = oi.order_id
    group by o.order_id, o.order_date
)
select
    date_format(order_date, '%Y-%m') as month,
    round(avg(order_total), 2) as average_order_value
from order_values
group by month
order by month;


-- 14. customers above average order frequency

with customer_orders as (
    select
        customer_id,
        count(order_id) as total_orders
    from orders
    group by customer_id
)
select
    customer_id,
    total_orders
from customer_orders
where total_orders > (
    select avg(total_orders)
    from customer_orders
)
order by total_orders desc;
