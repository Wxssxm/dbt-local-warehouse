-- Singular test: total_amount_eur in fct_orders should equal the sum of joined fct_payments per order.

with order_totals as (
    select order_id, total_amount_eur
    from {{ ref('fct_orders') }}
),

payment_totals as (
    select order_id, sum(amount_eur) as payments_sum
    from {{ ref('fct_payments') }}
    group by 1
)

select
    o.order_id,
    o.total_amount_eur,
    coalesce(p.payments_sum, 0) as payments_sum
from order_totals o
left join payment_totals p using (order_id)
where abs(o.total_amount_eur - coalesce(p.payments_sum, 0)) > 0.01
