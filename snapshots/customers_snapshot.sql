{% snapshot customers_snapshot %}

{{
    config(
        target_schema='snapshots',
        unique_key='customer_id',
        strategy='check',
        check_cols=['email', 'first_name', 'last_name'],
        invalidate_hard_deletes=True,
    )
}}

select
    id as customer_id,
    first_name,
    last_name,
    email,
    signup_date
from {{ source('raw', 'raw_customers') }}

{% endsnapshot %}
