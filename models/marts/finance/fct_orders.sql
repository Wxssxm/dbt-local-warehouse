{{ config(materialized='table', tags=['finance', 'core']) }}

select
  order_id,
  customer_id,
  order_date,
  status,
  is_fulfilled,
  is_returned,
  total_amount_eur,
  payment_count,
  case
    when total_amount_eur = 0 then 'unpaid'
    when payment_count = 1 then 'single_payment'
    when payment_count > 1 then 'split_payment'
  end as payment_pattern
from {{ ref('int_orders_with_payments') }}
