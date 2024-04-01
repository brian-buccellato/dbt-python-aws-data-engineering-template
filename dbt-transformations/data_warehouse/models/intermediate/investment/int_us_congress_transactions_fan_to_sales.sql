with sales as (
  select
    *
  from {{ ref('stg_us_congress_investment__transactions') }}
  where transaction_type in ('sale_full', 'sale_partial', 'sale')
),
add_transaction_counts_to_congress_person as (
  select
    *,
    count(*) over (partition by representative) as sales
  from sales
)
select * from add_transaction_counts_to_congress_person