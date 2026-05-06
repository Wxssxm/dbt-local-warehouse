with source as (
  select * from {{ source('raw', 'raw_payments') }}
),

renamed as (
  select
    id as payment_id,
    order_id,
    payment_method,
    amount_cents,
    {{ cents_to_euros('amount_cents') }} as amount_eur
  from source
)

select * from renamed
