create database ecommerce_analysis;

use ecommerce_analysis;

create table customers (
    customer_id int,
    customer_name varchar(100),
    gender varchar(10),
    city varchar(50),
    state varchar(50),
    signup_date date
);

create table products (
    product_id int,
    product_name varchar(100),
    category varchar(50),
    price decimal(10,2)
);

create table orders (
    order_id int,
    customer_id int,
    order_date date,
    order_status varchar(20)
);

create table order_items (
    order_item_id int,
    order_id int,
    product_id int,
    quantity int,
    unit_price decimal(10,2)
);

create table payments (
    payment_id int,
    order_id int,
    payment_method varchar(30),
    payment_status varchar(20),
    payment_date date
);

show tables;