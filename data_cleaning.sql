use ecommerce_analysis;

-- 1. check for null values

select 'customers' as table_name, count(*) as null_records
from customers
where customer_id is null
   or customer_name is null
   or gender is null
   or city is null
   or state is null
   or signup_date is null

union all

select 'products', count(*)
from products
where product_id is null
   or product_name is null
   or category is null
   or price is null

union all

select 'orders', count(*)
from orders
where order_id is null
   or customer_id is null
   or order_date is null
   or order_status is null

union all

select 'order_items', count(*)
from order_items
where order_item_id is null
   or order_id is null
   or product_id is null
   or quantity is null
   or unit_price is null

union all

select 'payments', count(*)
from payments
where payment_id is null
   or order_id is null
   or payment_method is null
   or payment_status is null
   or payment_date is null;


-- 2. check for duplicate records

select 'customers' as table_name, customer_id as id, count(*) as duplicate_count
from customers
group by customer_id
having count(*) > 1

union all

select 'products', product_id, count(*)
from products
group by product_id
having count(*) > 1

union all

select 'orders', order_id, count(*)
from orders
group by order_id
having count(*) > 1

union all

select 'order_items', order_item_id, count(*)
from order_items
group by order_item_id
having count(*) > 1

union all

select 'payments', payment_id, count(*)
from payments
group by payment_id
having count(*) > 1;


-- 3. check for invalid customer ids

select *
from orders
where customer_id not in (
    select customer_id
    from customers
);


-- 4. check for invalid product ids

select *
from order_items
where product_id not in (
    select product_id
    from products
);


-- 5. check for invalid order ids

select *
from order_items
where order_id not in (
    select order_id
    from orders
);


-- 6. check for negative or zero quantities

select *
from order_items
where quantity <= 0;


-- 7. check for invalid prices

select *
from products
where price <= 0;

select *
from order_items
where unit_price <= 0;


-- 8. check for invalid dates

select *
from customers
where signup_date > curdate();

select *
from orders
where order_date > curdate();

select *
from payments
where payment_date > curdate();


-- 9. check for invalid order statuses

select *
from orders
where order_status is null
   or order_status not in ('returned', 'delivered', 'cancelled');


-- 10. check for invalid payment statuses

select *
from payments
where payment_status is null
   or payment_status not in ('success', 'refunded', 'failed');


-- 11. check for invalid payment methods

select *
from payments
where payment_method is null
   or payment_method not in (
       'credit card',
       'upi',
       'debit card',
       'cash on delivery',
       'net banking'
   );


-- 12. check for inconsistent text values

select distinct gender
from customers;

select distinct category
from products;

select distinct order_status
from orders;

select distinct payment_method
from payments;

select distinct payment_status
from payments;


-- 13. check for orphan records

select oi.*
from order_items oi
left join orders o
on oi.order_id = o.order_id
where o.order_id is null;

select oi.*
from order_items oi
left join products p
on oi.product_id = p.product_id
where p.product_id is null;

select o.*
from orders o
left join customers c
on o.customer_id = c.customer_id
where c.customer_id is null;

select p.*
from payments p
left join orders o
on p.order_id = o.order_id
where o.order_id is null;


-- 14. check for duplicate orders

select order_id, count(*) as duplicate_count
from orders
group by order_id
having count(*) > 1;


-- 15. validate relationships between tables

select count(*) as invalid_customer_orders
from orders o
left join customers c
on o.customer_id = c.customer_id
where c.customer_id is null;

select count(*) as invalid_order_items
from order_items oi
left join orders o
on oi.order_id = o.order_id
where o.order_id is null;

select count(*) as invalid_product_items
from order_items oi
left join products p
on oi.product_id = p.product_id
where p.product_id is null;

select count(*) as invalid_payments
from payments p
left join orders o
on p.order_id = o.order_id
where o.order_id is null;