with purchase_transactions as (
    select * from {{ ref('int_us_congress_transactions_fan_to_purchases') }}
),
purchases_by_congress_person as (
    select
      representative,
      political_party,
      us_state_served,
      count(is_capital_gains_over_two_hundred_usd) as amount_capital_gains_over_two_hundred,
      sum(min_amount_usd) as min_total_usd,
      sum(max_amount_usd) as max_total_amount,
      purchases as total_purchases
    from purchase_transactions
    group by
      representative,
      purchases,
      us_state_served,
      political_party
)
select * from purchases_by_congress_person
