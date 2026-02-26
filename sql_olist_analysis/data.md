## 数据表
create table orders(
    order_id varchar(50) primary key ,
    customer_id varchar(50),
    order_status varchar(20),
    order_purchase_timestamp datetime,
    order_approved_at datetime,
    order_delivered_carrier_date datetime,
    order_delivered_customer_date datetime,
    order_estimated_delivered_date datetime
);

create table order_items(
    order_id varchar(50) ,
    order_item_id int,
    product_id varchar(50),
    seller_id varchar(50),
    shipping_limit_date datetime,
    price decimal(10,2),
    freight_value decimal(10,2),
    primary key (order_id,order_item_id)
);

create table customers(
    customer_id varchar(50) primary key ,
    customer_unique_id varchar(50),
    customer_zip_code_prefix varchar(50),
    customer_city varchar(50),
    customer_state varchar(10)
);

create table products(
    product_id varchar(50) primary key ,
    product_category_name varchar(50),
    product_name_length int,
    product_description_length int,
    product_photos_qty int,
    product_weight_g int,
    product_length_cm int,
    product_height_cm int,
    product_width_cm int
);
