with

source as (
  select
    *
  from
    {{ source('us_congress_investment', 'stock_transactions') }}
),

renamed as (
  select
    to_date(disclosure_date, 'MM/DD/YYYY') as disclosure_date,
    to_date(transaction_date, 'YYYY-MM-DD') as transaction_date,
    coalesce("owner", 'unknown') as owner,
    ticker,
    asset_description,
    "type" as transaction_type,
    case
      when amount in ('$1001 -') then 1
      when amount in ('$1,001 - $15,000', '$1,000 - $15,000') then 1000
      when amount in ('$15,000 - $50,000', '$15,001 - $50,000') then 15000
      when amount in ('$50,001 - $100,000') then 50000
      when amount in ('$100,001 - $250,000') then 100000
      when amount in ('$250,001 - $500,000') then 250000
      when amount in ('$500,001 - $1,000,000') then 500000
      when amount in ('$1,000,001 - $5,000,000', '$1,000,000 +', '$1,000,000 - $5,000,000') then 1000000
      when amount in ('$5,000,001 - $25,000,000') then 5000000
      when amount in ('$50,000,000 +') then 50000000
      else 1
    end as min_amount_usd,
    case
      when amount in ('$1001 -') then 1000
      when amount in ('$1,001 - $15,000', '$1,000 - $15,000') then 15000
      when amount in ('$15,000 - $50,000', '$15,001 - $50,000') then 50000
      when amount in ('$50,001 - $100,000') then 100000
      when amount in ('$100,001 - $250,000') then 250000
      when amount in ('$250,001 - $500,000') then 500000
      when amount in ('$500,001 - $1,000,000') then 1000000
      when amount in ('$1,000,001 - $5,000,000', '$1,000,000 +', '$1,000,000 - $5,000,000') then 5000000
      when amount in ('$5,000,001 - $25,000,000') then 25000000
      when amount in ('$50,000,000 +') then 500000000
      else 1
    end as max_amount_usd,
    representative,
    district as us_district_served,
    "state" as us_state_served,
    ptr_link as public_transaction_report_link,
    industry,
    sector,
    party as political_party,
    cap_gains_over_200_usd as is_capital_gains_over_two_hundred_usd
  from
    source
)
select * from renamed
