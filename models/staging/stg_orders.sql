with source as (
  select * from {{ source('raw', 'raw_orders') }}
),

renamed as (
  select
    id as order_id,
    customer_id,
    order_date,
    status,
    coalesce(status in ('completed', 'shipped'), false) as is_fulfilled,
    coalesce(status in ('returned', 'return_pending'), false) as is_returned
  from source
)

select * from renamed
