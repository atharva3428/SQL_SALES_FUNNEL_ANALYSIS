USE DATABASE SALES_FUNNEL_DB;

Use schema ANALYTICS;

select * from FUNNEL_EVENTS;


-- define sales funnel and different stages

with funnel_stages as (

select 
count(distinct case when event_type = 'page_view' then user_id end) as stage_1_views,
count(distinct case when event_type = 'add_to_cart' then user_id end) as stage_2_cart,
count(distinct case when event_type = 'checkout_start' then user_id end) as stage_3_checkout,
count(distinct case when event_type = 'payment_info' then user_id end) as stage_4_payment,
count(distinct case when event_type = 'purchase' then user_id end) as stage_5_purchase
from funnel_events 
where event_date >= dateadd(day, -90 , current_date())
)

select stage_1_views ,
       stage_2_cart,
       round(stage_2_cart * 100.0 / stage_1_views) as view_to_cart_rate,
       stage_3_checkout,
       round(stage_3_checkout * 100.0 / stage_2_cart) as cart_to_checkout_rate , 
       stage_4_payment,
       round(stage_4_payment * 100 / stage_3_checkout) as checkout_to_payment_rate,
       stage_5_purchase,
       round(stage_5_purchase * 100 / stage_4_payment) as payment_to_purchase_rate,
       round(stage_5_purchase * 100 / stage_1_views) as overall_conversion_rate
from funnel_stages



-- funnel by source

with source_funnel as (
select
traffic_source,
count(distinct case when event_type = 'page_view' then user_id end) as viewss,
count(distinct case when event_type = 'add_to_cart' then user_id end) as cart,
count(distinct case when event_type = 'checkout_start' then user_id end) as checkout,
count(distinct case when event_type = 'payment_info' then user_id end) as payment,
count(distinct case when event_type = 'purchase' then user_id end) as purchases
from funnel_events 
where event_date >= dateadd(day, -90 , current_date())
group by traffic_source
)
select traffic_source , viewss , cart , purchases , 
       round(cart * 100.0 / viewss) as cart_rate,
       round(purchases * 100.0 / viewss) as purchase_conversion_rate,
       round(purchases * 100.0 / cart) as cart_to_purchase_conversion_rate
from source_funnel
order by purchases desc;


-- time to conversion analysis

with user_journey as (
select
user_id,
min(case when event_type = 'page_view' then event_date end) as viewss,
min(case when event_type = 'add_to_cart' then event_date end) as cart,
-- MIN(case when event_type = 'checkout_start' then event_date end) as checkout,
MIN(case when event_type = 'payment_info' then event_date end) as payment,
MIN(case when event_type = 'purchase' then event_date end) as purchases
from funnel_events 
where event_date >= dateadd(day, -60 , current_date())
group by user_id 
having min(case when event_type = 'purchase' then event_date end) is not null)
select count(*) as converted_users ,
       avg(timestampdiff(minute , viewss, cart)) as avg_view_to_cart_minutes,
       avg(timestampdiff(minute ,cart, purchases)) as avg_cart_to_purchase_minutes,
       avg(timestampdiff(minute , viewss, purchases)) as avg_total_journey_minutes
from user_journey

-- revenue funnel analysis
with revenue_funnel as (
select
Count(Distinct case when event_type = 'page_view' then user_id end) as total_visitors,
Count(Distinct case when event_type = 'purchase' then user_id end) as total_buyers,
-- MIN(case when event_type = 'checkout_start' then event_date end) as checkout,
Sum(case when event_type = 'purchase' then amount end) as total_revenue,
Count(case when event_type = 'purchase' then 1 end) as total_orders
from funnel_events 
where event_date >= dateadd(day, -60 , current_date()))
select 
     total_visitors,
     total_buyers,
     total_orders,
     total_revenue,
     total_revenue / total_orders as avg_order_value,
     total_revenue / total_buyers as revenue_per_buyer
from revenue_funnel