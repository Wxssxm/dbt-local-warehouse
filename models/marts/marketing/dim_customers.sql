{{ config(materialized='table', tags=['marketing', 'core']) }}

with customers as (
  select * from {{ ref('stg_customers') }}
),

lifetime as (
  select * from {{ ref('int_customer_lifetime') }}
)

select
  c.customer_id,
  c.full_name,
  c.email,
  c.signup_date,
  coalesce(l.orders_count, 0) as orders_count,
  coalesce(l.orders_fulfilled, 0) as orders_fulfilled,
  coalesce(l.orders_returned, 0) as orders_returned,
  coalesce(l.lifetime_revenue_eur, 0)::double as lifetime_revenue_eur,
  l.first_order_date,
  l.last_order_date,
  case
    when l.orders_count is null then 'never_ordered'
    when l.orders_count = 1 then 'one_time'
    when l.orders_count <= 3 then 'occasional'
    else 'repeat'
  end as customer_segment
from customers c
left join lifetime l on c.customer_id = l.customer_id
