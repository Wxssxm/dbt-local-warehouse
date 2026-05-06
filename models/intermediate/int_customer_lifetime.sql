with orders as (
  select * from {{ ref('int_orders_with_payments') }}
),

per_customer as (
  select
    customer_id,
    count(*) as orders_count,
    count(*) filter (where is_fulfilled) as orders_fulfilled,
    count(*) filter (where is_returned) as orders_returned,
    sum(total_amount_eur) filter (where is_fulfilled) as lifetime_revenue_eur,
    min(order_date) as first_order_date,
    max(order_date) as last_order_date
  from orders
  group by 1
)

select * from per_customer
