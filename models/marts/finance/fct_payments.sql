{{ config(materialized='table', tags=['finance']) }}

select
  p.payment_id,
  p.order_id,
  o.customer_id,
  o.order_date as paid_for_order_date,
  o.status as order_status,
  p.payment_method,
  p.amount_eur
from {{ ref('stg_payments') }} p
inner join {{ ref('stg_orders') }} o on p.order_id = o.order_id
