-- Singular test: a customer in 'repeat' must have orders_count > 3.

select customer_id, customer_segment, orders_count
from {{ ref('dim_customers') }}
where customer_segment = 'repeat' and orders_count <= 3
