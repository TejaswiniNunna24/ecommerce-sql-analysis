create database ecommerce_analysis;

use ecommerce_analysis;

create table customers (
    customer_id int primary key,
    customer_name varchar(100),
    gender varchar(10),
    city varchar(50),
    state varchar(50),
    signup_date date
);

create table products (
    product_id int primary key,
    product_name varchar(100),
    category varchar(50),
    price decimal(10,2)
);

create table orders (
    order_id int primary key,
    customer_id int,
    order_date date,
    order_status varchar(20),
    foreign key (customer_id) references customers(customer_id)
);

create table order_items (
    order_item_id int primary key,
    order_id int,
    product_id int,
    quantity int,
    unit_price decimal(10,2),
    foreign key (order_id) references orders(order_id),
    foreign key (product_id) references products(product_id)
);

create table payments (
    payment_id int primary key,
    order_id int,
    payment_method varchar(30),
    payment_status varchar(20),
    payment_date date,
    foreign key (order_id) references orders(order_id)
);

show tables;
