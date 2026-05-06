with source as (
  select * from {{ source('raw', 'raw_customers') }}
),

renamed as (
  select
    id as customer_id,
    first_name,
    last_name,
    first_name || ' ' || last_name as full_name,
    lower(email) as email,
    signup_date
  from source
)

select * from renamed
