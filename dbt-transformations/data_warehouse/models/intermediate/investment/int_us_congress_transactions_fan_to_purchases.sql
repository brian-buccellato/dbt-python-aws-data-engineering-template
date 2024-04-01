with purchases as (
  select
    *
  from {{ ref('stg_us_congress_investment__transactions') }}
  where transaction_type = 'purchase'
),
add_transaction_counts_to_congress_person as (
  select
    *,
    count(*) over (partition by representative) as purchases
  from purchases
)
select * from add_transaction_counts_to_congress_person