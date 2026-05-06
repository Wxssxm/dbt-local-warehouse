{{ config(materialized='table', tags=['marketing']) }}

with customers as (
  select * from {{ ref('dim_customers') }}
),

cohorts as (
  select
    date_trunc('month', signup_date)::date as cohort_month,
    count(*) as customers_in_cohort,
    sum(orders_count) as orders_total,
    sum(lifetime_revenue_eur)::double as revenue_total_eur,
    round(avg(orders_count), 2) as avg_orders_per_customer,
    round(avg(lifetime_revenue_eur), 2) as avg_revenue_per_customer
  from customers
  group by cohort_month
)

select * from cohorts
order by cohort_month
