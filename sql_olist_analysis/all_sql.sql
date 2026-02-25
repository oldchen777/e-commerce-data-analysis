-- 业务需求:快速了解平台规模，需要知道有多少订单、产生多少交易额、覆盖多少独立用户。
## 总订单量
Select count(distinct order_id) as total_orders
    from orders
## 总GMV(商品交易总额)
select sum(price + freight_value) as total_gmv
    from order_items
## 总用户数
select count(distinct customer_unique_id) as total_customers
    from customers

-- 业务需求:了解2017-2018年业务增长情况，需要按月统计订单数和交易额，用于评估市场活动和制订下季度目标。
## 每月订单量与GMV趋势分析
select date_format(o.order_purchase_timestamp , '%Y-%m') as month,
       count(distinct o.order_id) as month_order,
       sum(oi.price + oi.freight_value) as month_gmv
    from orders o
inner join order_items oi
on o.order_id = oi.order_id
where o.order_status = 'delivered'
group by month
order by month

-- 业务需求:市场部想重点投放广告，需要知道哪些城市是销量最高的核心城市
## 各城市销量TOP10
select c.customer_city,
       count(distinct o.order_id) as city_orders
    from orders o
inner join customers c
on o.customer_id = c.customer_id
where o.order_status = 'delivered'
group by c.customer_city
order by city_orders desc
limit 10

-- 业务需求:想要了解用户粘性如何。
## 1.计算复购用户数。2.整体复购率(复购用户数/总用户数)。3.复购用户的订单分布。
with user_order_cnt as (select c.customer_unique_id,
       count(distinct o.order_id) as order_cnt
    from customers c
inner join orders o
on o.customer_id = c.customer_id
    where order_status = 'delivered'
group by c.customer_unique_id)
select count(distinct customer_unique_id) as total_users,
       sum(case when order_cnt > 1 then 1 else 0 end) as repeat_users,
       (sum(case when order_cnt > 1 then 1 else 0 end) / count(distinct customer_unique_id)) as repeat_rate,
       sum(case when order_cnt = 1 then 1 else 0 end) as one_time_user
    from user_order_cnt;

-- 业务需求:运营需要制订满减活动门槛，需要知道用户的平均客单价，确定活动设置在哪个区间最能刺激消费。
select avg(order_amount) as avg_order_amount,
       min(order_amount) as min_order_amount,
       max(order_amount) as max_order_amount
from
    (select sum(price + freight_value) as order_amount
    from orders o
inner join order_items oi
on o.order_id = oi.order_id
where order_status = 'delivered'
group by o.order_id ) as order_amounts;

-- 业务需求: 需要知道哪些品类最赚钱，哪些走量，用来做选品、库存和运营的重点
## 查询商品品类销量和销售额top10
select p.product_category_name,
       count(distinct oi.order_id) as order_cnt,
       sum(oi.price + oi.freight_value) as gmv
    from order_items oi
inner join products p
on oi.product_id = p.product_id
inner join orders o
on oi.order_id = o.order_id
    where order_status = 'delivered'
group by p.product_category_name
order by gmv desc
limit 10

-- 业务需求:统计各状态订单占比，找出流失原因
## 订单状态分析(取消、未支付、退款)
select orders.order_status,
       count(*) as cnt,
       count(*) / (select count(*) from orders) * 100 as pct
    from orders
group by order_status
order by cnt desc
