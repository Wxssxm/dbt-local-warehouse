with orders as (
  select * from {{ ref('stg_orders') }}
),

payments as (
  select
    order_id,
    sum(amount_eur) as total_amount_eur,
    count(*) as payment_count
  from {{ ref('stg_payments') }}
  group by 1
)

select
  o.order_id,
  o.customer_id,
  o.order_date,
  o.status,
  o.is_fulfilled,
  o.is_returned,
  coalesce(p.total_amount_eur, 0)::double as total_amount_eur,
  coalesce(p.payment_count, 0) as payment_count
from orders o
left join payments p on o.order_id = p.order_id
